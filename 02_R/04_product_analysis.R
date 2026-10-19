# ============================================================
# Project: Retail Sales Data Analysis
# Script: 04_product_analysis.R
# Purpose: Analyze sales performance by product
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
# 2. Prepare Product Transactions
# ============================================================

non_product_codes <-
  c(
    "AMAZONFEE",
    "BANK CHARGES",
    "C2",
    "CRUK",
    "D",
    "DOT",
    "M",
    "POST",
    "S"
  )

product_data <-
  sales_clean %>%
  dplyr::mutate(
    ProductCode =
      stringr::str_to_upper(
        StockCode
      )
  ) %>%
  dplyr::filter(
    !ProductCode %in% non_product_codes,
    !stringr::str_starts(
      ProductCode,
      "GIFT_"
    )
  )

# Representative description for each product
product_descriptions <-
  product_data %>%
  dplyr::filter(
    !is.na(Description)
  ) %>%
  dplyr::count(
    ProductCode,
    Description,
    name = "Description_Count"
  ) %>%
  dplyr::group_by(
    ProductCode
  ) %>%
  dplyr::slice_max(
    Description_Count,
    n = 1,
    with_ties = FALSE
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(
    ProductCode,
    Description
  )

# ============================================================
# 3. Product-Level Performance
# ============================================================

product_sales <-
  product_data %>%
  dplyr::group_by(
    ProductCode
  ) %>%
  dplyr::summarise(
    Net_Revenue =
      sum(Revenue),
    
    Net_Quantity =
      sum(Quantity),
    
    Sales_Orders =
      dplyr::n_distinct(
        InvoiceNo[!IsCancellation]
      ),
    
    .groups = "drop"
  ) %>%
  dplyr::left_join(
    product_descriptions,
    by = "ProductCode"
  ) %>%
  dplyr::select(
    ProductCode,
    Description,
    Net_Revenue,
    Net_Quantity,
    Sales_Orders
  )

# ============================================================
# 4. Top Products by Net Revenue
# ============================================================

top_products_revenue <-
  product_sales %>%
  dplyr::arrange(
    dplyr::desc(Net_Revenue)
  ) %>%
  dplyr::slice_head(
    n = 10
  )

top_products_revenue

# ============================================================
# 5. Top Products by Net Quantity
# ============================================================

top_products_quantity <-
  product_sales %>%
  dplyr::arrange(
    dplyr::desc(Net_Quantity)
  ) %>%
  dplyr::slice_head(
    n = 10
  )

top_products_quantity

# ============================================================
# 6. Compare Revenue and Quantity Rankings
# ============================================================

revenue_ranking <-
  product_sales %>%
  dplyr::arrange(
    dplyr::desc(Net_Revenue)
  ) %>%
  dplyr::mutate(
    Revenue_Rank =
      dplyr::row_number()
  )

quantity_ranking <-
  product_sales %>%
  dplyr::arrange(
    dplyr::desc(Net_Quantity)
  ) %>%
  dplyr::mutate(
    Quantity_Rank = 
      dplyr::row_number()
  )

product_rankings <-
  revenue_ranking %>%
  dplyr::select(
    ProductCode,
    Description,
    Net_Revenue,
    Net_Quantity,
    Revenue_Rank
  ) %>%
  dplyr::left_join(
    quantity_ranking %>%
      dplyr::select(
        ProductCode,
        Quantity_Rank
      ),
    by = "ProductCode"
  )

product_rankings %>%
  dplyr::filter(
    Revenue_Rank <= 10 |
      Quantity_Rank <= 10
  ) %>%
  dplyr::arrange(
    Revenue_Rank
  )

# ============================================================
# 7. Product Revenue Visualization
# ============================================================

product_revenue_plot <-
  ggplot(
    top_products_revenue,
    aes(
      x = reorder(
        Description,
        Net_Revenue
      ),
      y = Net_Revenue
    )
  ) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 Products by Net Revenue",
    x = "Product",
    y = "Net Revenue"
  ) +
  scale_y_continuous(
    labels = scales::label_number(
      scale = 1e-3,
      suffix = "K"
    )
  ) +
  theme_classic()

product_revenue_plot

ggsave(
  filename = "03_figures/product_revenue_top10.png",
  plot = product_revenue_plot,
  width = 9,
  height = 6,
  dpi = 300
)

# ============================================================
# 8. Final Product-Level QA
# ============================================================

# One row per ProductCode
nrow(product_sales) ==
  dplyr::n_distinct(
    product_sales$ProductCode
  )

# Missing representative descriptions
sum(
  is.na(
    product_sales$Description
  )
)

# Non-product codes should not remain
product_sales %>%
  dplyr::filter(
    ProductCode %in% non_product_codes |
      stringr::str_starts(
        ProductCode,
        "GIFT_"
      )
  ) %>%
  nrow()