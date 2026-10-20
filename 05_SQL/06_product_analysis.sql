-- ============================================================
-- Retail Sales Analysis
-- Product Performance Analysis
-- ============================================================

USE retail_sales_analysis;


-- ============================================================
-- 1. Build Product-Level Performance Table
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS product_performance;

CREATE TEMPORARY TABLE product_performance AS

WITH product_data AS (
  SELECT
    UPPER(StockCode) AS ProductCode,
    Description,
    Quantity,
    Revenue,
    InvoiceNo,
    IsCancellation

  FROM retail_sales

  WHERE
    UPPER(StockCode) NOT IN (
      'AMAZONFEE',
      'BANK CHARGES',
      'C2',
      'CRUK',
      'D',
      'DOT',
      'M',
      'POST',
      'S'
    )
    AND LEFT(
      UPPER(StockCode),
      5
    ) <> 'GIFT_'
),

description_counts AS (
  SELECT
    ProductCode,
    Description,
    COUNT(*) AS Description_Count

  FROM product_data

  WHERE
    Description IS NOT NULL

  GROUP BY
    ProductCode,
    Description
),

ranked_descriptions AS (
  SELECT
    ProductCode,
    Description,

    ROW_NUMBER() OVER (
      PARTITION BY ProductCode
      ORDER BY
        Description_Count DESC,
        Description
    ) AS Description_Rank

  FROM description_counts
),

product_sales AS (
  SELECT
    ProductCode,
    SUM(Revenue) AS Net_Revenue,
    SUM(Quantity) AS Net_Quantity,

    COUNT(
      DISTINCT CASE
        WHEN IsCancellation = 0
        THEN InvoiceNo
      END
    ) AS Sales_Orders

  FROM product_data

  GROUP BY
    ProductCode
)

SELECT
  p.ProductCode,
  d.Description,
  p.Net_Revenue,
  p.Net_Quantity,
  p.Sales_Orders

FROM product_sales AS p

LEFT JOIN ranked_descriptions AS d
  ON p.ProductCode = d.ProductCode
  AND d.Description_Rank = 1;

-- ============================================================
-- 2. Top 10 Products by Net Revenue
-- ============================================================

SELECT
  ProductCode,
  Description,

  ROUND(
    Net_Revenue,
    3
  ) AS Net_Revenue,

  Net_Quantity,
  Sales_Orders

FROM product_performance

ORDER BY
  Net_Revenue DESC

LIMIT 10;


-- ============================================================
-- 3. Top 10 Products by Net Quantity
-- ============================================================

SELECT
  ProductCode,
  Description,

  ROUND(
    Net_Revenue,
    3
  ) AS Net_Revenue,

  Net_Quantity,
  Sales_Orders

FROM product_performance

ORDER BY
  Net_Quantity DESC

LIMIT 10;

-- ============================================================
-- 4. Revenue and Quantity Ranking Comparison
-- ============================================================

WITH product_rankings AS (
  SELECT
    ProductCode,
    Description,
    Net_Revenue,
    Net_Quantity,
    Sales_Orders,

    ROW_NUMBER() OVER (
      ORDER BY Net_Revenue DESC
    ) AS Revenue_Rank,

    ROW_NUMBER() OVER (
      ORDER BY Net_Quantity DESC
    ) AS Quantity_Rank

  FROM product_performance
)

SELECT
  ProductCode,
  Description,
  ROUND(
    Net_Revenue,
    3
  ) AS Net_Revenue,
  Net_Quantity,
  Sales_Orders,
  Revenue_Rank,
  Quantity_Rank

FROM product_rankings

WHERE
  Revenue_Rank <= 10
  OR Quantity_Rank <= 10

ORDER BY
  LEAST(
    Revenue_Rank,
    Quantity_Rank
  ),
  ProductCode;

-- ============================================================
-- 5. Top 10 Revenue and Quantity Overlap
-- ============================================================

WITH product_rankings AS (
  SELECT
    ProductCode,

    ROW_NUMBER() OVER (
      ORDER BY Net_Revenue DESC
    ) AS Revenue_Rank,

    ROW_NUMBER() OVER (
      ORDER BY Net_Quantity DESC
    ) AS Quantity_Rank

  FROM product_performance
)

SELECT
  COUNT(*) AS Top_10_Overlap

FROM product_rankings

WHERE
  Revenue_Rank <= 10
  AND Quantity_Rank <= 10;