-- ============================================================
-- Retail Sales Analysis
-- Database and Table Setup
-- ============================================================

CREATE DATABASE IF NOT EXISTS retail_sales_analysis;

USE retail_sales_analysis;

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
  InvoiceNo VARCHAR(20),
  StockCode VARCHAR(20),
  Description VARCHAR(255),
  Quantity INT,
  InvoiceDate DATETIME,
  UnitPrice DECIMAL(12,3),
  CustomerID INT,
  Country VARCHAR(50),
  IsCancellation BOOLEAN,
  Revenue DECIMAL(15,3)
);

DESCRIBE retail_sales;