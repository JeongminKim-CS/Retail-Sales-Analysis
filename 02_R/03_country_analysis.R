# ============================================================
# Project: Retail Sales Data Analysis
# Script: 03_country_analysis.R
# Purpose: Analyze sales performance by country
# ============================================================

library(tidyverse)

# ============================================================
# 1. Import Cleaned Data
# ============================================================

sales_clean <- read_csv(
  "01_data/02_processed/sales_clean.csv",
  col_types = cols(
    InvoiceNo = col_character(),
    StockCode = col_character(),
    Description = col_character(),
    Quantity = col_integer(),
    InvoiceDate = col_datetime(),
    UnitPrice = col_double(),
    CustomerID = col_double(),
    Country = col_character(),
    Revenue = col_double()
  )
)

# ============================================================
# 2. Country-Level Performance
# ============================================================

country_sales <-
  sales_clean %>%
  dplyr::group_by(
    Country
  ) %>%
  dplyr::summarise(
    Revenue = sum(Revenue),
    Orders = dplyr::n_distinct(
      InvoiceNo,
      na.rm = TRUE
    ),
    Customers = dplyr::n_distinct(
      CustomerID,
      na.rm = TRUE
    ),
    .groups = "drop"
  )

# ============================================================
# 3. Country Revenue Ranking
# ============================================================

country_sales_ranked <-
  country_sales %>%
  dplyr::arrange(
    dplyr::desc(Revenue)
  )

country_sales_ranked %>%
  dplyr::slice_head(
    n = 10
  )

# ============================================================
# 4. Country Revenue Share
# ============================================================

country_sales_ranked <- 
  country_sales_ranked %>%
  dplyr::mutate(
    Revenue_Share = Revenue / sum(Revenue) * 100
  )

country_sales_ranked %>%
  dplyr::slice_head(
    n = 10
  )

# ============================================================
# 5. Country Revenue Visualization
# ============================================================

top_10_countries <-
  country_sales_ranked %>%
  dplyr::slice_head(
    n = 10
  )

country_revenue_plot <-
  ggplot(
    top_10_countries,
    aes(
      x = reorder(Country, Revenue),
      y = Revenue
    )
  ) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 Countries by Revenue",
    x = "Country",
    y = "Revenue"
  ) +
  theme_classic() +
  scale_y_continuous(
    labels = scales::label_number(
      scale = 1e-6,
      suffix = "M"
    )
  )

country_revenue_plot

ggsave(
  filename = "03_figures/country_revenue_top10.png",
  plot = country_revenue_plot,
  width = 8,
  height = 5,
  dpi = 300
)


# ============================================================
# 6. Market Concentration
# ============================================================

top_5_revenue_share <-
  country_sales_ranked %>%
  dplyr::slice_head(
    n = 5
  ) %>%
  dplyr::summarise(
    Revenue_Share = sum(Revenue_Share)
  )

top_5_revenue_share