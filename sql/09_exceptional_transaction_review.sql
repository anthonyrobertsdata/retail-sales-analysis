-- Inspect raw transactions for exceptional high-volume products.
-- Include positive and negative quantities.
-- Do not change or delete any source records.

SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    ROUND(
        quantity::numeric * unit_price,
        2
    ) AS signed_line_value
FROM public.retail_raw
WHERE stock_code IN ('23843', '23166')
ORDER BY
    stock_code,
    ABS(quantity::numeric * unit_price) DESC,
    invoice_date,
    invoice_no;