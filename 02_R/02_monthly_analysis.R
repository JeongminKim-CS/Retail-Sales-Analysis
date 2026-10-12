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
# 2. Monthly Revenue
# ============================================================

monthly_sales <- sales_clean %>%
  mutate(
    InvoiceMonth = floor_date(
      InvoiceDate,
      "month"
    )
  ) %>%
  group_by(InvoiceMonth) %>%
  summarise(
    Revenue = sum(Revenue),
    .groups = "drop"
  )


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
# 5. Sep-Nov Revenue Growth
# ============================================================

revenue_growth_sep_nov <- monthly_sales %>%
  filter(
    year(InvoiceMonth) == 2011,
    month(InvoiceMonth) %in% c(9, 11)
  ) %>%
  mutate(
    month_label = month(
      InvoiceMonth,
      label = TRUE,
      abbr = TRUE,
      locale = "en_US.UTF-8"
    )
  ) %>%
  select(
    month_label,
    Revenue
  ) %>%
  pivot_wider(
    names_from = month_label,
    values_from = Revenue
  ) %>%
  mutate(
    Revenue_change_pct =
      (Nov - Sep) / Sep * 100
  )

revenue_growth_sep_nov