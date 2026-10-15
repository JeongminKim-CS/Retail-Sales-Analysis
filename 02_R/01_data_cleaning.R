# ============================================================
# Project: Retail Sales Data Analysis
# Script: 01_data_cleaning.R
# Purpose: Import, inspect, and clean raw transaction data
# ============================================================

library(tidyverse)
library(readxl)

# ============================================================
# 1. Import Data
# ============================================================

sales_raw <- 
  read_excel(
  "01_data/01_raw/Online Retail.xlsx"
  )

# ============================================================
# 2. Initial Data Audit
# ============================================================

# Dataset dimensions
dim(
  sales_raw)

# Column names
colnames(
  sales_raw)

# Data structure and types
glimpse(sales_raw)

# Missing values
sales_raw %>%
  summarise(
    across(
      everything(),
      ~ sum(is.na(.))
      )
    )

# Exact duplicate rows
sum(
  duplicated(
    sales_raw))

# Quantity distribution
summary(
  sales_raw$Quantity)

# Unit price distribution
summary(
  sales_raw$UnitPrice)

# ============================================================
# 3. Investigate Negative Quantity
# ============================================================

# Negative quantity transactions
negative_quantity <- 
  sales_raw %>%
  dplyr::filter(
    Quantity < 0)

nrow(negative_quantity)
head(negative_quantity, 20)

# Non-positive unit price transactions
nonpositive_price <- sales_raw %>%
  dplyr::filter(UnitPrice <= 0)

nrow(nonpositive_price)
head(nonpositive_price, 20)


negative_quantity %>%
  dplyr::select(
    InvoiceNo, 
    StockCode, 
    Description, 
    Quantity, 
    UnitPrice
    ) %>%
  head(30)

# Check first character of InvoiceNo
negative_quantity %>%
  dplyr::count(
    substr(InvoiceNo, 1, 1), 
    sort = TRUE
    )

# Negative quantity transactions that are not cancellation invoice

negative_non_cancel <- 
  negative_quantity %>%
  dplyr::filter(
    !str_starts(InvoiceNo, "C")
    )

nrow(negative_non_cancel)

head(negative_non_cancel, 30)

negative_non_cancel %>%
  dplyr::count(Description, 
        sort = TRUE
        )

# ============================================================
# 4. Investigate Non-positive Unit Price
# ============================================================

nonpositive_price <- 
  sales_raw %>%
  dplyr::filter(
    UnitPrice <= 0
  )

nrow(nonpositive_price)

# Zero price transactions
zero_price <- 
  nonpositive_price %>%
  dplyr::filter(
    UnitPrice == 0
  )

zero_price %>%
  dplyr::count(
    Description,
    sort = TRUE
  )

# ============================================================
# 5. Classify Transaction Type
# ============================================================

sales_classified <-
  sales_raw %>%
  dplyr::mutate(
    transaction_type = 
      dplyr::case_when(
        str_starts(InvoiceNo, "C") ~ "Cancellation",
        Quantity < 0 ~ "Inventory adjustment",
        TRUE ~ "Sale"
        )
    )
  

sales_classified %>%
  dplyr::count(
    transaction_type,
    sort = TRUE
  )

# ============================================================
# 6. Data Cleaning Rules
# ============================================================

# For sales-performance analysis:
#
# 1. Remove exact duplicate rows
# 2. Retain valid cancellation transactions
#     (InvoiceNo starts with "C" and Quantity < 0)
# 3. Exclude non-cancellation inventory adjustments
#     (Quantity <= 0 without a cancellation InvoiceNo)
# 4. Exclude transactions with non-positive UnitPrice
# 5. Exclude accounting adjustment records
#     (Description == "Adjust bad debt")
# 6. Preserve missing CustomerID for overall sales analysis
# 7. Calculate Revenue as Quantity * UnitPrice
#     so cancellation transactions contribute negative Revenue

# ============================================================
# 7. Clean Data
# ============================================================

sales_clean <-
  sales_raw %>%
  dplyr::distinct() %>%
  dplyr::mutate(
    IsCancellation =
      stringr::str_starts(
        InvoiceNo,
        "C"
      )
  ) %>%
  dplyr::filter(
    UnitPrice > 0,
    Description != "Adjust bad debt",
    Quantity > 0 |
      (
        IsCancellation &
          Quantity < 0
      )
  ) %>%
  dplyr::mutate(
    Revenue = Quantity * UnitPrice
  )

# Cleaning QA
sales_clean %>%
  dplyr::summarise(
    Rows = dplyr::n(),
    Non_Cancellation_Negative =
      sum(
        !IsCancellation &
          Quantity <= 0
      ),
    Invalid_Cancellation =
      sum(
        IsCancellation &
          Quantity >= 0
      ),
    Non_Positive_Price =
      sum(UnitPrice <= 0),
    Adjust_Bad_Debt =
      sum(
        Description == "Adjust bad debt",
        na.rm = TRUE
      )
  )

# Cancellation impact
sales_clean %>%
  dplyr::summarise(
    Cancellation_Rows =
      sum(IsCancellation),
    Cancellation_Revenue =
      sum(
        Revenue[IsCancellation]
      ),
    Gross_Sales_Revenue =
      sum(
        Revenue[!IsCancellation]
      ),
    Net_Revenue =
      sum(Revenue)
  )

# ============================================================
# 8. Validate Cleaned Data
# ============================================================

# Compare dimensions
dim(sales_raw)
dim(sales_clean)

# Duplicate rows should be zero
sum(
  duplicated(sales_clean)
)

# Non-cancellation transactions should have positive Quantity
sales_clean %>%
  dplyr::filter(
    !IsCancellation,
    Quantity <= 0
  ) %>%
  nrow()

# Cancellation transactions should have negative Quantity
sales_clean %>%
  dplyr::filter(
    IsCancellation,
    Quantity >= 0
  ) %>%
  nrow()

# Non-positive UnitPrice should be zero
sales_clean %>%
  dplyr::filter(
    UnitPrice <= 0
  ) %>%
  nrow()

# Accounting adjustments should be excluded
sales_clean %>%
  dplyr::filter(
    Description == "Adjust bad debt"
  ) %>%
  nrow()

# Cancellation records should remain in the dataset
sales_clean %>%
  dplyr::filter(
    IsCancellation
  ) %>%
  nrow()

# ============================================================
# 9. Overall KPIs
# ============================================================

net_revenue <-
  sum(sales_clean$Revenue)

total_orders <-
  sales_clean %>%
  dplyr::filter(
    !IsCancellation
  ) %>%
  dplyr::summarise(
    Orders = dplyr::n_distinct(InvoiceNo)
  ) %>%
  dplyr::pull(Orders)

total_customers <-
  sales_clean %>%
  dplyr::filter(
    !IsCancellation
  ) %>%
  dplyr::summarise(
    Customers = dplyr::n_distinct(
      CustomerID,
      na.rm = TRUE
    )
  ) %>%
  dplyr::pull(Customers)

aov <-
  net_revenue / total_orders

overall_kpis <-
  tibble::tibble(
    Net_Revenue = net_revenue,
    Orders = total_orders,
    Customers = total_customers,
    AOV = aov
  )

overall_kpis

# ============================================================
# 10. Save Processed Data
# ============================================================

readr::write_csv(
  sales_clean,
  "01_data/02_processed/sales_clean.csv"
)