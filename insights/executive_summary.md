# Executive Summary

## Objective

Analyze historical retail transactions to evaluate positive-sales trends, customer purchasing patterns, and limitations that affect business interpretation.

## Scope and Revenue Definition

The recorded database baseline contains 541,909 raw lines and 530,100 positive-sales lines from December 1, 2010 through December 9, 2011. Recorded positive-sales revenue is 10,666,684.54; the country export reconciles to this total.

Positive-sales revenue includes only rows with positive quantity and unit price. It is not net sales after returns, retained revenue, or profit. Monetary amounts are documented as GBP based on UCI's sterling definition, assuming no conversion during import.

The monthly-growth export ends in November 2011. Customer, country, and product exports cover the full available dataset. These different scopes must be considered when reconciling totals.

## Key Findings

### 1. November led the complete-month comparison

November 2011 generated 1,509,496.33 in positive-sales revenue across 2,769 invoices, the highest values among the 12 exported months. Revenue increased 9.11% in October and 30.69% in November compared with the preceding month.

The December 2010-November 2011 export totals 10,027,891.86. Its difference from the full-period revenue total is 638,792.68, consistent with the recorded partial December 2011 result.

December 2011 ends on December 9 and should not be compared directly with complete months. October-November should not be presented as a complete Q4 result.

### 2. Positive-sales revenue was concentrated in the United Kingdom

The country export contains 38 country categories. The United Kingdom generated 9,025,222.08, or 84.61% of positive-sales revenue. The Netherlands and EIRE followed with 285,446.34 and 283,453.96, respectively.

Country revenue reconciles to 10,666,684.54. Separately rounded country shares total 100.04%, a rounding effect rather than a revenue discrepancy.

### 3. Repeat purchasers generated most identified-customer revenue

| Customer group | Customers | Customer share | Positive-sales revenue | Revenue share |
|---|---:|---:|---:|---:|
| One-invoice customers | 1,493 | 34.42% | 616,311.73 | 6.92% |
| Repeat customers (2+ invoices) | 2,845 | 65.58% | 8,295,096.17 | 93.08% |
| Total identified customers | 4,338 | 100.00% | 8,911,407.90 | 100.00% |

Repeat customers averaged 5.99 purchase invoices and 2,915.68 in positive sales per customer, compared with 1.00 invoice and 412.80 for one-invoice customers.

These results describe identified customers only. Repeat purchasing is not a fixed-window retention rate, and higher revenue partly reflects the group's greater number of purchase invoices by definition.

### 4. Missing identifiers limit customer coverage

The recorded baseline contains 132,220 positive-sales lines without customer IDs, or 24.94% of positive-sales lines.

The full-period revenue total less identified-customer revenue leaves 1,755,276.64, or 16.46%, outside the identified-customer analysis. The line-coverage percentage depends on the recorded baseline count; these counts should remain reproducible with script 02.

### 5. Positive-sales rankings require reversal-aware interpretation

Stock code `22423`, REGENCY CAKESTAND 3 TIER, leads the filtered product-code export with 174,484.74 in positive-sales revenue across 1,988 invoices. This is a positive-sales ranking, not a net-sales ranking.

The raw-transaction review identified the following matched entries:

| Stock code | Product | Positive invoice | Negative invoice | Quantity magnitude | Value magnitude |
|---|---|---|---|---:|---:|
| `23843` | PAPER CRAFT, LITTLE BIRDIE | `581483` | `C581484` | 80,995 | 168,469.60 |
| `23166` | MEDIUM CERAMIC TOP STORAGE JAR | `541431` | `C541433` | 74,215 | 77,183.60 |

Within each pair, customer, stock code, quantity magnitude, and unit price match. The negative entry occurs later on the same day. Each pair sums to zero in signed value.

For stock code `23843`, the raw export contains only the two offsetting records. Its apparent positive-sales unit-volume leadership therefore does not represent retained sales of 80,995 units.

Stock code `23166` has additional raw transactions; the zero-sum finding applies to the exceptional pair, not the product's entire history.

### 6. High positive-sales customer value is not necessarily net customer value

Customer `14646` leads the exported customer ranking with 280,206.02 across 73 purchase invoices. Customer `16446` has 168,472.50 across two positive-sales invoices.

The exceptional stock-code `23843` pair belongs to customer `16446`. The positive side enters the customer ranking while its negative counterpart is excluded. Customer rankings must therefore be reviewed using signed transactions before making claims about retained customer value.

## Business Implications

- Investigate product mix and exceptional transactions before treating monthly growth as evidence of durable demand.
- Treat the United Kingdom as the main positive-sales market in this dataset, while distinguishing country concentration from profitability.
- Evaluate repeat purchasers as an observed customer group, not as proof that a retention campaign will cause revenue growth.
- Improve customer-ID capture to strengthen customer-level coverage.
- Review positive and negative entries together before making inventory or account-priority recommendations.

## Validation Completed

- All 53 saved arithmetic checks passed for the monthly-growth and repeat-purchase exports.
- Country revenue reconciles to the recorded full-period revenue total.
- The product export contains 3,916 unique stock-code rows without missing stock codes.
- All 20 displayed top-customer invoice averages reconcile to the exported precision.
- Raw-data inspection confirms the two exceptional matched positive/negative pairs.

These checks establish exported-result consistency, not a complete independent audit of the source database. The saved validation CSV specifically covers the monthly and repeat-purchase files; other reviews are not recorded in that CSV.

## Limitations

- Positive-only analysis excludes negative entries and does not measure net sales or profit.
- Customer IDs are missing for part of the data.
- Customer observation windows differ.
- December 2011 is incomplete.
- Product-code exclusions are not a complete merchandise classification.
- A complete duplicate-record audit remains outstanding.
- Historical associations do not establish causation or future demand.
- Source attribution and GBP basis are recorded below; acquisition history, raw-table DDL, and detailed import documentation remain incomplete.

## Supporting Files

| Analysis | SQL script | Result file |
|---|---|---|
| Monthly growth | `sql/04_monthly_revenue_growth.sql` | `results/monthly_revenue_growth.csv` |
| Repeat purchasing | `sql/05_customer_repeat_purchase.sql` | `results/customer_repeat_purchase.csv` |
| Country performance | `sql/06_country_performance.sql` | `results/country_performance.csv` |
| Product-code performance | `sql/07_product_performance.sql` | `results/product_performance.csv` |
| Top customers | `sql/08_top_customers.sql` | `results/top_customers.csv` |
| Exceptional transactions | `sql/09_exceptional_transaction_review.sql` | `results/exceptional_transaction_review.csv` |

Arithmetic review report: `results/validation_checks.csv`.

## Remaining work and scope boundaries

Complete the reproducibility documentation without rebuilding the working
database. Signed product/customer rankings remain optional future work;
no such new rankings or new dashboard are claimed. Review publication
separately. See README.md for source details and current setup boundaries.

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
