# Retail Profitability Analysis

## Overview

This project analyzes sales, profit, discounting, customer profitability, quarterly trends, and product-level contribution using SQL Server and Power BI.

The goal is to identify the main drivers of profit, locate unprofitable products and customers, evaluate discount risk, and test a practical discount-cap scenario.

## Tools Used

- SQL Server Developer
- Power BI Desktop
- SQL
- Excel / source spreadsheets
- Git and GitHub

## Dataset

The analysis uses Superstore sample data imported into the SQL Server database `project3_profitability`.

Main tables:

- `orders_clean`
- `returns`
- `people`

The working Orders dataset contains approximately 10,195 rows.

The SQL scripts expect these `orders_clean` columns: `order_date`, `customer_name`, `category`, `sub_category`, `product_name`, `sales`, `profit`, and `discount`.

## Key Metrics

- Total Sales: **$2.33M**
- Total Profit: **$292K**
- Overall Profit Margin: **12.56%**

## Reproduce the SQL Analysis

Run the scripts in this order in SQL Server Management Studio:

1. `sql/01_profitability_analysis.sql`
2. `sql/02_discount_cap_scenario.sql`
3. `sql/03_validation.sql`

The scripts document the KPI, category, subcategory, customer, discount-band, quarterly, and discount-cap calculations used to support the Power BI report.

## Key Findings

### Category Profitability

- Technology margin: approximately **17.45%**
- Office Supplies margin: approximately **17.22%**
- Furniture margin: approximately **2.61%**

Furniture is the weakest category by a large margin.

### Unprofitable Subcategories

- Tables: approximately **-$17.8K profit**
- Tables margin: approximately **-8.53%**
- Bookcases: approximately **-$3.6K profit**

### Discount Risk

Lower discounts are generally profitable, while higher discount levels increasingly produce losses. Discounts above roughly **20%** are frequently associated with weaker or negative profit.

### Customer Profitability

High sales do not always mean high profitability. Sean Miller generated strong sales but negative profit because of a heavily discounted Cisco TelePresence EX90 transaction.

### What-If Discount Cap

At a **20% discount cap**:

- Current Profit: approximately **$292K**
- Estimated Profit Improvement: approximately **$220K**
- Estimated Profit With Discount Cap: approximately **$513K**

This is a scenario estimate, not observed profit. The calculation assumes list price, unit cost, quantity, and customer demand remain unchanged. For rows above the cap, it estimates recovered revenue as:

`sales / (1 - current_discount) × (current_discount - discount_cap)`

The estimated recovery is added to recorded profit. Actual results could be materially lower if reduced discounts change purchasing behavior.

## Business Recommendations

1. Limit routine discounts to approximately **20%** unless a larger discount is specifically justified.
2. Review Tables and Bookcases for pricing, sourcing, and discount-policy problems.
3. Evaluate major customer transactions using profit as well as sales.
4. Monitor high-discount orders before approval.
5. Use quarterly profit and variance trends to identify sudden profitability changes.

## Dashboard Pages

### 1. Profitability Overview

![Profitability Overview](profitability_overview.png)

### 2. Trend & Variance

![Trend and Variance](trend_variance.png)

### 3. Contribution & What-If

![Contribution and What-If](contribution_whatif.png)

## Project Structure

```text
retail-profitability-analysis/
├── sql/
│   ├── 01_profitability_analysis.sql
│   ├── 02_discount_cap_scenario.sql
│   └── 03_validation.sql
├── Retail_Profitability_Analysis.pbix
├── README.md
├── profitability_overview.png
├── trend_variance.png
└── contribution_whatif.png
```

## Portfolio Summary

This project demonstrates SQL-based profitability analysis, Power BI dashboard development, KPI design, customer and product profitability analysis, discount-risk analysis, time-series analysis, scenario modeling, and business interpretation.
