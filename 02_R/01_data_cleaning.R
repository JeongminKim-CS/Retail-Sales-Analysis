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

# Zero pirce transactions
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
# 6. Data cleaning Rules
# ============================================================

# For sales-performance analysis:
#
# 1. Remove exact duplicate rows
# 2. Exclude cancelled transactions
#     (InvoiceNo starts with "C)
# 3. Exclude non-sale inventory adjustments
#     (Quantity <= 0)
# 4. Exclude transactions with non-positive UnitPrice
# 5. Preserve missing CustomerID for overall sales analysis


# ============================================================
# 7. Clean Data
# ============================================================

sales_clean <-
  sales_raw %>%
  dplyr::distinct() %>%
  dplyr::filter(
    !str_starts(
      InvoiceNo,
      "C"
      ),
    Quantity > 0,
    UnitPrice > 0
    ) %>%
  dplyr::mutate(
    Revenue = Quantity * UnitPrice
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

# Quantity should be positive
min(
  sales_clean$Quantity
  )

# Unit price should be positive
min(
  sales_clean$UnitPrice
  )

# Cancelled invoices should be zero
sales_clean %>%
  dplyr::filter(
    str_starts(
      InvoiceNo, 
      "C"
    )
  ) %>%
  nrow()

# ============================================================
# 9. Overall KPIs
# ============================================================

sales_clean %>%
  dplyr::summarise(
    total_revenue = 
      sum(Revenue),
    total_orders = 
      n_distinct(InvoiceNo),
    total_customers =
      n_distinct(
        CustomerID,
        na.rm = TRUE
      ),
    aov = total_revenue / total_orders
  )

# ============================================================
# 10. Save Processed Data
# ============================================================

write_csv(
  sales_clean,
  "01_data/02_processed/sales_clean.csv"
)