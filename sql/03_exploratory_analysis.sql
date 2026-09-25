-- Exploratory analysis: monthly revenue, invoice volume, and average order value.
-- Note: December 2011 data is partial because the dataset ends on 2011-12-09.

SELECT
    DATE_TRUNC('month', invoice_date)::date AS month,
    ROUND(SUM(line_revenue), 2) AS revenue,
    COUNT(DISTINCT invoice_no) AS invoices,
    ROUND(
        SUM(line_revenue) / COUNT(DISTINCT invoice_no),
        2
    ) AS average_order_value
FROM public.retail_sales
GROUP BY 1
ORDER BY 1;

-- Country performance: top markets by revenue, invoice volume, and identified customers.

SELECT
    country,
    ROUND(SUM(line_revenue), 2) AS revenue,
    COUNT(DISTINCT invoice_no) AS invoices,
    COUNT(DISTINCT customer_id) AS customers
FROM retail_sales
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;