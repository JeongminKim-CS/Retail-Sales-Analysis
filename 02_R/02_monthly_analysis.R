# ============================================================
# Project: Retail Sales Data Analysis
# Script: 02_monthly_analysis.R
# Purpose: Analyze monthly sales performance
# ============================================================

library(tidyverse)
library(lubridate)

# ============================================================
# 1. Import Cleaned Data
# ============================================================

sales_clean <- read_csv(
  "01_data/02_processed/sales_clean.csv",
  show_col_types = FALSE
)


# ============================================================
# 2. Monthly Performance
# ============================================================

monthly_sales <-
  sales_clean %>%
  dplyr::mutate(
    InvoiceMonth =
      floor_date(
        InvoiceDate,
        "month"
        )
    ) %>%
  group_by(
    InvoiceMonth
    ) %>%
  summarise(
    Revenue =
      sum(Revenue),
    Orders =
      n_distinct(InvoiceNo),
    Customers =
      n_distinct(
        CustomerID,
        na.rm = TRUE),
    .groups =
      "drop"
    ) %>%
  dplyr::mutate(
    AOV = Revenue / Orders
  )

monthly_sales

# ============================================================
# 3. Highest Revenue Months
# ============================================================

monthly_sales %>%
  arrange(
    desc(Revenue)
  ) %>%
  head()


# ============================================================
# 4. Monthly Revenue Visualization
# ============================================================

monthly_sales %>%
  ggplot(
    aes(
      x = InvoiceMonth,
      y = Revenue
    )
  ) +
  geom_line() +
  geom_point() +
  labs(
    title = "Monthly Revenue Trend",
    x = "Month",
    y = "Revenue"
  ) +
  scale_y_continuous(
    labels = scales::label_number(
      scale = 1e-6,
      suffix = "M"
    )
  ) +
  scale_x_date(
    date_breaks = "1 month",
    date_labels = "%b\n%Y"
  ) +
  theme_classic() +
  theme(
    axis.text.x = element_text(
      angle = 45,
      hjust = 1
    )
  )


# ============================================================
# 5. Sep-Nov Performance Change
# ============================================================

performance_change_sep_nov <-
  monthly_sales %>%
  dplyr::filter(
    year(InvoiceMonth) == 2011,
    month(InvoiceMonth) %in% c(9, 11)
  ) %>%
  dplyr::mutate(
    month_label = month(
      InvoiceMonth,
      label = TRUE,
      abbr = TRUE,
      locale = "en_US.UTF-8"
    )
  ) %>%
  dplyr::select(
    month_label,
    Revenue,
    Orders,
    Customers,
    AOV
  ) %>%
  pivot_wider(
    names_from =
      month_label,
    values_from =
      c(
        Revenue,
        Orders,
        Customers,
        AOV
      )
  ) %>%
  dplyr::mutate(
    Revenue_change_pct =
      (Revenue_Nov - Revenue_Sep) / Revenue_Sep * 100,
    Orders_change_pct =
      (Orders_Nov - Orders_Sep) / Orders_Sep * 100,
    Customers_change_pct =
      (Customers_Nov - Customers_Sep) / Customers_Sep * 100,
    AOV_change_pct =
      (AOV_Nov - AOV_Sep) / AOV_Sep * 100
  )

revenue_growth_sep_nov