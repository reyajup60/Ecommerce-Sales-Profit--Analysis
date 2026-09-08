/* ============================================================================
   E-COMMERCE SALES & PROFIT ANALYSIS — SQL ANALYSIS
   Dataset : Clean_Data (7,500 orders, Jan 2025 - Dec 2025)
   Author  : Junior Data Analyst Portfolio Project
   Notes   : Written against a table named `clean_data` with columns:
             Order_ID, Order_Date, Customer_ID, Customer_Segment, Region, City,
             Category, Product, Quantity, Unit_Price, Discount, Sales, Cost,
             Profit, Payment_Method
             Syntax targets standard ANSI SQL / MySQL / PostgreSQL (minor
             function-name differences noted inline where relevant).
   ============================================================================ */


/* ---------------------------------------------------------------------------
   TABLE SETUP (for reference — run once when loading Clean_Data.csv)
--------------------------------------------------------------------------- */
CREATE TABLE clean_data (
    Order_ID          VARCHAR(15) PRIMARY KEY,
    Order_Date        DATE,
    Customer_ID       VARCHAR(15),
    Customer_Segment  VARCHAR(20),
    Region            VARCHAR(15),
    City              VARCHAR(30),
    Category          VARCHAR(20),
    Product           VARCHAR(30),
    Quantity          INT,
    Unit_Price        DECIMAL(10,2),
    Discount          DECIMAL(4,2),
    Sales             DECIMAL(12,2),
    Cost              DECIMAL(12,2),
    Profit            DECIMAL(12,2),
    Payment_Method    VARCHAR(20)
);


/* ============================================================================
   SECTION 1 — CORE KPIs
   ============================================================================ */

-- 1. Total sales across the full dataset
SELECT ROUND(SUM(Sales), 2) AS Total_Sales
FROM clean_data;

-- 2. Total cost of goods sold
SELECT ROUND(SUM(Cost), 2) AS Total_Cost
FROM clean_data;

-- 3. Total profit
SELECT ROUND(SUM(Profit), 2) AS Total_Profit
FROM clean_data;

-- 4. Overall profit margin (%)
SELECT ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS Profit_Margin_Pct
FROM clean_data;

-- 5. Total number of orders
SELECT COUNT(*) AS Total_Orders
FROM clean_data;

-- 6. Total quantity of units sold
SELECT SUM(Quantity) AS Total_Quantity
FROM clean_data;

-- 7. Average order value (AOV)
SELECT ROUND(SUM(Sales) / COUNT(*), 2) AS Average_Order_Value
FROM clean_data;


/* ============================================================================
   SECTION 2 — CATEGORY PERFORMANCE
   ============================================================================ */

-- 8. Sales by category (highest to lowest)
SELECT Category,
       ROUND(SUM(Sales), 2) AS Total_Sales,
       COUNT(*)             AS Orders
FROM clean_data
GROUP BY Category
ORDER BY Total_Sales DESC;

-- 9. Profit by category, with profit margin
SELECT Category,
       ROUND(SUM(Profit), 2)                                   AS Total_Profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)               AS Profit_Margin_Pct
FROM clean_data
GROUP BY Category
ORDER BY Total_Profit DESC;


/* ============================================================================
   SECTION 3 — PRODUCT PERFORMANCE
   ============================================================================ */

-- 10. Top 10 most profitable products
SELECT Product,
       Category,
       ROUND(SUM(Profit), 2) AS Total_Profit
FROM clean_data
GROUP BY Product, Category
ORDER BY Total_Profit DESC
LIMIT 10;

-- 11. Top 10 products by sales value
SELECT Product,
       Category,
       ROUND(SUM(Sales), 2) AS Total_Sales,
       SUM(Quantity)        AS Units_Sold
FROM clean_data
GROUP BY Product, Category
ORDER BY Total_Sales DESC
LIMIT 10;


/* ============================================================================
   SECTION 4 — REGIONAL & CITY PERFORMANCE
   ============================================================================ */

-- 12. Sales by region
SELECT Region,
       ROUND(SUM(Sales), 2) AS Total_Sales,
       COUNT(*)             AS Orders
FROM clean_data
GROUP BY Region
ORDER BY Total_Sales DESC;

