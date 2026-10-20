# Retail Sales Data Analysis - Project Plan

**Project Type:** Data Analysis Portfolio Project  
**Primary Tools:** R, MySQL, Git/GitHub, Markdown  
**Status:** In Progress  
**Document Version:** 1.0

---

## 1. Project Overview

This project analyzes retail transaction data to identify sales trends,
revenue drivers, customer activity, and product performance.

The project is designed as an end-to-end data analysis workflow,
beginning with raw transaction data and ending with validated analytical
results, business insights, visualizations, and technical documentation.

R will be used for data cleaning, exploratory analysis, statistical
summaries, and visualization.

MySQL will be used to reproduce key analytic results using SQL and
validate the consistency of the analysis performed in R.

The completed project will demonstrate the ability to:

- inspect and clean raw business data,
- define and calculate business KPIs,
- answer structured business questions,
- analyze data using both R and SQL,
- communicate findings through visualizations,
- document analytical decisions and limitations, and
- produce a reproducible final analysis.

---

## 2. Project Objectives

The primary objectives of this project are to:

1. Inspect the raw retail transaction dataset and identify data quality
   issues.

2. Develop and document reproducible data-cleaning rules.

3. Create a validated analytical dataset for sales-performance analysis.

4. Calculate key business performance indicators, including:

   - Revenue
   - Number of Orders
   - Number of Active Customers
   - Average Order Value (AOV)

5. Analyze monthly sales performance and identify major revenue drivers.

6. Evaluate sales performance by country.

7. Identify high-performing products based on revenue and sales volume.

8. Analyze customer contribution to total revenue.

9. Reproduce key analytical results using MySQL.

10. Compare R and MySQL results to verify analytical consistency.

11. Create clear and presentation-ready data visualizations.

12. Document the methodology, findings, limitations, and final business
    insights.

---

## 3. Project Scope

### 3.1 In Scope

The following activities are included in this project:

- Raw data inspection
- Missing-value assessment
- Duplicate-row assessment
- Cancellation analysis
- Negative quantity investigation
- Non-positive price investigation
- Data-cleaning rule development
- Clean dataset creation
- Data validation
- Revenue calculation
- Overall KPI analysis
- Monthly sales analysis
- Country-level analysis
- Product-level analysis
- Customer-level analysis
- R-based analysis
- MySQL-based analysis
- R and MySQL result validation
- Data visualization
- Business interpretation
- Analysis notes
- Technical documentation
- README documentation
- Final analytical report
- Git/GitHub version control

### 3.2 Out of Scope

The following items are not included in the current project:

- Sales forecasting
- Machine-learning models
- Customer segmentation
- RFM modeling
- Interactive dashboards
- Real-time database integration
- Production database deployment
- Automated ETL pipelines

These items may be considered for future portfolio projects or project
extensions.

---

## 4. Key Business Questions

The analysis will focus on answering the following business questions.

### BQ1 — Monthly Sales Performance

**How has sales performance changed over time?**

The analysis will examine:

- Monthly Revenue
- Monthly Orders
- Monthly Active Customers
- Monthly Average Order Value

The objective is to determine what factors contributed to major changes
in revenue.

---

### BQ2 — Country Performance

**Which countries generate the strongest sales performance?**

The analysis will examine:

- Revenue by country
- Orders by country
- Active customers by country

The objective is to identify the markets contributing most strongly to
business performance.

---

### BQ3 — Product Performance

**Which products contribute the most to sales performance?**

The analysis will examine:

- Top products by revenue
- Top products by quantity sold

The objective is to identify important revenue-generating and
high-volume products.

---

### BQ4 — Customer Performance

**How concentrated is revenue among customers?**

The analysis will examine:

- Revenue by customer
- Highest-value customers
- Revenue contribution of top customers

Customer-level analysis will use only transactions with valid
CustomerID values.

---

### BQ5 — Business Summary

**What are the most important findings from the analysis?**

The final analysis will summarize approximately three to five key
business findings supported by the data.

---

## 5. Technical Architecture

R will be used for data auditing, cleaning, analysis, and visualization.

The cleaned dataset will then be imported into MySQL, where key
analytical results will be reproduced using SQL.

The R and MySQL results will be compared to verify analytical
consistency.

### 5.1 Data Flow

Raw Dataset  
`Online Retail.xlsx`

↓

R Data Audit

↓

R Data Cleaning and Validation

↓

