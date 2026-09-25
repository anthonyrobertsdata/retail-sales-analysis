# Retail Sales Analysis | SQL

## Project Overview

This project analyzes transactional retail data to identify sales performance patterns, validate data quality, and create a clean analytical layer for further reporting.

The project uses PostgreSQL and pgAdmin to transform and analyze the Online Retail dataset. The analysis covers transactions from December 2010 through December 2011.

## Business Questions

- How did revenue change month to month?
- Which markets, products, and customers generated the most revenue?
- How much of the dataset is usable for customer-level analysis?
- What data-quality limitations should be considered when interpreting results?

## Dataset

- Source: Online Retail dataset
- Raw transaction records: 541,909
- Cleaned sales records: 530,100
- Date range: 2010-12-01 through 2011-12-09
- Identified customers: 4,338
- Products: 3,921
- Total positive sales revenue: 10,666,684.54

## Data Preparation

A PostgreSQL view named `retail_sales` was created from the raw import table, `retail_raw`.

The view:

- Retains transaction records with positive quantity and unit price
- Excludes returns, cancellations, and non-positive price records from positive-sales analysis
- Calculates `line_revenue` as `quantity * unit_price`
- Preserves the raw import as the original source layer

## Data Quality Findings

- The raw dataset contains 541,909 records.
- The cleaned analytical view contains 530,100 sales records.
- 132,220 cleaned sales records have no customer ID.
- Customer-level analyses should exclude rows where `customer_id` is null.
- December 2011 data is partial because the source data ends on December 9, 2011.

## Initial Findings

- Revenue increased substantially during Q4 2011.
- November 2011 produced the highest monthly revenue at 1,509,496.33.
- November 2011 also had the highest invoice volume at 2,769 invoices.
- December 2011 should not be compared with full months because it contains only nine days of data.

## Repository Structure

```text
retail-sales-analysis/
├── README.md
├── sql/
│   ├── 01_create_retail_sales_view.sql
│   ├── 02_data_quality_checks.sql
│   └── 03_exploratory_analysis.sql
└── insights/
    └── executive_summary.md
```

## How to Reproduce

1. Import the source data into PostgreSQL as `public.retail_raw`.
2. Run `sql/01_create_retail_sales_view.sql`.
3. Run `sql/02_data_quality_checks.sql` to validate the analytical layer.
4. Run `sql/03_exploratory_analysis.sql` to produce the initial monthly trend analysis.

## Tools

- PostgreSQL
- pgAdmin 4
- SQL