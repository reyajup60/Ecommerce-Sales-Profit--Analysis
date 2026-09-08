# Power BI Dashboard Guide
### E-commerce Sales & Profit Analysis Dashboard

This document is a complete build specification for the Power BI dashboard. A `.pbix` file cannot be generated in this environment (Power BI Desktop is a Windows application with no file-format library support here), so this guide gives everything needed to build it in Power BI Desktop in under an hour.

---

## 1. Data Import

1. Open Power BI Desktop → **Get Data** → **Text/CSV** (or **Excel Workbook**).
2. Import `Clean_Data.csv` (or the `Clean_Data` sheet from `Ecommerce_Sales_Profit_Analysis_Final.xlsx`).
3. In Power Query Editor, confirm data types:
   - `Order_Date` → Date
   - `Quantity` → Whole Number
   - `Unit_Price`, `Discount`, `Sales`, `Cost`, `Profit` → Decimal Number
   - All other columns → Text
4. Click **Close & Apply**.

## 2. Data Model

This is a **single-table model** — Clean_Data is already flat (one row = one order line), so no relationships are required for the core dashboard.

**Recommended additions:**
- Create a dedicated **Date table** (Modeling → New Table) for cleaner time-intelligence:
  ```
  DateTable = CALENDAR(DATE(2025,1,1), DATE(2025,12,31))
  ```
  Then mark it as a Date Table (Modeling → Mark as Date Table) and relate `DateTable[Date]` (1) → `Clean_Data[Order_Date]` (many).

## 3. Calculated Columns

Add these in `Clean_Data`:

```DAX
Order_Month = FORMAT('Clean_Data'[Order_Date], "YYYY-MM")

Order_Quarter = "Q" & QUARTER('Clean_Data'[Order_Date])

Profit_Flag = IF('Clean_Data'[Profit] < 0, "Loss", "Profit")
```

## 4. DAX Measures

Create these in a dedicated **Measures** table (or directly on Clean_Data):

```DAX
Total Sales = SUM('Clean_Data'[Sales])

Total Cost = SUM('Clean_Data'[Cost])

Total Profit = SUM('Clean_Data'[Profit])

Profit Margin % = DIVIDE([Total Profit], [Total Sales], 0)

Total Orders = DISTINCTCOUNT('Clean_Data'[Order_ID])

Total Quantity = SUM('Clean_Data'[Quantity])

Average Order Value = DIVIDE([Total Sales], [Total Orders], 0)

Average Profit per Order = DIVIDE([Total Profit], [Total Orders], 0)

Unique Customers = DISTINCTCOUNT('Clean_Data'[Customer_ID])

Loss Making Orders = CALCULATE([Total Orders], 'Clean_Data'[Profit] < 0)

MoM Sales Growth % =
VAR CurrentSales = [Total Sales]
VAR PrevMonthSales =
    CALCULATE(
        [Total Sales],
        DATEADD('DateTable'[Date], -1, MONTH)
    )
RETURN
    DIVIDE(CurrentSales - PrevMonthSales, PrevMonthSales, 0)
```

## 5. KPI Cards (top row of dashboard)

| Card | Measure | Format |
|---|---|---|
| Total Sales | `[Total Sales]` | ₹ #,##0, in Lakh/Crore if desired |
| Total Profit | `[Total Profit]` | ₹ #,##0 |
| Profit Margin % | `[Profit Margin %]` | 0.0% |
| Total Orders | `[Total Orders]` | #,##0 |
| Average Order Value | `[Average Order Value]` | ₹ #,##0 |

Use **Card** visuals, arranged horizontally, with a consistent accent color (e.g., navy `#1F4E78`) and a light background.

## 6. Core Visuals

| Visual | Type | Fields |
|---|---|---|
| Monthly Sales Trend | Line chart | Axis: `Order_Month`, Values: `[Total Sales]` |
| Monthly Profit Trend | Line chart | Axis: `Order_Month`, Values: `[Total Profit]` |
| Sales by Category | Clustered bar chart | Axis: `Category`, Values: `[Total Sales]` |
| Profit by Category | Clustered bar chart | Axis: `Category`, Values: `[Total Profit]`, sorted descending |
| Sales by Region | Bar chart or Filled Map | Axis: `Region`, Values: `[Total Sales]` |
| Profit by Region | Bar chart | Axis: `Region`, Values: `[Total Profit]` |
| Top 10 Products | Horizontal bar chart | Axis: `Product` (Top N filter = 10 by Total Sales), Values: `[Total Sales]` |
| Customer Segment Performance | Donut or stacked bar | Legend: `Customer_Segment`, Values: `[Total Sales]`, `[Total Profit]` |

**Tip:** Combine Monthly Sales Trend and Monthly Profit Trend into a single dual-line chart to show the volume-vs-margin gap during festive months (Oct–Nov) — this is one of the dataset's key insights.

## 7. Slicers / Filters

Place these in a slicer panel on the left or top of the report:

- **Date** — between slicer on `Order_Date` (or `DateTable[Date]`)
- **Region** — dropdown or list slicer
- **Category** — dropdown or list slicer
- **Customer_Segment** — dropdown or list slicer
- **Payment_Method** — dropdown or list slicer

Sync slicers across all report pages if using multiple pages (View → Sync Slicers).

## 8. Dashboard Layout

**Recommended single-page layout (1280×720 or 16:9):**

```
┌─────────────────────────────────────────────────────────────┐
│  Title: E-commerce Sales & Profit Analysis Dashboard  [Date] │
├─────────────────────────────────────────────────────────────┤
│  [Total Sales] [Total Profit] [Margin %] [Orders] [AOV]      │  ← KPI cards
├───────────────────────────┬─────────────────────────────────┤
│  Monthly Sales & Profit    │   Sales by Category (bar)       │
│  Trend (line, dual axis)   │   Profit by Category (bar)      │
├───────────────────────────┼─────────────────────────────────┤
│  Sales by Region (bar/map) │   Top 10 Products (bar)         │
├───────────────────────────┴─────────────────────────────────┤
│  Customer Segment Performance (donut)                        │
├─────────────────────────────────────────────────────────────┤
│  Slicers: Date | Region | Category | Segment | Payment Method│
└─────────────────────────────────────────────────────────────┘
```

## 9. Titles & Formatting

- **Report title:** "E-commerce Sales & Profit Analysis — 2025"
- **Font:** Segoe UI (Power BI default) throughout for consistency
- **Color palette:** Navy (`#1F4E78`) for primary metrics, green (`#2E7D32`) for profit-positive indicators, red/orange (`#C0392B`) sparingly for loss/negative callouts only
- **Number formatting:** All currency in ₹ with thousands separators; percentages to 1 decimal
- Keep visuals free of 3D effects, heavy shadows, or decorative icons — prioritize readability over decoration, per the business-focused brief

## 10. Suggested Second Page (optional): Deep-Dive

- Product-level table with conditional formatting (red highlight where margin < 15%, matching the SQL "low-margin products" query)
- Loss-making orders table filtered to `Profit_Flag = "Loss"`
- Customer table: Top 20 by Sales with Region/Segment breakdown

---

*This guide was built against the same Clean_Data used in the Excel workbook and SQL file — all measure logic matches KPI_Summary and Category_Analysis exactly, so the Power BI numbers will reconcile with the Excel and SQL outputs.*
