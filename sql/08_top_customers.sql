-- Top identified customers by full-period positive-sales revenue.
-- Group by customer ID alone to avoid splitting customers by country.
-- Country names are descriptive attributes, not grouping keys.

SELECT
    customer_id,
    STRING_AGG(
        DISTINCT country,
        ', ' ORDER BY country
    ) AS countries,
    ROUND(SUM(line_revenue), 2) AS positive_sales_revenue,
    COUNT(DISTINCT invoice_no) AS purchase_invoices,
    ROUND(
        SUM(line_revenue)
        / NULLIF(COUNT(DISTINCT invoice_no), 0),
        2
    ) AS avg_positive_sales_per_invoice,
    MIN(invoice_date)::date AS first_observed_purchase,
    MAX(invoice_date)::date AS last_observed_purchase
FROM public.retail_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY
    positive_sales_revenue DESC,
    customer_id
LIMIT 20;