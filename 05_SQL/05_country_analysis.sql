-- ============================================================
-- Retail Sales Analysis
-- Country Performance Analysis
-- ============================================================

USE retail_sales_analysis;


-- ============================================================
-- 1. Country Performance
-- ============================================================

SELECT
  Country,

  ROUND(
    SUM(Revenue),
    3
  ) AS Net_Revenue,

  COUNT(
    DISTINCT CASE
      WHEN IsCancellation = 0
      THEN InvoiceNo
    END
  ) AS Sales_Orders,

  COUNT(
    DISTINCT CASE
      WHEN IsCancellation = 0
      THEN CustomerID
    END
  ) AS Active_Customers,

  ROUND(
    SUM(Revenue) /
    SUM(SUM(Revenue)) OVER () *
    100,
    2
  ) AS Revenue_Share_Pct

FROM retail_sales

GROUP BY
  Country

ORDER BY
  Net_Revenue DESC;

-- ============================================================
-- 2. Top Five Countries Revenue Concentration
-- ============================================================

WITH country_performance AS (
  SELECT
    Country,
    SUM(Revenue) AS Net_Revenue

  FROM retail_sales

  GROUP BY
    Country
),

country_ranked AS (
  SELECT
    Country,
    Net_Revenue,

    ROW_NUMBER() OVER (
      ORDER BY Net_Revenue DESC
    ) AS Revenue_Rank

  FROM country_performance
)

SELECT
  ROUND(
    SUM(
      CASE
        WHEN Revenue_Rank <= 5
        THEN Net_Revenue
        ELSE 0
      END
    ) /
    SUM(Net_Revenue) *
    100,
    1
  ) AS Top_5_Revenue_Share_Pct

FROM country_ranked;