-- 13. Profit by region, with margin
SELECT Region,
       ROUND(SUM(Profit), 2)                       AS Total_Profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)   AS Profit_Margin_Pct
FROM clean_data
GROUP BY Region
ORDER BY Total_Profit DESC;

-- 14. Sales by city (top 15) — shows metro concentration
SELECT City,
       Region,
       ROUND(SUM(Sales), 2) AS Total_Sales,
       COUNT(*)             AS Orders
FROM clean_data
WHERE City <> 'Not Specified'
GROUP BY City, Region
ORDER BY Total_Sales DESC
LIMIT 15;


/* ============================================================================
   SECTION 5 — TIME TREND ANALYSIS
   ============================================================================ */

-- 15. Monthly sales trend
-- (DATE_FORMAT is MySQL syntax; use TO_CHAR(Order_Date,'YYYY-MM') in PostgreSQL)
SELECT DATE_FORMAT(Order_Date, '%Y-%m') AS Order_Month,
       ROUND(SUM(Sales), 2)            AS Total_Sales
FROM clean_data
GROUP BY Order_Month
ORDER BY Order_Month;

-- 16. Monthly profit trend with month-over-month growth (window function)
SELECT Order_Month,
       Total_Profit,
       ROUND(
         (Total_Profit - LAG(Total_Profit) OVER (ORDER BY Order_Month))
         * 100.0 / LAG(Total_Profit) OVER (ORDER BY Order_Month), 2
       ) AS MoM_Profit_Growth_Pct
FROM (
    SELECT DATE_FORMAT(Order_Date, '%Y-%m') AS Order_Month,
           ROUND(SUM(Profit), 2)            AS Total_Profit
    FROM clean_data
    GROUP BY Order_Month
) monthly
ORDER BY Order_Month;


/* ============================================================================
   SECTION 6 — CUSTOMER ANALYSIS
   ============================================================================ */

-- 17. Customer segment performance
SELECT Customer_Segment,
       ROUND(SUM(Sales), 2)                     AS Total_Sales,
       ROUND(SUM(Profit), 2)                    AS Total_Profit,
       COUNT(DISTINCT Customer_ID)              AS Unique_Customers,
       ROUND(SUM(Sales) / COUNT(*), 2)          AS Avg_Order_Value
FROM clean_data
GROUP BY Customer_Segment
ORDER BY Total_Sales DESC;

-- 18. Top 10 customers by total sales (with CASE-based loyalty tag)
SELECT Customer_ID,
       Customer_Segment,
       Region,
       ROUND(SUM(Sales), 2) AS Total_Sales,
       COUNT(*)             AS Orders,
       CASE
           WHEN COUNT(*) >= 10 THEN 'High Frequency'
           WHEN COUNT(*) >= 5  THEN 'Medium Frequency'
           ELSE 'Low Frequency'
       END AS Purchase_Frequency_Tag
FROM clean_data
GROUP BY Customer_ID, Customer_Segment, Region
ORDER BY Total_Sales DESC
LIMIT 10;


/* ============================================================================
   SECTION 7 — PROFITABILITY RISK: LOSS / LOW-PROFIT ORDERS
   ============================================================================ */

-- 19. Loss-making and low-margin products (avg margin below 15%)
SELECT Product,
       Category,
       ROUND(SUM(Sales), 2)                        AS Total_Sales,
       ROUND(SUM(Profit), 2)                        AS Total_Profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)   AS Profit_Margin_Pct,
       SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END)  AS Loss_Making_Orders
FROM clean_data
GROUP BY Product, Category
HAVING ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) < 15
ORDER BY Profit_Margin_Pct ASC;


/* ============================================================================
   SECTION 8 — PAYMENT METHOD ANALYSIS
   ============================================================================ */

-- 20. Payment method usage and sales contribution
SELECT Payment_Method,
       COUNT(*)                                                        AS Orders,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clean_data), 1)  AS Pct_Of_Orders,
       ROUND(SUM(Sales), 2)                                            AS Total_Sales
FROM clean_data
GROUP BY Payment_Method
ORDER BY Orders DESC;

/* ============================================================================
   END OF FILE
   ============================================================================ */