Processed Dataset  
`sales_clean.csv`

↓

R Analysis + MySQL Analysis

↓

Result Validation

↓

Visualizations

↓

Business Insights

↓

Final Report

### 5.2 Technology Stack

| Component | Technology | Purpose |
|---|---|---|
| Source Data | Excel | Raw transaction dataset |
| Data Cleaning | R / tidyverse | Clean and transform transaction data |
| Business Analysis | R | KPI and business analysis |
| Database | MySQL | SQL analysis and result validation |
| Visualization | ggplot2 | Create analytical visualizations |
| Documentation | Markdown | Project plan, notes, and reports |
| Version Control | Git / GitHub | Track changes and publish portfolio |

---

## 6. Project Deliverables

The project will produce the following deliverables.

| Deliverable | Description |
|---|---|
| Clean Dataset | Validated `sales_clean.csv` |
| R Cleaning Script | Reproducible data-cleaning workflow |
| R Analysis Script | KPI and business analysis |
| Visualization Script | Code for final charts |
| MySQL Database | Retail sales data imported into MySQL |
| SQL Analysis | Queries reproducing major analytical results |
| Figures | Approximately 3–5 final analytical visualizations |
| Analysis Notes | Analytical decisions, findings, and limitations |
| Project Plan | Project scope, WBS, status, and completion criteria |
| README | Public-facing portfolio summary |
| Final Report | Business findings, interpretation, and recommendations |

---

## 7. Work Breakdown Structure

### P0 — Project Setup

- P0-01 Create project folder structure
- P0-02 Create Git repository
- P0-03 Create project plan
- P0-04 Define project scope

---

### P1 — Data Audit

- P1-01 Inspect dataset dimensions
- P1-02 Inspect columns and data types
- P1-03 Assess missing values
- P1-04 Identify exact duplicates
- P1-05 Investigate negative Quantity values
- P1-06 Investigate non-positive UnitPrice values
- P1-07 Investigate cancellation transactions
- P1-08 Document audit findings

---

### P2 — Data Cleaning

- P2-01 Define cleaning rules
- P2-02 Remove exact duplicates
- P2-03 Retain valid cancellation transactions
- P2-04 Exclude non-cancellation negative or zero quantities
- P2-05 Exclude non-positive prices
- P2-06 Exclude accounting adjustment records
- P2-07 Calculate net Revenue
- P2-08 Validate cleaned data
- P2-09 Save cleaned dataset

---

### P3 — Core KPI Analysis

- P3-01 Calculate Total Revenue
- P3-02 Calculate Total Orders
- P3-03 Calculate Active Customers
- P3-04 Calculate Average Order Value
- P3-05 Document KPI definitions

---

### P4 — Business Analysis

#### BQ1 — Monthly Performance

- Calculate monthly Revenue
- Calculate monthly Orders
- Calculate monthly Active Customers
- Calculate monthly AOV
- Identify major changes
- Analyze revenue drivers
- Document findings

#### BQ2 — Country Performance

- Calculate Revenue by country
- Calculate Orders by country
- Calculate Active Customers by country
- Identify highest-performing markets
- Document findings

#### BQ3 — Product Performance

- Identify top products by Revenue
- Identify top products by Quantity
- Compare revenue and volume rankings
- Document findings

#### BQ4 — Customer Performance

- Calculate Revenue by Customer
- Identify highest-value customers
- Evaluate revenue concentration
- Document findings

#### BQ5 — Final Business Insights

- Review findings from BQ1–BQ4
- Select three to five key findings
- Develop business interpretation
- Identify limitations

---

### P5 — MySQL Analysis

- P5-01 Install and configure MySQL
- P5-02 Create project database
- P5-03 Create retail sales table
- P5-04 Import cleaned dataset
- P5-05 Reproduce overall KPIs
- P5-06 Reproduce monthly analysis
- P5-07 Reproduce country analysis
- P5-08 Reproduce product analysis
- P5-09 Reproduce customer analysis
- P5-10 Use SQL techniques including:
  - SELECT
  - WHERE
  - GROUP BY
  - ORDER BY
  - HAVING
  - CASE WHEN
  - Common Table Expressions (CTEs)
  - JOIN
- P5-11 Compare MySQL results with R results

---

### P6 — Documentation

- P6-01 Maintain `analysis_notes.md`
- P6-02 Maintain project management log
- P6-03 Write README
- P6-04 Write final report
- P6-05 Document analytical limitations

