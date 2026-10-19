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
2. Retain valid cancellation transactions where InvoiceNo begins with
   "C" and Quantity is negative.
3. Exclude non-cancellation transactions with Quantity <= 0 because
   they primarily represent inventory adjustments rather than sales.
4. Exclude transactions with UnitPrice <= 0.
5. Exclude "Adjust bad debt" records because they represent accounting
   adjustments rather than retail sales transactions.
6. Preserve missing CustomerID for overall sales analysis.
7. Calculate Revenue as Quantity * UnitPrice so cancellation
   transactions contribute negative revenue.

During QA, a positive "Adjust bad debt" record passed the initial numeric
cleaning rules and was later identified as an accounting adjustment.
The cleaning rule was updated accordingly.

### Cancellation Handling

During product-level QA, several unusually large transactions were found to
have matching cancellation invoices with equal negative quantities.

The initial cleaning approach removed cancellation invoices while retaining
the original positive sales transactions. This overstated revenue because
fully cancelled sales remained in the analysis.

The methodology was revised to retain valid cancellation transactions as
negative quantities and negative revenue.

Non-cancellation negative-quantity records, such as inventory adjustments,
remain excluded.

After cleaning:

- 9,251 cancellation rows were retained
- Gross sales revenue was approximately 10,631,049
- Cancellation revenue was approximately -893,980
- Net revenue was approximately 9,737,069

As a result, all revenue metrics in this project are now reported on a
net-revenue basis.


## 3. Overall KPIs

- Net Revenue: 9,737,069
- Sales Orders: 19,959
- Unique Customers: 4,338
- Average Order Value: 487.85

Revenue includes valid cancellation transactions as negative revenue.

Orders and customers are calculated from non-cancellation sales
transactions.

Average Order Value is calculated as net revenue divided by the number
of non-cancellation sales orders.


## 4. Monthly Performance Analysis

From September to November 2011:

- Net Revenue increased by approximately 43.1%
- Orders increased by approximately 50.7%
- Active Customers increased by approximately 31.4%
- AOV decreased by approximately 5.1%

The increase in net revenue was therefore driven primarily by higher order
volume and increased customer activity rather than higher revenue per order.

December 2011 is a partial month and should not be directly compared with
full months.


## 5. Country Performance

The United Kingdom was the dominant market, contributing approximately
84.0% of total net revenue.

The top five countries together accounted for approximately 93.9% of
total net revenue, indicating a high concentration of sales in a small
number of markets.

The United Kingdom also had by far the highest number of orders and
active customers, indicating that its strong revenue performance was
supported by broad transaction and customer activity.

## 6. Product Performance

Product performance was evaluated using StockCode as the product
identifier.

StockCode values were normalized to uppercase, and non-product
transaction codes such as postage, manual entries, discounts,
bank charges, commissions, samples, and gift vouchers were excluded
from product rankings.

When multiple descriptions existed for the same StockCode, the most
frequently occurring description was used as the representative product
name.

REGENCY CAKESTAND 3 TIER generated the highest net revenue at
approximately 164,459.

POPCORN HOLDER generated the highest net sales volume with 56,427 units.

Five products appeared in both the top 10 by net revenue and the top 10
by net quantity, indicating strong performance across both revenue and
sales volume.

Revenue and quantity rankings differed substantially for several products.
For example, REGENCY CAKESTAND 3 TIER ranked 1st in net revenue but 44th
in net quantity, while WORLD WAR 2 GLIDERS ASSTD DESIGNS ranked 2nd in
net quantity but 142nd in net revenue.

This indicates that product performance should be evaluated using both
revenue and sales volume rather than either metric alone.

## 7. Customer Performance

Customer-level analysis was limited to transactions with a valid
CustomerID.

Active customers were defined as customers with at least one
non-cancellation sales order. Cancellation transactions were retained
and reflected as negative revenue when calculating customer-level net
revenue.

A total of 4,338 active customers were identified.

The top 10 customers generated approximately 16.5% of net revenue
attributable to active customers.

The top 1% of active customers, representing 44 customers, generated
approximately 30.0% of active-customer net revenue.

This indicates that revenue is meaningfully concentrated among a
relatively small group of high-value customers.

Transactions associated with valid CustomerID values accounted for
approximately 85.0% of total project net revenue. Therefore,
customer-level analysis does not cover all revenue because transactions
with missing CustomerID values cannot be assigned to individual
customers.

Thirty-three CustomerID values appeared only in cancellation
transactions and had no non-cancellation sales orders. These customers
were excluded from the active-customer population used for revenue
concentration analysis.

## 8. Next Analysis — Final Business Insights

The next analysis will consolidate findings from monthly, country,
product, and customer performance analyses.

The objective is to identify three to five key business insights,
document major analytical limitations, and prepare the final business
summary.