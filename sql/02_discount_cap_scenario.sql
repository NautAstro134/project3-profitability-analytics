/*
Discount-cap what-if scenario.

Assumptions:
- sales is recorded net of discount
- list price, unit cost, quantity, and demand do not change
- rows already at or below the cap are unchanged
- this is a scenario estimate, not a forecast or realized result
*/

DECLARE @discount_cap decimal(5,4) = 0.20;

WITH scenario AS (
    SELECT
        sales,
        profit,
        discount,
        CASE
            WHEN discount > @discount_cap AND discount < 1
            THEN (sales / (1 - discount)) * (discount - @discount_cap)
            ELSE 0
        END AS estimated_profit_improvement
    FROM dbo.orders_clean
)
SELECT
    @discount_cap AS discount_cap,
    ROUND(SUM(profit), 2) AS current_profit,
    ROUND(SUM(estimated_profit_improvement), 2) AS estimated_profit_improvement,
    ROUND(SUM(profit + estimated_profit_improvement), 2) AS estimated_profit_with_cap
FROM scenario;
