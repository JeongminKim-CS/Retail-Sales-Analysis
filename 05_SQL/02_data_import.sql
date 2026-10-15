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
  Revenue = ROUND(
    Quantity * UnitPrice,
    3
  );
  
-- After the import is complete, disable local_infile:
-- SET GLOBAL local_infile = OFF;