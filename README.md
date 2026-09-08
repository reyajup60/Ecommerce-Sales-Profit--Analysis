# E-commerce Sales & Profit Analysis Dashboard

A Junior Data Analyst portfolio project analyzing 7,500 e-commerce orders (2025) to uncover sales, profitability, and customer trends — from raw data cleaning through Excel, SQL, and Power BI.

---

## Project Overview

This project simulates a real-world business analytics task: an e-commerce company needs to understand where its sales and profit are actually coming from, which regions/products are underperforming, and what actions could improve profitability. The project takes a deliberately messy raw dataset through a full analyst workflow — cleaning, validation, exploratory analysis, dashboarding, and business recommendations.

## Business Problem

Leadership can see total revenue is growing, but has no visibility into **profit** at the category, region, product, or customer level — and no idea where the business might be quietly losing money on discounted orders. This project answers that.

## Objectives

1. Identify which products and categories generate the most sales *and* profit (not the same thing)
2. Compare regional and city-level performance
3. Detect seasonal/monthly sales patterns
4. Segment customers by value and purchase behavior
5. Understand payment method usage
6. Flag where the business is losing money or running thin margins
7. Turn findings into practical, actionable recommendations

## Dataset

- **7,500 order-level records**, January–December 2025
- 15 columns: Order_ID, Order_Date, Customer_ID, Customer_Segment, Region, City, Category, Product, Quantity, Unit_Price, Discount, Sales, Cost, Profit, Payment_Method
- Raw data intentionally contains realistic data-quality issues: inconsistent capitalization, extra whitespace, and missing values — used as a cleaning exercise
- Source files: `Raw_Data` sheet (uncleaned) and `Clean_Data` sheet/CSV (cleaned output of this project)

## Tools & Technologies

- **Excel** — data cleaning, pivot-style SUMIFS analysis tables, charts (`openpyxl`)
- **SQL** — 20 analytical queries (aggregation, CASE, HAVING, window functions)
- **Power BI** — dashboard specification with DAX measures, KPI cards, slicers
- **Python (pandas)** — cleaning logic, validation, and cross-checking every number that appears in Excel/SQL/Power BI

## Data Cleaning

Raw data issues found and resolved (full detail in `Cleaning_Log.md`):

| Issue | Rows Affected | Resolution |
|---|---|---|
| Leading/trailing whitespace | 133–135 per column | Stripped across all text fields |
| Inconsistent capitalization (UPPER/lower/Mixed) | ~700+ values | Standardized to canonical proper case |
| Missing Customer_Segment | 89 | 79 recovered via Customer_ID lookup (segment is fixed per customer); 10 unrecoverable → labeled "Not Specified" |
| Missing City | 59 | 51 recovered via Customer_ID lookup; 8 labeled "Not Specified" |
| Missing Discount | 45 | Back-calculated from `Discount = 1 − Sales/(Quantity × Unit_Price)` |
| Missing Payment_Method | 112 | No reliable derivation exists — labeled "Not Specified" rather than guessed |
| Duplicate records | 0 | Verified, none found |

**No missing values were filled with invented or assumed business data** — every fill is either mathematically derived from other columns in the same row, or looked up from another row of the same customer where the value is logically fixed.

## Analysis Performed

- KPI calculation (Total Sales, Cost, Profit, Margin, Orders, AOV, etc.)
- Category, Region, City, Monthly, Customer Segment, Product, and Payment Method breakdowns
- Top/bottom performer identification (products, cities, customers)
- Loss-making order investigation (root-cause: discount depth on Electronics)
- Month-over-month growth and seasonal trend detection

## Key KPIs

| Metric | Value |
|---|---|
| Total Sales | ₹14,89,95,597.50 |
| Total Profit | ₹3,32,01,603.22 |
| Profit Margin | 22.3% |
| Total Orders | 7,500 |
| Average Order Value | ₹19,866 |
| Unique Customers | 2,345 |

## Key Insights

- **Home & Kitchen** delivers the most profit (₹1.58 Cr, 25.0% margin) despite fewer orders than Electronics
- **Electronics** leads in sales (₹6.21 Cr) but lags in margin (12.0%) — Laptop and Smartphone are the two biggest margin drags
- All **88 loss-making orders** are in Electronics, linked to above-average discounting (16.9% vs 10.6% baseline)
- **Oct–Nov festive season** sees a 62% order-volume spike vs. the rest of the year
- **West and South regions** contribute 58% of total profit; **Central** has the best margin (24.7%) despite the smallest volume
- **37% of customers** ordered only once — meaningful repeat-purchase upside

Full breakdown with all 12 insights: [`Business_Insights_and_Recommendations.md`](./Business_Insights_and_Recommendations.md)

## Business Recommendations

1. Re-price/bundle low-margin Electronics (Laptop, Smartphone, LED TV, Tablet)
2. Cap discounting on Electronics to stop the ~88 loss-making orders
3. Increase investment in Fashion and Home & Kitchen (highest margins)
4. Plan Oct–Nov inventory/staffing around the demand spike, with a margin-conscious product push
5. Launch a repeat-purchase incentive given the 37% one-time-buyer base
6. Investigate Central region's efficiency for replication elsewhere
7. Fix Payment_Method capture at checkout (112 unlogged orders)

## Dashboard

Power BI dashboard specification (KPI cards, DAX measures, visuals, slicers, layout) is documented in [`PowerBI_Dashboard_Guide.md`](./PowerBI_Dashboard_Guide.md). A `.pbix` file was not generated (no Power BI Desktop available in this build environment) — the guide is written so the dashboard can be reproduced exactly by importing `Clean_Data.csv`.

## SQL Analysis

20 queries covering KPIs, category/product/region/city performance, monthly trends (including a window-function MoM growth query), customer segmentation, loss/low-margin detection, and payment method analysis: [`ecommerce_sales_analysis.sql`](./ecommerce_sales_analysis.sql)

## Project Structure

```
ecommerce-sales-profit-analysis/
│
├── README.md
├── Business_Insights_and_Recommendations.md
├── PowerBI_Dashboard_Guide.md
├── Cleaning_Log.md
├── Project_Summary.md
├── LinkedIn_Project_Post.md
├── ecommerce_sales_analysis.sql
│
├── data/
│   ├── Ecommerce_Sales_Profit_Analysis_Final.xlsx   # Full workbook (12 sheets)
│   └── Ecommerce_Sales_Profit_Analysis_Clean_Final.csv
│
└── screenshots/
    └── (dashboard screenshots — add after building in Power BI Desktop)
```

## Skills Demonstrated

- Data cleaning & validation (Python/pandas, Excel)
- Formula-driven Excel modeling (SUMIFS, no hardcoded values)
- SQL querying (aggregation, CASE, HAVING, window functions)
- Dashboard design & DAX measures (Power BI)
- Business-focused insight generation from raw data
- Data documentation (data dictionary, cleaning log, validation checks)

## Conclusion

This project reflects a complete, end-to-end analyst workflow on a realistic (if imperfect) dataset — the kind of first project a BCA graduate can point to as evidence of practical data analysis ability, not just tool familiarity. All numbers across Excel, SQL, and the Power BI guide are cross-verified to match exactly.

---

*Built as a self-directed portfolio project. No claims of employment, client work, or professional experience are made — this is a learning and demonstration project.*
