-- ============================================================
-- Retail Sales Analysis
-- Overall KPI Analysis
-- ============================================================

USE retail_sales_analysis;

SELECT
  SUM(Revenue) AS total_revenue,
  COUNT(DISTINCT InvoiceNo) AS total_orders,
  COUNT(DISTINCT CustomerID) AS total_customers,
  SUM(Revenue) / COUNT(DISTINCT InvoiceNo) AS aov
FROM retail_sales;