---

### P7 — Quality Assurance and Project Close

- P7-01 Run R analysis from a fresh session
- P7-02 Validate MySQL queries
- P7-03 Compare R and SQL results
- P7-04 Check project file paths
- P7-05 Verify figures
- P7-06 Review documentation
- P7-07 Review spelling and formatting
- P7-08 Finalize GitHub repository
- P7-09 Complete project retrospective
- P7-10 Close project

---

## 8. Current Project Status

| Phase | Status |
|---|---|
| P0 — Project Setup | Complete |
| P1 — Data Audit | Complete |
| P2 — Data Cleaning | Complete |
| P3 — Core KPI Analysis | Complete |
| P4 — Business Analysis | Complete |
| P5 — MySQL Analysis | Complete |
| P6 — Documentation | Complete |
| P7 — Quality Assurance | In Progress |

### Current Work Package

**P7 — Quality Assurance and Project Close**

Current focus:

**P7-05 — Verify Figures**

Completed:

- BQ1 — Monthly Performance
- BQ2 — Country Performance
- BQ3 — Product Performance
- BQ4 — Customer Performance
- BQ5 — Final Business Insights
- Cancellation methodology QA and correction
- R and MySQL cross-validation
- P6-03 — README
- P6-04 — Final Report
- P6-05 — Analytical Limitations
- P7-01 — Fresh-Session R Validation
- P7-02 — MySQL Query Validation
- P7-03 — R and SQL Result Comparison
- P7-04 — Project File Path Validation

### BQ4 Completion Summary

Customer performance analysis was completed using active customers with
a valid CustomerID and at least one non-cancellation sales order.

Cancellation transactions were retained as negative revenue when
calculating customer-level net revenue.

Key findings:

- 4,338 active customers were identified.
- The top 10 customers generated approximately 16.5% of active-customer
  net revenue.
- The top 1% of active customers, representing 44 customers, generated
  approximately 30.0% of active-customer net revenue.
- Transactions with valid CustomerID values accounted for approximately
  85.0% of total project net revenue.
- Thirty-three CustomerID values appeared only in cancellation
  transactions and were excluded from the active-customer population.

### BQ5 Completion Summary

Final business insights were consolidated from the completed monthly,
country, product, and customer analyses.

Key findings:

- Late-year revenue growth was driven primarily by increased order
  volume and customer activity rather than higher average order value.
- Revenue was highly concentrated in the United Kingdom, which generated
  approximately 84.0% of total net revenue.
- Product rankings differed substantially between net revenue and net
  quantity, indicating that both metrics are needed to evaluate product
  performance.
- Revenue was concentrated among a relatively small group of customers,
  with the top 1% of active customers generating approximately 30.0% of
  active-customer net revenue.

Major analytical limitations were documented, including partial
December 2011 data, missing CustomerID values, unconfirmed transaction
currency, and the descriptive nature of the analysis.

BQ5 — Final Business Insights is complete.

### MySQL Progress Status

- P5-01 Install and configure MySQL — Complete
- P5-02 Create project database — Complete
- P5-03 Create retail sales table — Complete
- P5-04 Import cleaned dataset — Complete
- P5-05 Reproduce overall KPIs — Complete
- P5-06 Reproduce monthly analysis — Complete
- P5-07 Reproduce country analysis — Complete
- P5-08 Reproduce product analysis — Complete
- P5-09 Reproduce customer analysis — Complete
- P5-10 SQL techniques — Complete
- P5-11 Compare MySQL results with R results — Complete

Note:

The MySQL dataset and table schema were refreshed after the cleaned
dataset was revised to include `IsCancellation`.

Overall KPIs, monthly performance, country performance, product
performance, and customer performance were reproduced and validated
against the R results.

During customer-level validation, a floating-point precision issue was
identified in R for net revenue values extremely close to zero. The R QA
logic was updated to use `dplyr::near()` for zero-value classification,
after which the customer-level QA results matched MySQL.

The main analytical results are now consistent across R and MySQL.

---

## 9. Definition of Done

The project will be considered complete when all of the following
conditions are satisfied:

1. Raw data can be transformed into the final cleaned dataset using
   reproducible R scripts.

2. Cleaning rules are documented and validated.

3. All core KPIs are calculated and documented.

4. All four business analysis areas are completed.

5. Three to five meaningful business insights are identified.

6. Key analytical results are reproduced using MySQL.

