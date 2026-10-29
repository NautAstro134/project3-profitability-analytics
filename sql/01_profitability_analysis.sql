/*
Retail profitability analysis
Expected table: dbo.orders_clean
Expected columns:
order_date, customer_name, category, sub_category, product_name,
sales, profit, discount
*/

-- Headline KPIs
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(100.0 * SUM(profit) / NULLIF(SUM(sales), 0), 2) AS profit_margin_pct
FROM dbo.orders_clean;

-- Category profitability
SELECT
    category,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(100.0 * SUM(profit) / NULLIF(SUM(sales), 0), 2) AS profit_margin_pct
FROM dbo.orders_clean
GROUP BY category
ORDER BY profit DESC;

-- Subcategory profitability
SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(100.0 * SUM(profit) / NULLIF(SUM(sales), 0), 2) AS profit_margin_pct
FROM dbo.orders_clean
GROUP BY category, sub_category
ORDER BY profit;

-- Discount bands
SELECT
    CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        ELSE 'Above 30%'
    END AS discount_band,
    COUNT(*) AS order_lines,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(100.0 * SUM(profit) / NULLIF(SUM(sales), 0), 2) AS profit_margin_pct
FROM dbo.orders_clean
GROUP BY
    CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        ELSE 'Above 30%'
    END
ORDER BY MIN(discount);

-- Customer profitability
SELECT TOP (25)
    customer_name,
    ROUND(SUM(sales), 2) AS sales,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(100.0 * SUM(profit) / NULLIF(SUM(sales), 0), 2) AS profit_margin_pct
FROM dbo.orders_clean
GROUP BY customer_name
ORDER BY profit;

-- Quarterly trend and variance
WITH quarterly AS (
    SELECT
        DATEFROMPARTS(YEAR(order_date), ((DATEPART(QUARTER, order_date) - 1) * 3) + 1, 1) AS quarter_start,
        SUM(profit) AS quarterly_profit
    FROM dbo.orders_clean
    GROUP BY YEAR(order_date), DATEPART(QUARTER, order_date)
)
SELECT
    quarter_start,
    ROUND(quarterly_profit, 2) AS quarterly_profit,
    ROUND(
        quarterly_profit - LAG(quarterly_profit) OVER (ORDER BY quarter_start),
        2
    ) AS profit_variance_from_prior_quarter
FROM quarterly
ORDER BY quarter_start;
