-- ============================================================
-- Retail Sales Analysis
-- Monthly Performance Analysis
-- ============================================================

USE retail_sales_analysis;

SELECT
  DATE_FORMAT(InvoiceDate, '%Y-%m') AS invoice_month,
  SUM(Revenue) AS Revenue,
  COUNT(DISTINCT InvoiceNo) AS Orders,
  COUNT(DISTINCT CustomerID) AS Active_Customers,
  SUM(Revenue) / COUNT(DISTINCT InvoiceNo)
FROM retail_sales
GROUP BY
  invoice_month
ORDER BY
  invoice_month;
  