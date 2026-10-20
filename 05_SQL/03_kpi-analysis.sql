-- ============================================================
-- Retail Sales Analysis
-- Overall KPI Analysis
-- ============================================================

USE retail_sales_analysis;


-- ============================================================
-- 1. Overall KPIs
-- ============================================================

SELECT
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

FROM retail_sales;