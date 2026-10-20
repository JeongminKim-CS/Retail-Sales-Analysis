# ============================================================
# Project: Retail Sales Data Analysis
# Script: 05_customer_analysis.R
# Purpose: Analyze sales performance by customer
# ============================================================

library(tidyverse)

# ============================================================
# 1. Import Cleaned Data
# ============================================================

sales_clean <-
  readr::read_csv(
    "01_data/02_processed/sales_clean.csv",
    col_types = readr::cols(
      InvoiceNo = readr::col_character(),
      StockCode = readr::col_character(),
      Description = readr::col_character(),
      Quantity = readr::col_integer(),
      InvoiceDate = readr::col_datetime(),
      UnitPrice = readr::col_double(),
      CustomerID = readr::col_double(),
      Country = readr::col_character(),
      IsCancellation = readr::col_logical(),
      Revenue = readr::col_double()
    )
  )

# ============================================================
# 2. Customer-Level Performance
# ============================================================

customer_sales <-
  sales_clean %>%
  dplyr::filter(
    !is.na(CustomerID)
  ) %>%
  dplyr::group_by(
    CustomerID
  ) %>%
  dplyr::summarise(
    Net_Revenue = sum(Revenue),

    Sales_Orders =
      dplyr::n_distinct(
        InvoiceNo[!IsCancellation]
      ),

    .groups = "drop"
  )

# ============================================================
# 3. Customer-Level QA
# ============================================================

# Use near() to avoid classifying floating-point values
# extremely close to zero as positive or negative revenue.

customer_sales %>%
  dplyr::summarise(
    Customers =
      dplyr::n(),

    Negative_Net_Revenue =
      sum(
        Net_Revenue < 0 &
          !dplyr::near(
            Net_Revenue,
            0
          )
      ),

    Zero_Net_Revenue =
      sum(
        dplyr::near(
          Net_Revenue,
          0
        )
      ),

    Zero_Sales_Orders =
      sum(
        Sales_Orders == 0
      )
  )

# Active customers with at least one non-cancellation sales order
customer_sales_active <-
  customer_sales %>%
  dplyr::filter(
    Sales_Orders > 0
  )

nrow(customer_sales_active)

# ============================================================
# 4. Top Customers by Net Revenue
# ============================================================

top_customers_revenue <-
  customer_sales_active %>%
  dplyr::arrange(
    dplyr::desc(Net_Revenue)
  ) %>%
  dplyr::slice_head(
    n = 10
  )

top_customers_revenue

# ============================================================
# 5. Revenue Concentration
# ============================================================

customer_sales_ranked <-
  customer_sales_active %>%
  dplyr::arrange(
    dplyr::desc(Net_Revenue)
  )

active_customer_net_revenue <-
  sum(
    customer_sales_active$Net_Revenue
  )

top_10_customer_share <-
  customer_sales_ranked %>%
  dplyr::slice_head(
    n = 10
  ) %>%
  dplyr::summarise(
    Revenue_Share =
      sum(Net_Revenue) /
      active_customer_net_revenue *
      100
  )

top_1_pct_n <-
  ceiling(
    nrow(customer_sales_active) *
      0.01
  )

top_1_pct_customer_share <-
  customer_sales_ranked %>%
  dplyr::slice_head(
    n = top_1_pct_n
  ) %>%
  dplyr::summarise(
    Customers = dplyr::n(),
    Revenue_Share =
      sum(Net_Revenue) /
      active_customer_net_revenue *
      100
  )

top_10_customer_share
top_1_pct_n
top_1_pct_customer_share

# Revenue coverage

overall_net_revenue <-
  sum(
    sales_clean$Revenue
  )

identified_customer_net_revenue <-
  sales_clean %>%
  dplyr::filter(
    !is.na(CustomerID)
  ) %>%
  dplyr::summarise(
    Net_Revenue = sum(Revenue)
  ) %>%
  dplyr::pull(Net_Revenue)

identified_customer_coverage <-
  identified_customer_net_revenue /
  overall_net_revenue *
  100

active_customer_coverage <-
  active_customer_net_revenue /
  overall_net_revenue *
  100

# Cancellation-only customers

cancellation_only_customers <-
  customer_sales %>%
  dplyr::filter(
    Sales_Orders == 0
  )

cancellation_only_customers %>%
  dplyr::summarise(
    Customers = dplyr::n(),
    Net_Revenue = sum(Net_Revenue)
  )

identified_customer_coverage
active_customer_coverage

# ============================================================
# 6. Customer Revenue Visualization
# ============================================================

customer_revenue_plot <-
  ggplot(
    top_customers_revenue,
    aes(
      x = reorder(
        as.factor(CustomerID),
        Net_Revenue
      ),
      y = Net_Revenue
    )
  ) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 Customers by Net Revenue",
    x = "Customer ID",
    y = "Net Revenue"
  ) +
  scale_y_continuous(
    labels = scales::label_number(
      scale = 1e-3,
      suffix = "K"
    )
  ) +
  theme_classic()

customer_revenue_plot

ggsave(
  filename = "03_figures/customer_revenue_top10.png",
  plot = customer_revenue_plot,
  width = 8,
  height = 5,
  dpi = 300
)

# ============================================================
# 7. Final Customer-Level QA
# ============================================================

expected_active_customers <-
  sales_clean %>%
  dplyr::filter(
    !IsCancellation,
    !is.na(CustomerID)
  ) %>%
  dplyr::summarise(
    Customers =
      dplyr::n_distinct(CustomerID)
  ) %>%
  dplyr::pull(Customers)

# Active customer count should match sales data
nrow(customer_sales_active) ==
  expected_active_customers

# CustomerID should never be missing
sum(
  is.na(
    customer_sales_active$CustomerID
  )
) == 0

# Active customers should all have at least one sales order
sum(
  customer_sales_active$Sales_Orders <= 0
) == 0

top_10_customer_share
top_1_pct_n
top_1_pct_customer_share
identified_customer_coverage
active_customer_coverage

customer_sales %>%
  dplyr::summarise(
    Customers =
      dplyr::n(),

    Negative_Net_Revenue =
      sum(
        Net_Revenue < 0 &
          !dplyr::near(
            Net_Revenue,
            0
          )
      ),

    Zero_Net_Revenue =
      sum(
        dplyr::near(
          Net_Revenue,
          0
        )
      ),

    Zero_Sales_Orders =
      sum(
        Sales_Orders == 0
      )
  )