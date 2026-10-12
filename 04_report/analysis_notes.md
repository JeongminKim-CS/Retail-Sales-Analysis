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
5. Preserve missing CustomerID for overall sales analysis.


## 3. Overall KPIs

Total Revenue: 10,642,111

Total Orders: 19,960

Unique Customers: 4,338

Average Order Value: approximately 533


## 4. Monthly Revenue Analysis

November 2011 had the highest monthly revenue.

Revenue increased approximately 42.4% from September
to November 2011.

December 2011 contains only partial-month data,
so December revenue should not be directly compared
with complete months.


## 5. Next Question

What drove the 42.4% revenue increase between
September and November 2011?

Investigate:

- Orders
- Active customers
- Average order value