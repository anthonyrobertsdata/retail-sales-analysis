-- Product-code performance across the full positive-sales dataset.
--
-- Known non-merchandise codes are excluded below.
-- This list is not a complete merchandise classification.
--
-- Group by stock code to avoid splitting a product when its
-- description varies. The sample description is a display label,
-- not an authoritative product-master description.

SELECT
    stock_code,
    MIN(NULLIF(TRIM(description), '')) AS sample_description,
    COUNT(
        DISTINCT NULLIF(TRIM(description), '')
    ) AS description_variants,
    ROUND(SUM(line_revenue), 2) AS positive_sales_revenue,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT invoice_no) AS invoices
FROM public.retail_sales
WHERE stock_code NOT IN (
    'DOT',
    'POST',
    'M',
    'D',
    'BANK CHARGES',
    'C2'
)
GROUP BY stock_code
ORDER BY
    positive_sales_revenue DESC,
    stock_code;