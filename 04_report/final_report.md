# Retail Sales Data Analysis — Final Report

## 1. Executive Summary

This project analyzed retail transaction data to evaluate overall sales
performance, identify major revenue drivers, examine geographic and product
performance, and assess customer revenue concentration.

After data cleaning and validation, the final analytical dataset contained
534,128 transaction records. Valid cancellation transactions were retained as
negative revenue so that reported sales performance reflected net revenue
rather than gross sales alone.

The analysis produced the following core KPIs:

- Net Revenue: 9,737,069
- Sales Orders: 19,959
- Active Customers: 4,338
- Average Order Value: 487.85

Several important business patterns were identified. From September to
November 2011, net revenue increased by approximately 43.1%, primarily
because of higher order volume and increased customer activity rather than
higher average order value.

Sales were highly concentrated geographically. The United Kingdom generated
approximately 84.0% of total net revenue, while the top five countries
together accounted for approximately 93.9%.

Product analysis showed that the highest-revenue products were not always
the highest-volume products, indicating that both revenue and quantity
should be considered when evaluating product performance.

Customer analysis also showed meaningful concentration. The top 1% of
active customers, representing 44 customers, generated approximately 30.0%
of active-customer net revenue.

The main analytical results were independently reproduced in MySQL and
compared with the R results. The cross-validation confirmed consistent KPI,
country, product, and customer results across both analytical workflows.

## 2. Dataset and Methodology

The project used the `Online Retail.xlsx` transaction dataset as the raw
source data.

The dataset included invoice numbers, product codes and descriptions,
quantities, invoice dates, unit prices, customer identifiers, and country
information.

Before analysis, the raw data was audited for missing values, duplicate
rows, cancellation transactions, negative quantities, and non-positive
unit prices.

The final cleaning methodology applied the following rules:

- Remove exact duplicate rows.
- Retain valid cancellation transactions where the invoice number begins
  with `C` and quantity is negative.
- Exclude non-cancellation transactions with non-positive quantities because
  they primarily represented inventory adjustments rather than normal sales.
- Exclude transactions with non-positive unit prices.
- Exclude accounting adjustment records such as `Adjust bad debt`.
- Preserve transactions with missing `CustomerID` values for overall sales
  analysis.
- Calculate `Revenue` as `Quantity * UnitPrice`.

During product-level quality assurance, the initial cancellation methodology
was found to overstate revenue because cancellation transactions had been
excluded while the corresponding positive sales remained in the dataset.

The methodology was therefore revised to retain valid cancellations as
negative revenue. After cleaning, the final dataset contained 534,128 rows
and approximately 9.74 million in net revenue.

R was used for data cleaning, KPI calculation, business analysis, quality
assurance, and visualization. The cleaned dataset was then imported into
MySQL, where the major analytical results were independently reproduced for
cross-validation.

## 3. Core KPIs

The cleaned dataset produced the following core business performance
indicators:

| KPI | Value |
|---|---:|
| Net Revenue | 9,737,069 |
| Sales Orders | 19,959 |
| Active Customers | 4,338 |
| Average Order Value | 487.85 |

Net Revenue includes valid cancellation transactions as negative revenue.

Sales Orders and Active Customers are based on non-cancellation sales
transactions.

Average Order Value is calculated as Net Revenue divided by the number of
Sales Orders.

## 4. Key Business Findings

### 4.1 Late-Year Growth Was Driven by Order Volume and Customer Activity

From September to November 2011, net revenue increased by approximately
43.1%.

During the same period:

- Sales Orders increased by approximately 50.7%.
- Active Customers increased by approximately 31.4%.
- Average Order Value decreased by approximately 5.1%.

This indicates that the increase in net revenue was driven primarily by
higher transaction volume and broader customer activity rather than by
customers spending more per order.

### 4.2 Revenue Was Highly Concentrated in the United Kingdom

The United Kingdom generated approximately 84.0% of total net revenue.

The top five countries together accounted for approximately 93.9% of total
net revenue.

This indicates that overall business performance was highly dependent on a
small number of markets, particularly the United Kingdom.

### 4.3 Revenue and Sales Volume Identified Different Leading Products

`REGENCY CAKESTAND 3 TIER` generated the highest net revenue at
approximately 164,459.

`POPCORN HOLDER` generated the highest net sales volume with 56,427 units.

Only five products appeared in both the top 10 by net revenue and the top
10 by net quantity.

This demonstrates that high-volume products are not necessarily the largest
revenue contributors. Product performance should therefore be evaluated
using both revenue and sales volume.

