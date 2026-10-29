-- Source and KPI validation
SELECT
    COUNT(*) AS row_count,
    COUNT(DISTINCT customer_name) AS distinct_customers,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS missing_sales,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS missing_profit,
    SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) AS missing_discount,
    SUM(CASE WHEN discount < 0 OR discount >= 1 THEN 1 ELSE 0 END) AS invalid_discount_rows
FROM dbo.orders_clean;

-- Reconciliation totals used by the report
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(100.0 * SUM(profit) / NULLIF(SUM(sales), 0), 2) AS profit_margin_pct
FROM dbo.orders_clean;

-- Confirm that category totals reconcile to the overall totals
WITH category_totals AS (
    SELECT category, SUM(sales) AS sales, SUM(profit) AS profit
    FROM dbo.orders_clean
    GROUP BY category
)
SELECT
    ROUND(SUM(sales), 2) AS category_sales_total,
    ROUND(SUM(profit), 2) AS category_profit_total
FROM category_totals;
