# Online Retail Analysis Notes

## 1. Data Audit

### Missing CustomerID
135,080 transactions have missing CustomerID values.

Missing CustomerID records are retained for overall sales analysis,
but excluded when customer-level metrics are calculated.

### Duplicate Rows
5,268 exact duplicate rows were identified.

Exact duplicates were removed before analysis.

### Negative Quantity

10,624 transactions had negative Quantity values.

Among these:

- 9,288 invoices started with "C"
- 1,336 did not start with "C"

Non-cancellation negative quantity records were primarily associated
with descriptions such as:

- check
- damages
- damaged
- adjustment

These records appear to represent inventory adjustments rather than
normal customer sales.

### Non-positive UnitPrice

2,517 transactions had UnitPrice <= 0.

Most had zero prices.

Only two transactions had negative UnitPrice values,
associated with "Adjust bad debt".

For sales-performance analysis, transactions with UnitPrice <= 0
were excluded.


## 2. Cleaning Decisions

The following rules were applied:

1. Remove exact duplicate rows.
2. Exclude cancellation invoices beginning with "C".
3. Exclude Quantity <= 0.
4. Exclude UnitPrice <= 0.
5. Exclude "Adjust bad debt" records because they represent accounting
   adjustments rather than retail sales transactions.
6. Preserve missing CustomerID for overall sales analysis.

During QA, a positive "Adjust bad debt" record passed the initial numeric
cleaning rules and was later identified as an accounting adjustment.
The cleaning rule was updated accordingly.


## 3. Overall KPIs

Total Revenue: 10,631,049

Total Orders: 19,959

Unique Customers: 4,338

Average Order Value: 532.64


## 4. Monthly Performance Analysis

November 2011 had the highest monthly revenue.

Revenue increased approximately 42.4% from September to November 2011.

During the same period:

- Orders increased approximately 50.7%.
- Active customers increased approximately 31.4%.
- Average Order Value decreased approximately 5.5%.

This increase in revenue was therefore primarily associated with higher order
volume and increased customer activity rather than higher spending per order.

December 2011 contains only partial-month data, so December performance should
not be directly compared with complete months.

## 5. Country Performance

The United Kingdom was the dominant market, contributing approximately
84.6% of total revenue.

The top five countries together accounted for approximately 94.0% of
total revenue, indicating a high concentration of sales in a small
number of markets.

The United Kingdom also had by far the highest number of orders and
active customers, indicating that its strong revenue performance was
supported by broad transaction and customer activity.


## 6. Next Analysis — Product Performance

The next analysis will evaluate sales performance by product.

The analysis will examine:

- Revenue by product
- Quantity sold by product
- Top products by revenue
- Top products by sales volume

The objective is to identify the products contributing most strongly
to sales performance.