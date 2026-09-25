-- Creates a cleaned analytical view from the raw Online Retail import.
-- Removes non-positive quantities and prices, then calculates revenue by line item.

CREATE OR REPLACE VIEW public.retail_sales AS
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    quantity::numeric * unit_price AS line_revenue
FROM public.retail_raw
WHERE quantity > 0
  AND unit_price > 0;