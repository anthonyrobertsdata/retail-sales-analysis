-- Project: Retail Sales Analysis
-- Purpose: Compare identified customers with one purchase invoice
-- against customers with two or more purchase invoices.
--
-- Definitions:
-- A purchase is a distinct invoice in the positive-sales view.
-- A repeat customer has at least two distinct purchase invoices
-- during the observed dataset period.
--
-- Limitations:
-- Excludes rows without a customer ID.
-- Includes only positive-sales lines, not net sales after returns.
-- This is observed repeat purchasing, not a retention rate.
-- Customers have different lengths of observation.

WITH customer_activity AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS purchase_invoices,
        SUM(line_revenue) AS positive_sales_revenue
    FROM public.retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
customer_groups AS (
    SELECT
        CASE
            WHEN purchase_invoices = 1
                THEN 'One-invoice customers'
            ELSE 'Repeat customers (2+ invoices)'
        END AS customer_group,
        COUNT(*) AS customer_count,
        SUM(purchase_invoices) AS purchase_invoice_count,
        SUM(positive_sales_revenue) AS positive_sales_revenue
    FROM customer_activity
    GROUP BY 1
)
SELECT
    customer_group,
    customer_count,
    ROUND(
        100.0 * customer_count
        / NULLIF(SUM(customer_count) OVER (), 0),
        2
    ) AS pct_of_identified_customers,
    purchase_invoice_count,
    ROUND(
        purchase_invoice_count::numeric
        / NULLIF(customer_count, 0),
        2
    ) AS avg_invoices_per_customer,
    ROUND(
        positive_sales_revenue,
        2
    ) AS positive_sales_revenue,
    ROUND(
        100.0 * positive_sales_revenue
        / NULLIF(SUM(positive_sales_revenue) OVER (), 0),
        2
    ) AS pct_of_identified_customer_revenue,
    ROUND(
        positive_sales_revenue
        / NULLIF(customer_count, 0),
        2
    ) AS avg_positive_sales_per_customer
FROM customer_groups
ORDER BY customer_group;