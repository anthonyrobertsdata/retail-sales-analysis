# Retail Sales Analysis | SQL

## Project Overview

This project uses PostgreSQL and pgAdmin 4 to analyze the Online Retail dataset, evaluate positive-sales trends and customer purchasing patterns, and investigate data-quality limitations.

A raw-transaction review identified exceptionally large positive transactions with matching negative entries. This demonstrates why positive-sales rankings must not be interpreted as net-sales rankings.

## Revenue Definition

Unless explicitly stated otherwise, revenue means positive-sales revenue: `quantity * unit_price` for rows where quantity and unit price are both positive.

This measure excludes negative entries. It is not net revenue after returns, retained sales, or profit. Monetary values are documented as GBP based on the original source documentation, assuming no conversion during import.

## Business Questions

- How did monthly positive-sales revenue change?
- Which countries and product codes generated the most positive-sales revenue?
- How concentrated was identified-customer revenue among repeat purchasers?
- How do missing customer IDs affect analytical coverage?
- Do exceptional transactions distort positive-sales rankings?

## Dataset and Scope

| Metric | Recorded baseline |
|---|---:|
| Raw transaction lines | 541,909 |
| Positive-sales lines | 530,100 |
| Date range | 2010-12-01 to 2011-12-09 |
| Distinct positive-sales invoices | 19,960 |
| Identified customers | 4,338 |
| Distinct stock codes in the positive-sales view | 3,921 |
| Positive-sales lines missing customer IDs | 132,220 |
| Total positive-sales revenue | 10,666,684.54 |

These baseline values were recorded during database profiling. The country export independently reconciles to the recorded revenue total; the repeat-purchase export reconciles to the identified-customer count. Other baseline counts require the profiling query to reproduce.

Source: Chen, D. (2015). Online Retail. UCI Machine Learning Repository.
DOI: https://doi.org/10.24432/C5BW33
Source documentation: https://archive.ics.uci.edu/dataset/352/online+retail
License: Creative Commons Attribution 4.0 (CC BY 4.0).

UCI describes unit prices as sterling; monetary measures are documented as
GBP, assuming the import retained source units without conversion. The
original acquisition/import history and source-to-database identity have
not been independently reconstructed. UCI identifies invoice codes
beginning with C/c as cancellations; the actual live view uses the
case-sensitive uppercase pattern `NOT LIKE 'C%'`.

Raw-table DDL and detailed acquisition/import instructions remain to be completed.

## Data Preparation

- Preserve the original import as `public.retail_raw`.
- Create `public.retail_sales` as the positive-sales analytical view.
- Retain rows where `invoice_no NOT LIKE 'C%'`, `quantity > 0`, and `unit_price > 0`.
- Calculate `line_revenue` as `quantity::numeric * unit_price`.
- Exclude missing customer IDs only from customer-level analyses.
- Preserve negative transactions in the raw table for reversal review.

The positive-sales filter is not a complete audit of duplicate records, cancellation codes, or merchandise classification.

## Findings Supported by Exported Results

### Monthly performance

- The December 2010-November 2011 export totals 10,027,891.86 in positive-sales revenue.
- November 2011 leads the exported months with 1,509,496.33 across 2,769 invoices.
- Revenue increased 9.11% in October and 30.69% in November compared with the preceding month.
- December 2011 is excluded from monthly-growth analysis because coverage ends on December 9.

### Country performance

- The country export totals 10,666,684.54 across 38 country categories.
- The United Kingdom accounts for 9,025,222.08, or 84.61% of positive-sales revenue.
- Individually rounded country percentages total 100.04%; this rounding difference does not affect revenue reconciliation.

### Identified-customer purchasing

- The customer export covers 4,338 identified customers and 8,911,407.90 in positive-sales revenue.
- Repeat customers number 2,845, or 65.58% of identified customers, and generate 93.08% of identified-customer positive-sales revenue.
- These percentages describe identified customers only, not all transactions.

### Product and exceptional-transaction review

