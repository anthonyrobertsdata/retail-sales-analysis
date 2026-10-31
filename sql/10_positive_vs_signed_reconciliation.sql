-- Compare positive, negative, and signed transaction values.
--
-- Scope:
-- Include rows with positive unit prices and nonzero quantities.
-- Negative quantities remain included.
--
-- Signed transaction value is an analytical measure, not a
-- verified accounting net-revenue figure.

WITH transaction_values AS (
    SELECT
        quantity,
        quantity::numeric * unit_price AS line_value
    FROM public.retail_raw
    WHERE unit_price > 0
      AND quantity <> 0
),
summary AS (
    SELECT
        COUNT(*) FILTER (
            WHERE quantity > 0
        ) AS positive_lines,
        COUNT(*) FILTER (
            WHERE quantity < 0
        ) AS negative_lines,
        COALESCE(
            SUM(line_value) FILTER (
                WHERE quantity > 0
            ),
            0
        ) AS positive_sales_value,
        COALESCE(
            SUM(line_value) FILTER (
                WHERE quantity < 0
            ),
            0
        ) AS negative_transaction_value,
        COALESCE(
            SUM(line_value),
            0
        ) AS signed_transaction_value
    FROM transaction_values
)
SELECT
    positive_lines,
    negative_lines,
    ROUND(positive_sales_value, 2)
        AS positive_sales_value,
    ROUND(negative_transaction_value, 2)
        AS negative_transaction_value,
    ROUND(signed_transaction_value, 2)
        AS signed_transaction_value,
    ROUND(
        100.0 * ABS(negative_transaction_value)
        / NULLIF(positive_sales_value, 0),
        2
    ) AS negative_value_pct_of_positive_sales,
    ROUND(
        positive_sales_value
        + negative_transaction_value
        - signed_transaction_value,
        2
    ) AS reconciliation_difference
FROM summary;