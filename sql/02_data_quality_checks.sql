-- Data quality and reconciliation checks for the Online Retail dataset.

-- 1. Compare raw and cleaned row counts.
SELECT
    'retail_raw' AS dataset,
    COUNT(*) AS row_count
FROM public.retail_raw

UNION ALL

SELECT
    'retail_sales' AS dataset,
    COUNT(*) AS row_count
FROM public.retail_sales;

-- 2. Baseline profile of the cleaned analytical view.
SELECT
    COUNT(*) AS sales_lines,
    COUNT(DISTINCT invoice_no) AS invoices,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT stock_code) AS products,
    MIN(invoice_date) AS first_sale,
    MAX(invoice_date) AS last_sale,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_ids,
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM public.retail_sales;