# Cleaning Log
### Raw_Data → Clean_Data — E-commerce Sales & Profit Analysis

This log records every cleaning decision made, in order, with the exact number of rows affected. The same log appears as a sheet inside `Ecommerce_Sales_Profit_Analysis_Final.xlsx` (`Cleaning_Log` tab).

| Step | Issue Found | Action Taken | Rows Affected | Notes |
|---|---|---|---|---|
| 1 | Initial load | Loaded Raw_Data sheet | 7,500 | 7,500 rows, 15 columns |
| 2 | Leading/trailing whitespace in text fields | Stripped whitespace from all text columns | 763 | Applied `.strip()` across Customer_Segment, Region, City, Category, Product, Payment_Method |
| 3 | Inconsistent capitalization (UPPER/lower/Mixed case) | Standardized to canonical proper-case values using a fixed lookup map | 700+ | Region, Customer_Segment, Category, Payment_Method, Product, City all normalized |
| 4 | Date/type formatting | Converted Order_Date to datetime; confirmed Quantity as integer | 7,500 | No invalid dates or non-integer quantities found |
| 5 | Missing Customer_Segment (89 rows) | Recovered 79 rows via Customer_ID lookup (segment is fixed per customer, confirmed in Data_Dictionary). Remaining 10 rows (customer had no other order) labeled "Not Specified" — not invented | 89 | 79 recovered, 10 labeled Not Specified |
| 6 | Missing City (59 rows) | Recovered 51 rows via Customer_ID lookup (city is fixed per customer). Remaining 8 rows labeled "Not Specified" — Region retained, not invented | 59 | 51 recovered, 8 labeled Not Specified |
| 7 | Missing Discount (45 rows) | Back-calculated using the documented formula Discount = 1 − Sales/(Quantity × Unit_Price). Verified results land exactly on the dataset's standard discount tiers (5%/10%/15%/20%), confirming accuracy | 45 | 0 rows remain missing |
| 8 | Missing Payment_Method (112 rows) | No reliable relationship exists to derive payment method (unlike Segment/City, it is not fixed per customer). Labeled "Not Specified" rather than guessing | 112 | Shown as its own category in Payment_Method breakdowns rather than dropped or guessed |
| 9 | Duplicate record check (excluding Order_ID) | Checked for fully duplicated order rows | 0 | No duplicate records found — no rows removed |
| 10 | Sales & Profit formula validation | Verified Sales = Qty × Unit_Price × (1−Discount) and Profit = Sales − Cost for every row | 0 mismatches | Sales mismatches: 0, Profit mismatches: 0 — fully consistent |
| 11 | Final QA | Row count preserved, no rows dropped, all columns validated | 7,500 | Final Clean_Data: 7,500 rows × 15 columns (+1 helper column, Order_Month) |

## Guiding Principle

At every step where a value was missing, the priority order was:

1. **Can it be mathematically derived** from other columns in the same row? (→ Discount)
2. **Can it be looked up** from another row that logically must share the same value? (→ Customer_Segment, City — both fixed per Customer_ID per the Data Dictionary)
3. **If neither applies**, the value is labeled `"Not Specified"` rather than filled with an assumed or invented business value. (→ Payment_Method, and the residual unrecoverable Segment/City rows)

This keeps every number in the final workbook, SQL output, and Power BI dashboard traceable back to either the original data or a documented, defensible derivation — never a guess.
