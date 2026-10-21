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
- Active Customers: 4,338
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

The top 10 customers generated approximately 16.5% of active-customer
net revenue.

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

## 8. Final Business Insights

### Insight 1 — Late-Year Revenue Growth Was Driven by Order Volume and
Customer Activity

**Finding**

Net revenue increased substantially from September to November 2011.

**Evidence**

- Net revenue increased by approximately 43.1%.
- Sales orders increased by approximately 50.7%.
- Active customers increased by approximately 31.4%.
- Average order value decreased by approximately 5.1%.

**Business Interpretation**

The increase in net revenue was driven primarily by higher order volume
and increased customer activity rather than by higher revenue per order.

This suggests that late-year growth was associated with more purchasing
activity across the customer base rather than customers spending more on
each individual order.

### Insight 2 — Revenue Was Highly Concentrated in the UK Market

**Finding**

The United Kingdom generated the majority of net revenue.

**Evidence**

- The United Kingdom accounted for approximately 84.0% of total net
  revenue.
- The top five countries together accounted for approximately 93.9% of
  total net revenue.

**Business Interpretation**

The business was highly concentrated in the UK market, while
international markets contributed a relatively small share of total
revenue.

This concentration indicates that overall business performance was
strongly influenced by the UK market.


### Insight 3 — Revenue and Sales Volume Identified Different Leading Products

**Finding**

Products with the highest net revenue were not necessarily the products
with the highest sales volume.

**Evidence**

- REGENCY CAKESTAND 3 TIER ranked first in net revenue at approximately
  164,459.
- POPCORN HOLDER ranked first in net quantity with 56,427 units.
- Only five products appeared in both the top 10 by net revenue and the
  top 10 by net quantity.

**Business Interpretation**

Product performance should be evaluated using both revenue and sales
volume.

High-volume products do not necessarily generate the greatest revenue,
while some products can make a strong revenue contribution without
ranking among the highest-volume items.

### Insight 4 — Revenue Was Concentrated Among a Small Group of Customers

**Finding**

A relatively small group of active customers generated a substantial
share of active-customer net revenue.

**Evidence**

- 4,338 active customers were identified.
- The top 10 customers generated approximately 16.5% of active-customer
  net revenue.
- The top 1% of active customers, representing 44 customers, generated
  approximately 30.0% of active-customer net revenue.

**Business Interpretation**

High-value customers made a disproportionately large contribution to
revenue.

Understanding the purchasing behavior of these customers and maintaining
their relationship with the business may therefore be particularly
important.

## 9. Analytical Limitations

The analysis has several limitations that should be considered when
interpreting the results.

- December 2011 contains only partial-month data and should not be
  compared directly with complete months.

- Transactions with valid CustomerID values accounted for approximately
  85% of total net revenue. Customer-level analysis therefore does not
  represent all transactions.

- Thirty-three CustomerID values appeared only in cancellation
  transactions and were excluded from the active-customer population
  used for customer revenue concentration analysis.

- Revenue values are reported in pounds sterling (GBP), consistent with
  the dataset documentation.

- The analysis is descriptive and diagnostic. It identifies patterns and
  relationships in the observed data but does not establish causal
  relationships.

## 10. R and MySQL Validation

Key analytical results were independently reproduced in MySQL using the
cleaned dataset generated in R.

| Metric | R | MySQL | Result |
|---|---:|---:|---|
| Net Revenue | 9,737,069.014 | 9,737,069.014 | Match |
| Sales Orders | 19,959 | 19,959 | Match |
| Active Customers | 4,338 | 4,338 | Match |
| AOV | 487.85 | 487.85 | Match |
| Sep-Nov Revenue Change | 43.1% | 43.1% | Match |
| Sep-Nov Orders Change | 50.7% | 50.7% | Match |
| Sep-Nov Customer Change | 31.4% | 31.4% | Match |
| Sep-Nov AOV Change | -5.1% | -5.1% | Match |
| UK Revenue Share | 84.0% | 84.0% | Match |
| Top Five Country Share | 93.9% | 93.9% | Match |
| Top Revenue Product | 22423 | 22423 | Match |
| Top Quantity Product | 22197 | 22197 | Match |
| Product Top-10 Overlap | 5 | 5 | Match |
| Top 10 Customer Share | 16.5% | 16.5% | Match |
| Top 1% Customer Share | 30.0% | 30.0% | Match |

During customer-level validation, a small difference was initially found
in the classification of zero and negative customer net revenue.

R uses floating-point numeric values, which produced several values
extremely close to zero, such as -5.68e-14. MySQL stored revenue using
DECIMAL values and classified these balances as zero.

The R QA logic was updated to use `dplyr::near()` when testing for zero
net revenue. After this adjustment, the customer-level QA results also
matched between R and MySQL.

The cross-validation confirmed that the main analytical results were
consistent across both tools.