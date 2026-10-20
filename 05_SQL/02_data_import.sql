-- ============================================================
-- Retail Sales Analysis
-- Import Cleaned Dataset
-- ============================================================

USE retail_sales_analysis;

-- Requires local_infile to be enabled.
-- Run the MySQL client from the project root directory:
-- 01_Retail_Sales_Analysis
--
-- MySQL client should be started with:
-- mysql --local-infile=1 -u root -p retail_sales_analysis


-- Clear existing rows before re-importing the cleaned dataset
TRUNCATE TABLE retail_sales;


LOAD DATA LOCAL INFILE
'01_data/02_processed/sales_clean.csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
  InvoiceNo,
  StockCode,
  Description,
  Quantity,
  @InvoiceDate,
  UnitPrice,
  @CustomerID,
  Country,
  @IsCancellation,
  @RevenueRaw
)
SET
  InvoiceDate = STR_TO_DATE(
    @InvoiceDate,
    '%Y-%m-%dT%H:%i:%sZ'
  ),

  CustomerID = CASE
    WHEN @CustomerID IN ('', 'NA') THEN NULL
    ELSE @CustomerID
  END,

  IsCancellation = CASE
    WHEN UPPER(TRIM(@IsCancellation)) = 'TRUE' THEN 1
    WHEN UPPER(TRIM(@IsCancellation)) = 'FALSE' THEN 0
    ELSE NULL
  END,

  Revenue = CAST(
    NULLIF(
      @RevenueRaw,
      ''
    ) AS DECIMAL(15, 3)
  );


-- ============================================================
-- Import Validation
-- ============================================================

SELECT
  COUNT(*) AS Total_Rows
FROM retail_sales;

SELECT
  IsCancellation,
  COUNT(*) AS Rows_Count
FROM retail_sales
GROUP BY IsCancellation
ORDER BY IsCancellation;

SELECT
  ROUND(
    SUM(Revenue),
    3
  ) AS Net_Revenue
FROM retail_sales;


-- After the import is complete, disable local_infile:
-- SET GLOBAL local_infile = OFF;