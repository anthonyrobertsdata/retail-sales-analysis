-- Country performance across the full positive-sales dataset.
-- Customer counts exclude NULL customer IDs.
-- Country-level invoice counts should not be assumed additive.

SELECT
    country,
    ROUND(SUM(line_revenue), 2) AS positive_sales_revenue,
    ROUND(
        100.0 * SUM(line_revenue)
        / NULLIF(SUM(SUM(line_revenue)) OVER (), 0),
        2
    ) AS pct_of_positive_sales_revenue,
    COUNT(DISTINCT invoice_no) AS invoices,
    COUNT(DISTINCT customer_id) AS identified_customers
FROM public.retail_sales
GROUP BY country
ORDER BY
    positive_sales_revenue DESC,
    country;