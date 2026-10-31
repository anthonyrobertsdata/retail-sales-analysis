-- Defines a positive-sales analytical view from the raw Online Retail import.
-- Matches the inspected live view: excludes uppercase-C invoice numbers
-- and retains only positive quantities and positive unit prices.
--
-- Positive-only line value is not signed net sales, retained revenue,
-- or profit. These filters do not constitute a complete data-quality audit.

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
WHERE invoice_no NOT LIKE 'C%'
  AND quantity > 0
  AND unit_price > 0;