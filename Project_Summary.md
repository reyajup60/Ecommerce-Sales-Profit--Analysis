# Project Summary
### E-commerce Sales & Profit Analysis Dashboard

## What This Project Is
A complete Junior Data Analyst portfolio project built on a 7,500-order e-commerce dataset (2025), covering the full analyst workflow: data validation → cleaning → Excel analysis → SQL querying → Power BI dashboard design → business insights → GitHub/LinkedIn presentation.

## Dataset Validation (Step 1)
- Confirmed 7,500 records, Jan–Dec 2025 date range
- Order_ID: 100% unique, no duplicates
- Customer_ID → Region/City/Segment: verified fixed and consistent per customer
- Product → Category: verified fixed and consistent per product
- Sales formula (`Qty × Unit_Price × (1−Discount)`) and Profit formula (`Sales − Cost`): 0 mismatches across all 7,500 rows
- Data-quality issues found: whitespace, inconsistent capitalization, and missing values in Customer_Segment, City, Discount, and Payment_Method — all resolved and logged (see Cleaning_Log.md)

## What Was Built

| Deliverable | File | Status |
|---|---|---|
| Cleaned dataset (Excel, 12 sheets) | `Ecommerce_Sales_Profit_Analysis_Final.xlsx` | ✅ Complete, 338 live formulas, 0 errors |
| Cleaned dataset (CSV) | `Ecommerce_Sales_Profit_Analysis_Clean_Final.csv` | ✅ Complete, 7,500 rows |
| SQL analysis | `ecommerce_sales_analysis.sql` | ✅ 20 queries, validated against SQLite |
| Power BI dashboard spec | `PowerBI_Dashboard_Guide.md` | ✅ Complete (`.pbix` not buildable in this environment — see note below) |
| Business insights | `Business_Insights_and_Recommendations.md` | ✅ 12 insights + 8 recommendations, all figures sourced from Clean_Data |
| GitHub README | `README.md` | ✅ Complete |
| LinkedIn post | `LinkedIn_Project_Post.md` | ✅ Complete |
| Cleaning log | `Cleaning_Log.md` (+ Excel sheet) | ✅ 11-step log |
| This summary | `Project_Summary.md` | ✅ |

**Note on Power BI:** This environment cannot run Power BI Desktop (Windows-only application), so a `.pbix` binary could not be produced. `PowerBI_Dashboard_Guide.md` is a complete, step-by-step build spec — data import, DAX measures, visuals, slicers, and layout — written against the exact same Clean_Data so the resulting dashboard numbers will match the Excel and SQL outputs exactly.

## Final Quality Check

- ✅ Numbers consistent across Excel, SQL, and insights doc (spot-checked: Total Sales ₹14,89,95,597.50, Total Profit ₹3,32,01,603.22 — identical in KPI_Summary, SQLite query output, and Business_Insights.md)
- ✅ Sales/Profit formulas verified correct (0 mismatches) both in Python and via Excel's own recalculation (LibreOffice recalc: 338 formulas, 0 errors)
- ✅ All insights trace to actual computed figures — no invented statistics
- ✅ No missing values filled with guessed business data — every fill is either a formula derivation or a same-customer lookup; genuinely unrecoverable values are labeled "Not Specified"
- ✅ No fake work experience, employment, or certifications claimed anywhere
- ✅ File names match the requested deliverable list
- ✅ SQL queries validated to return the same numbers as the Excel workbook (cross-checked via SQLite)
- ✅ Power BI DAX measures mirror the Excel KPI formulas exactly (same SUM/DIVIDE logic)
- ✅ README accurately reflects the actual project (no scope not covered in the files)

## Key Numbers at a Glance

- **Total Sales:** ₹14,89,95,597.50
- **Total Profit:** ₹3,32,01,603.22 (22.3% margin)
- **Total Orders:** 7,500 | **Unique Customers:** 2,345
- **Best category by profit:** Home & Kitchen (₹1.58 Cr, 25.0% margin)
- **Worst category by margin:** Electronics (12.0% margin, despite highest sales)
- **Loss-making orders:** 88 (all Electronics, discount-driven)
- **Best region by margin:** Central (24.7%)
- **Peak season:** October–November (+62% order volume vs. rest of year)