- Stock code `22423`, REGENCY CAKESTAND 3 TIER, leads the filtered product-code export with 174,484.74 in positive-sales revenue across 1,988 invoices.
- Stock code `23843`, PAPER CRAFT, LITTLE BIRDIE, has a positive transaction for 80,995 units valued at 168,469.60 and a matching negative transaction. Its two raw records sum to zero in signed value.
- Stock code `23166`, MEDIUM CERAMIC TOP STORAGE JAR, includes a positive transaction for 74,215 units valued at 77,183.60 with a matching negative entry. Other transactions also exist for this stock code.
- Positive-sales rankings include the positive sides of these pairs and therefore do not establish retained sales or net customer value.

## Analysis Definitions

- Monthly growth: percentage change from the immediately preceding calendar month's positive-sales revenue.
- Monthly comparison window: December 2010-November 2011.
- Customer analysis window: the full available dataset through December 9, 2011.
- Repeat customer: an identified customer with at least two distinct positive-sales invoices in the observed window.
- Repeat purchasing is not a fixed-window retention rate; observation periods differ between customers.
- Product ranking: stock-code aggregation after excluding the explicit code list in script 07. The exclusions are not a complete merchandise classification.
- Sample product description: a display label selected from the stock code's descriptions, not a verified product-master label.
- Top customers: 20 identified customers ranked by positive-sales revenue, not by net revenue or profitability.
- Country-level customer and invoice counts should not be assumed additive without checking cross-country overlaps.

## Repository Structure

```text
retail-sales-analysis/
|-- README.md
|-- insights/
|   |-- executive_summary.md
|   `-- interview_notes.md
|-- results/
|   |-- country_performance.csv
|   |-- customer_repeat_purchase.csv
|   |-- exceptional_transaction_review.csv
|   |-- monthly_revenue_growth.csv
|   |-- product_performance.csv
|   |-- top_customers.csv
|   |-- positive_vs_signed_reconciliation.csv
|   `-- validation_checks.csv
`-- sql/
    |-- 01_create_retail_sales_view.sql
    |-- 02_data_quality_checks.sql
    |-- 03_exploratory_analysis.sql
    |-- 04_monthly_revenue_growth.sql
    |-- 05_customer_repeat_purchase.sql
    |-- 06_country_performance.sql
    |-- 07_product_performance.sql
    |-- 08_top_customers.sql
    |-- 09_exceptional_transaction_review.sql
    `-- 10_positive_vs_signed_reconciliation.sql
```

Filename convention: lowercase words separated by underscores, with numbered SQL scripts indicating the analysis sequence.

## SQL Scripts and Outputs

| Script | Purpose | Saved result |
|---|---|---|
| `01_create_retail_sales_view.sql` | Define the positive-sales view | Database view |
| `02_data_quality_checks.sql` | Profile raw and analytical records | Review in pgAdmin |
| `03_exploratory_analysis.sql` | Initial exploration | Review in pgAdmin |
| `04_monthly_revenue_growth.sql` | Monthly comparisons | `monthly_revenue_growth.csv` |
| `05_customer_repeat_purchase.sql` | Identified-customer purchasing groups | `customer_repeat_purchase.csv` |
| `06_country_performance.sql` | Country totals and revenue shares | `country_performance.csv` |
| `07_product_performance.sql` | Product-code performance | `product_performance.csv` |
| `08_top_customers.sql` | Top 20 identified customers | `top_customers.csv` |
| `09_exceptional_transaction_review.sql` | Inspect two exceptional product codes in raw data | `exceptional_transaction_review.csv` |

| `10_positive_vs_signed_reconciliation.sql` | Separate positive/negative/signed reconciliation | `positive_vs_signed_reconciliation.csv` |

Scripts 06-08 provide the more precisely defined supporting outputs. Script 03 preserves the earlier exploratory work, including different product/customer grouping choices; its rankings should not be assumed identical.

## Reproduce the Analysis

The analytical scripts are available, but setup is not yet fully reproducible from an empty database because the raw-table DDL and detailed import instructions are still missing.

1. Obtain the original source dataset and confirm its documentation.
2. Create and import `public.retail_raw` with the column names and compatible data types expected by script 01.
3. Run script 01 to create the positive-sales view.
4. Run script 02 and inspect the baseline profile.
5. Run script 03 for initial exploration.
6. Run scripts 04-10 individually and export each result with column headers to the corresponding file in `results/`.
7. Compare totals and definitions before updating `insights/executive_summary.md`.

Export result tables separately from saving SQL files. Do not execute `validation_checks.csv` as SQL or import it into the analytical tables.

