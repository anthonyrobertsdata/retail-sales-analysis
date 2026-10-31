-- Project: Retail Sales Analysis
-- Purpose: Calculate monthly positive-sales revenue and
-- month-over-month revenue growth.
--
-- Scope:
-- Positive quantity and positive unit price only.
-- This is not net revenue after returns.
--
-- The source covers December 1, 2010 through December 9, 2011.
-- December 2011 is incomplete and excluded from this comparison.
-- December 2010 is retained as the first monthly baseline.

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', invoice_date)::date AS sales_month,
        SUM(line_revenue) AS positive_sales_revenue,
        COUNT(DISTINCT invoice_no) AS invoice_count
    FROM public.retail_sales
    WHERE invoice_date >= DATE '2010-12-01'
      AND invoice_date < DATE '2011-12-01'
    GROUP BY 1
),
monthly_comparison AS (
    SELECT
        sales_month,
        positive_sales_revenue,
        invoice_count,
        LAG(sales_month) OVER (
            ORDER BY sales_month
        ) AS previous_sales_month,
        LAG(positive_sales_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(positive_sales_revenue, 2)
        AS positive_sales_revenue,
    invoice_count,
    ROUND(
        positive_sales_revenue
        / NULLIF(invoice_count, 0),
        2
    ) AS average_positive_sales_per_invoice,
    ROUND(previous_month_revenue, 2)
        AS previous_month_revenue,
    CASE
        WHEN previous_sales_month =
             (sales_month - INTERVAL '1 month')::date
        THEN ROUND(
            positive_sales_revenue - previous_month_revenue,
            2
        )
    END AS revenue_change,
    CASE
        WHEN previous_sales_month =
             (sales_month - INTERVAL '1 month')::date
        THEN ROUND(
            100.0
            * (positive_sales_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0),
            2
        )
    END AS revenue_growth_pct
FROM monthly_comparison
ORDER BY sales_month;