# Retail Sales Analysis - Interview Preparation

Status: Evidence-based study notes, not a claim that interview practice
or independent mastery has been completed.

## Two-minute explanation to practice
I analyzed invoice product lines using PostgreSQL to examine positive-sales
trends, countries, products, and observed repeat purchasing. I kept raw
transactions separate from a positive-sales view. Exceptional transactions
showed why excluding negative entries can distort product and customer
rankings. A separate reconciliation includes negative quantities and keeps
signed transaction value distinct from accounting net revenue. The project
includes saved SQL, exports, documented checks, and explicit setup limits.

## Questions and explanations
1. What does one row represent?
   An invoice product line, not an entire invoice, customer, or order.
2. Why retain raw data?
   It preserves negative entries and enables investigation of records
   excluded by the positive-sales view.
3. What does the view include?
   Positive quantity, positive unit price, and an invoice number not
   matching uppercase C%. NULL invoice numbers are also excluded.
4. Why did the saved/live definition difference matter?
   Reproduction requires matching definitions even when current totals
   agree. User-run checks found no additional positive rows excluded by
   the live invoice-prefix predicate. The saved script was aligned without
   rerunning CREATE OR REPLACE VIEW.
5. What is the signed reconciliation?
   For positive-price, nonzero-quantity rows, positive value 10,666,684.54
   plus negative value -896,812.49 equals signed value 9,769,872.05 GBP.
   This is not verified accounting net revenue or profit.
6. What does 8.41% mean?
   Absolute negative transaction value divided by positive sales value.
   It is not the percentage of orders or customers returning goods.
7. Why use LAG in monthly growth?
   It retrieves the previous observed month. The query also checks that
   the months are consecutive and guards zero denominators with NULLIF.
   Partial December 2011 is excluded from the monthly comparison.
8. What is a repeat customer?
   An identified customer with at least two distinct positive-sales
   invoices during the observation period. This is not fixed-window
   retention; customer observation lengths differ.
9. Why can scripts 03 and 07/08 differ?
   Exploration groups products by code/description and customers by
   customer/country. Later outputs group by product code or customer ID.
10. What does a zero reconciliation difference prove?
    Partition arithmetic agrees in the query scope, not that every source
    record is accurate or every business interpretation is justified.
11. How reproducible is the project?
    Analytical scripts and exports exist. Rebuilding from an empty database
    remains incompletely documented; the working database was not rebuilt.

## Discovery to explain
The recorded exceptional transaction pairs for stock codes 23843 and
23166 offset in signed value. Positive-only rankings retain their positive
sides. Describe this as an interpretation limitation, not permission to
silently delete records or change the original metric.

## Findings to connect to evidence
- Monthly growth: script 04 and monthly_revenue_growth.csv.
- Repeat purchasing: script 05 and customer_repeat_purchase.csv.
- Country/product/customer performance: scripts 06-08 and named exports.
- Exceptional transactions: script 09 and exceptional_transaction_review.csv.
- Signed reconciliation: script 10 and positive_vs_signed_reconciliation.csv.
Historical export checks do not automatically constitute a current complete
source-database audit. See README.md and the executive summary.

## Personal contribution - fill in truthfully
Before an interview, identify which scripts you can independently explain
and rerun, what you personally executed or inspected, and where AI or
other assistance was used. Do not claim independent authorship or mastery
merely because an assisted script ran successfully.

## Practice checkpoint
Without reading, explain the grain, positive/signed distinction, repeat
customer denominator, exceptional-pair discovery, one validation check,
and the remaining reproducibility limitation. Mark practice complete only
after actually doing it. No achieved business improvement is claimed.