7. R and MySQL results are validated against each other.

8. Final visualizations are created and saved.

9. Analysis notes are complete.

10. README documentation is complete.

11. The final analytical report is complete.

12. The analysis can be reproduced from a fresh environment without
    manually modifying the data.

---

## 10. Project Management Rules

The project will be managed using task-based completion rather than
time-based study goals.

### 10.1 Work Package Management

Each work session will identify:

- Current project phase
- Current work package
- Specific tasks
- Estimated completion time
- Actual completion time
- Definition of Done

A task will only be marked complete when its Definition of Done has been
satisfied.

---

### 10.2 Scope Control

New analytic ideas will not automatically be added to the active
project scope.

Ideas outside the current project scope will be recorded in the backlog.

Examples:

- RFM analysis
- Sales forecasting
- Customer segmentation
- Interactive dashboard
- Machine learning

This rule is intended to prevent uncontrolled project expansion.

---

### 10.3 Time Tracking

Estimated and actual working time will be recorded for major work
packages.

Example:

Estimated Time: 3.0 hours  
Actual Time: 4.2 hours

This information will be used to improve future project estimates.

---

#### Date

2026-10-20

#### Current Phase

P7 — Quality Assurance and Project Close

#### Work Packages

- P6-03 — README
- P6-04 — Final Report
- P6-05 — Analytical Limitations
- P7-01 — Fresh-Session R Validation
- P7-02 — MySQL Query Validation
- P7-03 — R and SQL Result Comparison
- P7-04 — Project File Path Validation
- P7-05 — Figure Verification

#### Tasks

- [x] Complete README
- [x] Validate README formatting and visualizations
- [x] Write final analytical report
- [x] Document analytical limitations
- [x] Run R analysis from a fresh session
- [x] Validate MySQL queries
- [x] Compare R and SQL results
- [x] Check project file paths
- [ ] Verify figures

#### Result

- P7-02 — MySQL Query Validation: Complete
- All seven SQL scripts ran successfully from a fresh MySQL session
- Database import reproduced 534,128 cleaned rows
- Core KPIs and BQ1–BQ4 SQL results matched expected values
- P7-03 — R and SQL Result Comparison: Complete
- P7-04 — Project File Path Validation: Complete
- No user-specific absolute paths were found in R, SQL, README, or report files
- All required input, output, figure, and report paths were verified
- Current work package: P7-05 — Verify Figures

---

## 11. Project Schedule and Milestones

| Phase | Estimated Effort | Status |
|---|---:|---|
| P0 — Project Setup | 1–2 hours | Complete |
| P1 — Data Audit | 3–4 hours | Complete |
| P2 — Data Cleaning | 3–4 hours | Complete |
| P3 — Core KPI Analysis | 2–3 hours | Complete |
| P4 — Business Analysis | 7–9 hours | Complete |
| P5 — MySQL Analysis | 6–8 hours | Complete |
| P6 — Documentation | 4–6 hours | Complete |
| P7 — QA and Project Close | 3–4 hours | In Progress |

### Major Milestones

| Milestone | Description | Status |
|---|---|---|
| M1 | Clean analytical dataset complete | Complete |
| M2 | Core KPI analysis complete | Complete |
| M3 | Business analysis complete | Complete |
| M4 | MySQL validation complete | Complete |
| M5 | Documentation complete | Complete |
| M6 | Portfolio project released | Not Started |

---

## 12. Risks and Assumptions

### Risks

- Additional analysis ideas may expand the project scope.
- MySQL data import or query validation issues may delay SQL analysis.
- Missing CustomerID values limit some customer-level analyses.
- December 2011 contains incomplete monthly data and must be
  interpreted carefully.

### Assumptions

- The cleaned dataset will be the common source for R and MySQL analysis.
- The project focuses on descriptive and diagnostic analysis.
- Advanced modeling is outside the current project scope.

---

## 13. Project Retrospective

At project completion, a retrospective will evaluate:

- Estimated vs. actual project duration
- Tasks that required more time than expected
- Technical challenges encountered
- Analytical decisions that worked well
- Areas for improvement
- Lessons to apply to Portfolio Project #2

---

## 14. Future Portfolio Roadmap

- Portfolio #2: Customer Churn Prediction using R and Machine Learning
- Portfolio #3: Automated Reporting or Statistical Analysis
- Portfolio #4: Biomedical / Genomics Analysis