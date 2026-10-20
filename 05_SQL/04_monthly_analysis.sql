-- ============================================================
-- Retail Sales Analysis
-- Monthly Performance Analysis
-- ============================================================

USE retail_sales_analysis;


-- ============================================================
-- 1. Monthly Performance
-- ============================================================

SELECT
  DATE_FORMAT(
    InvoiceDate,
    '%Y-%m'
  ) AS Month,

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
    COUNT(
      DISTINCT CASE
        WHEN IsCancellation = 0
        THEN InvoiceNo
      END
    ),
    2
  ) AS AOV

FROM retail_sales

GROUP BY
  DATE_FORMAT(
    InvoiceDate,
    '%Y-%m'
  )

ORDER BY
  Month;

-- ============================================================
-- 2. September to November Change
-- ============================================================

WITH monthly_performance AS (
  SELECT
    DATE_FORMAT(
      InvoiceDate,
      '%Y-%m'
    ) AS Month,

    SUM(Revenue) AS Net_Revenue,

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
    ) AS Active_Customers

  FROM retail_sales

  GROUP BY
    DATE_FORMAT(
      InvoiceDate,
      '%Y-%m'
    )
),

monthly_kpis AS (
  SELECT
    Month,
    Net_Revenue,
    Sales_Orders,
    Active_Customers,
    Net_Revenue / Sales_Orders AS AOV

  FROM monthly_performance
),

sep_nov AS (
  SELECT
    MAX(
      CASE
        WHEN Month = '2011-09'
        THEN Net_Revenue
      END
    ) AS Sep_Revenue,

    MAX(
      CASE
        WHEN Month = '2011-11'
        THEN Net_Revenue
      END
    ) AS Nov_Revenue,

    MAX(
      CASE
        WHEN Month = '2011-09'
        THEN Sales_Orders
      END
    ) AS Sep_Orders,

    MAX(
      CASE
        WHEN Month = '2011-11'
        THEN Sales_Orders
      END
    ) AS Nov_Orders,

    MAX(
      CASE
        WHEN Month = '2011-09'
        THEN Active_Customers
      END
    ) AS Sep_Customers,

    MAX(
      CASE
        WHEN Month = '2011-11'
        THEN Active_Customers
      END
    ) AS Nov_Customers,

    MAX(
      CASE
        WHEN Month = '2011-09'
        THEN AOV
      END
    ) AS Sep_AOV,

    MAX(
      CASE
        WHEN Month = '2011-11'
        THEN AOV
      END
    ) AS Nov_AOV

  FROM monthly_kpis
)

SELECT
  ROUND(
    (Nov_Revenue / Sep_Revenue - 1) * 100,
    1
  ) AS Revenue_Change_Pct,

  ROUND(
    (Nov_Orders / Sep_Orders - 1) * 100,
    1
  ) AS Orders_Change_Pct,

  ROUND(
    (Nov_Customers / Sep_Customers - 1) * 100,
    1
  ) AS Customers_Change_Pct,

  ROUND(
    (Nov_AOV / Sep_AOV - 1) * 100,
    1
  ) AS AOV_Change_Pct

FROM sep_nov;