### 4.4 Revenue Was Concentrated Among High-Value Customers

A total of 4,338 active customers were identified.

The top 10 active customers generated approximately 16.5% of
active-customer net revenue.

The top 1% of active customers, representing 44 customers, generated
approximately 30.0% of active-customer net revenue.

This indicates that a relatively small group of high-value customers made
a disproportionately large contribution to revenue.

## 5. R and MySQL Validation

The major analytical results were independently reproduced in MySQL using
the cleaned dataset generated in R.

The following results matched across both tools:

| Metric | R | MySQL |
|---|---:|---:|
| Net Revenue | 9,737,069.014 | 9,737,069.014 |
| Sales Orders | 19,959 | 19,959 |
| Active Customers | 4,338 | 4,338 |
| Average Order Value | 487.85 | 487.85 |
| UK Revenue Share | 84.0% | 84.0% |
| Top Five Country Share | 93.9% | 93.9% |
| Product Top-10 Overlap | 5 | 5 |
| Top 10 Customer Share | 16.5% | 16.5% |
| Top 1% Customer Share | 30.0% | 30.0% |

During customer-level validation, a small discrepancy was initially found
in the classification of zero and negative customer net revenue.

R uses floating-point numeric values, which produced several values
extremely close to zero. MySQL stored revenue using `DECIMAL` values and
classified these balances as zero.

The R validation logic was updated to use `dplyr::near()` when testing
for zero net revenue. After this adjustment, the customer-level QA results
matched between R and MySQL.

This cross-validation increased confidence that the core analytical results
were reproducible and consistent across both tools.

## 6. Analytical Limitations

Several limitations should be considered when interpreting the results.

First, December 2011 contains only partial-month data and should not be
directly compared with complete months.

Second, transactions with valid `CustomerID` values accounted for
approximately 85% of total net revenue. Customer-level analysis therefore
does not represent all transactions in the dataset.

Third, thirty-three CustomerID values appeared only in cancellation
transactions and were excluded from the active-customer population used for
customer revenue concentration analysis.

Fourth, the dataset does not explicitly confirm the transaction currency.
Revenue is therefore reported without assigning a currency symbol.

Finally, this analysis is descriptive and diagnostic. It identifies patterns
and relationships in the observed data but does not establish causal
relationships.

## 7. Business Recommendations

Based on the observed patterns, the following areas may warrant further
business attention.

### 7.1 Investigate the Drivers of Late-Year Order Growth

Late-year revenue growth was associated primarily with higher order volume
and increased customer activity rather than higher average order value.

The business should investigate which products, customer groups, promotions,
or seasonal factors contributed to the increase in orders and determine
whether similar activity can be encouraged in future periods.

### 7.2 Monitor Geographic Concentration

Approximately 84.0% of total net revenue came from the United Kingdom.

Because overall performance is highly dependent on one market, the business
should continue monitoring UK performance while evaluating whether selected
international markets offer opportunities for gradual expansion.

### 7.3 Evaluate Products Using Both Revenue and Sales Volume

Revenue and quantity rankings identified different leading products.

Product decisions should therefore consider both revenue contribution and
sales volume rather than relying on a single metric. This may provide a more
complete basis for merchandising, inventory, and product-prioritization
decisions.

### 7.4 Understand and Retain High-Value Customers

The top 1% of active customers generated approximately 30.0% of
active-customer net revenue.

Further analysis of these customers' purchasing patterns may help identify
characteristics associated with high customer value and inform customer
retention efforts.

These recommendations are based on descriptive patterns in the available
data and should be investigated further before being treated as causal
business conclusions.

## 8. Conclusion

This project demonstrated an end-to-end retail data analysis workflow using
R and MySQL.

The analysis began with raw transaction auditing and data cleaning, followed
by KPI development, monthly, country, product, and customer analysis, and
business interpretation.

Several important findings were identified. Late-year growth was driven
primarily by increased order volume and customer activity, revenue was highly
concentrated in the United Kingdom, product performance differed depending
on whether revenue or volume was considered, and a relatively small group of
customers contributed a substantial share of revenue.

The project also showed the importance of analytical validation. During
quality assurance, the cancellation-handling methodology was revised to avoid
overstating revenue, and R results were independently reproduced in MySQL to
confirm consistency.

Overall, the project demonstrates practical skills in data cleaning, KPI
definition, business analysis, visualization, SQL validation, quality
assurance, and analytical documentation.