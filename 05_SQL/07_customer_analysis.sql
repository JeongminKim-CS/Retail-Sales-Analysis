-- ============================================================
-- Retail Sales Analysis
-- Customer Performance Analysis
-- ============================================================

USE retail_sales_analysis;


-- ============================================================
-- 1. Build Customer-Level Performance Table
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS customer_performance;

CREATE TEMPORARY TABLE customer_performance AS

SELECT
  CustomerID,

  SUM(Revenue) AS Net_Revenue,

  COUNT(
    DISTINCT CASE
      WHEN IsCancellation = 0
      THEN InvoiceNo
    END
  ) AS Sales_Orders

FROM retail_sales

WHERE
  CustomerID IS NOT NULL

GROUP BY
  CustomerID;


-- ============================================================
-- 2. Customer-Level QA
-- ============================================================

SELECT
  COUNT(*) AS Customers,

  SUM(
    CASE
      WHEN Net_Revenue < 0
      THEN 1
      ELSE 0
    END
  ) AS Negative_Net_Revenue,

  SUM(
    CASE
      WHEN Net_Revenue = 0
      THEN 1
      ELSE 0
    END
  ) AS Zero_Net_Revenue,

  SUM(
    CASE
      WHEN Sales_Orders = 0
      THEN 1
      ELSE 0
    END
  ) AS Zero_Sales_Orders

FROM customer_performance;


-- ============================================================
-- 3. Active Customers
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS active_customer_performance;

CREATE TEMPORARY TABLE active_customer_performance AS

SELECT
  CustomerID,
  Net_Revenue,
  Sales_Orders

FROM customer_performance

WHERE
  Sales_Orders > 0;


SELECT
  COUNT(*) AS Active_Customers

FROM active_customer_performance;


-- ============================================================
-- 4. Top 10 Customers by Net Revenue
-- ============================================================

SELECT
  CustomerID,

  ROUND(
    Net_Revenue,
    3
  ) AS Net_Revenue,

  Sales_Orders

FROM active_customer_performance

ORDER BY
  Net_Revenue DESC

LIMIT 10;


-- ============================================================
-- 5. Revenue Concentration
-- ============================================================

WITH ranked_customers AS (
  SELECT
    CustomerID,
    Net_Revenue,
    Sales_Orders,

    ROW_NUMBER() OVER (
      ORDER BY Net_Revenue DESC
    ) AS Revenue_Rank,

    COUNT(*) OVER () AS Total_Customers

  FROM active_customer_performance
),

concentration AS (
  SELECT
    *,
    CEILING(
      Total_Customers * 0.01
    ) AS Top_1_Pct_Customers

  FROM ranked_customers
)

SELECT
  ROUND(
    SUM(
      CASE
        WHEN Revenue_Rank <= 10
        THEN Net_Revenue
        ELSE 0
      END
    ) /
    SUM(Net_Revenue) *
    100,
    1
  ) AS Top_10_Revenue_Share_Pct,

  MAX(
    Top_1_Pct_Customers
  ) AS Top_1_Pct_Customers,

  ROUND(
    SUM(
      CASE
        WHEN Revenue_Rank <= Top_1_Pct_Customers
        THEN Net_Revenue
        ELSE 0
      END
    ) /
    SUM(Net_Revenue) *
    100,
    1
  ) AS Top_1_Pct_Revenue_Share_Pct

FROM concentration;


-- ============================================================
-- 6. Revenue Coverage
-- ============================================================

SELECT
  ROUND(
    (
      SELECT
        SUM(Revenue)
      FROM retail_sales
      WHERE CustomerID IS NOT NULL
    ) /
    (
      SELECT
        SUM(Revenue)
      FROM retail_sales
    ) *
    100,
    2
  ) AS Identified_Customer_Coverage_Pct,

  ROUND(
    (
      SELECT
        SUM(Net_Revenue)
      FROM active_customer_performance
    ) /
    (
      SELECT
        SUM(Revenue)
      FROM retail_sales
    ) *
    100,
    2
  ) AS Active_Customer_Coverage_Pct;


-- ============================================================
-- 7. Cancellation-Only Customers
-- ============================================================

SELECT
  COUNT(*) AS Customers,

  ROUND(
    SUM(Net_Revenue),
    3
  ) AS Net_Revenue

FROM customer_performance

WHERE
  Sales_Orders = 0;


-- ============================================================
-- 8. Final Customer-Level QA
-- ============================================================

SELECT
  COUNT(*) AS Active_Customers,

  SUM(
    CASE
      WHEN CustomerID IS NULL
      THEN 1
      ELSE 0
    END
  ) AS Missing_CustomerID,

  SUM(
    CASE
      WHEN Sales_Orders <= 0
      THEN 1
      ELSE 0
    END
  ) AS Invalid_Sales_Orders

FROM active_customer_performance;

-- ============================================================
-- 9. Active Customer Validation Using HAVING
-- ============================================================

WITH active_customers_having AS (
  SELECT
    CustomerID,

    COUNT(
      DISTINCT CASE
        WHEN IsCancellation = 0
        THEN InvoiceNo
      END
    ) AS Sales_Orders

  FROM retail_sales

  WHERE
    CustomerID IS NOT NULL

  GROUP BY
    CustomerID

  HAVING
    COUNT(
      DISTINCT CASE
        WHEN IsCancellation = 0
        THEN InvoiceNo
      END
    ) > 0
)

SELECT
  COUNT(*) AS Active_Customers

FROM active_customers_having;