## Validation Scope

`results/validation_checks.csv` records 53 passing arithmetic checks on the monthly-growth and customer-repeat-purchase exports. It checks displayed averages, percentages, previous-month values, and revenue changes to the exported precision.

This report is not a full database audit and does not automatically cover later exports or regenerated files. Its generating Python code is not currently included in the repository.

Additional export review reconciled country revenue, checked product-code uniqueness, and checked the displayed invoice averages in the top-customer export.

## Resume Work Locally

- Server label: `Local PostgreSQL`.
- Database: `analytics_practice`.
- Open pgAdmin 4, right-click the database, and select Query Tool.
- Open the saved SQL script, execute it, and inspect the output.
- Save script changes locally; export results separately.
- Do not reimport the dataset or recreate the view merely to resume analysis.
- Do not commit passwords, connection secrets, or unrelated personal files.

## Limitations

- Positive-sales revenue is not net sales or profit.
- Matched positive and negative transactions can materially distort positive-only rankings.
- Missing customer IDs limit customer coverage.
- December 2011 is incomplete.
- Customer observation windows differ.
- A complete duplicate-record audit and merchandise classification remain outstanding.
- Historical associations do not establish causation or predict future demand.
- SQL review and exported-result validation do not independently verify every raw source record.

## Remaining closeout boundaries

- Document an empty-database setup using the verified column types and an
  explicitly described source-conversion/import procedure. Do not recreate
  the working database merely to write these instructions.
- Source-file location, acquisition history, and complete raw-data quality
  checks remain unverified. Duplicate checks require interpretation, not
  automatic deletion.
- Signed product/customer rankings are optional future analysis, not
  completed work or a reason to replace the existing positive-sales view.
- Desktop/database-version details and GitHub/publication status remain
  unverified. No automatic publication or new dashboard is planned.
- Practice explaining the existing SQL and its limitations.

## Tools

- PostgreSQL
- pgAdmin 4
- SQL
- GitHub

## Current review evidence - October 31, 2026

Saved scripts 01-10 were inspected as text; this is not execution of all
scripts or a complete database audit. User-run schema queries showed:

| Column | Raw-table type |
|---|---|
| invoice_no | text |
| stock_code | text |
| description | text |
| quantity | integer |
| invoice_date | timestamp without time zone |
| unit_price | numeric(12,2) |
| customer_id | text |
| country | text |

All eight raw columns were reported nullable. The view exposes these
columns plus numeric line_revenue. Nullable metadata does not establish
actual missing-value counts. Constraints, indexes, and import history
were not comprehensively inspected.

The user supplied the live view definition: positive quantity, positive
unit price, and invoice_no NOT LIKE 'C%'. This predicate also excludes
NULL invoice numbers. User-run checks found zero positive-price,
positive-quantity rows with uppercase-C invoices and zero with NULL
invoice numbers. The extra predicate therefore had no effect on that
population in the checked snapshot. Script 01 was subsequently edited
and reported saved by the user; the documentation installer checks its
filter and protects its bytes without executing it.

### Separate signed reconciliation

Script: sql/10_positive_vs_signed_reconciliation.sql
Saved output: results/positive_vs_signed_reconciliation.csv

| Measure | Current user-run result, matching saved export |
|---|---:|
| Positive lines | 530,100 |
| Negative lines | 9,288 |
| Positive sales value (GBP) | 10,666,684.54 |
| Negative transaction value (GBP) | -896,812.49 |
| Signed transaction value (GBP) | 9,769,872.05 |
| Negative-value magnitude / positive sales | 8.41% |
| Reconciliation difference (GBP) | 0.00 |

Scope: unit_price > 0 and quantity <> 0, without a separate invoice-prefix
filter. This is not the same filter definition as the positive-sales view.
Positive value plus negative value equals signed value in that scope.
The zero difference verifies the partition arithmetic, not source accuracy.
The 8.41% measure is a value ratio, not a customer, claim, or return rate.
Signed transaction value is not verified accounting net revenue or profit.
The live outputs were supplied by the user; the assistant did not connect
to or execute queries against the database.

The collection contained CSV samples, not full copies of all exports.
Historical validation statements below/elsewhere retain their original
scope; this review does not claim to have rerun all historical checks.
