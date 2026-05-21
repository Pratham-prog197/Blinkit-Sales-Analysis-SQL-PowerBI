USE [Blinkit databse]
GO

SELECT * FROM dbo.Blinkit_data


select count(*) from  Blinkit_data --counting all rows
UPDATE blinkit_data
SET Item_Fat_Content =              --“Standardizes inconsistent fat content labels”
CASE 
WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

SELECT DISTINCT(Item_Fat_Content) FROM blinkit_data

SELECT * FROM blinkit_data

SELECT CAST(SUM(Sales)/ 1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions  --“Calculates 2022 total sales revenue” 
FROM blinkit_data 
WHERE Outlet_Establishment_Year = 2022

SELECT CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales FROM blinkit_data  --Calculates average sales for 2022”
WHERE Outlet_Establishment_Year = 2022

SELECT COUNT(*) AS No_Of_Items FROM blinkit_data --items sold in 2022
WHERE Outlet_Establishment_Year = 2022

SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating FROM blinkit_data --average rating by consumers

-- Highlighted Query
SELECT Item_Fat_Content, SUM(Sales) AS Total_Sales --Compares sales by fat content
FROM blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC	

SELECT * FROM blinkit_data

SELECT CAST(SUM(Sales) / 1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions --Total sales revenue
FROM blinkit_data 


SELECT CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales FROM blinkit_data  --average sales revenue




SELECT COUNT(*) AS No_Of_Items FROM blinkit_data  --no of total items in year 2022
WHERE Outlet_Establishment_Year = 2022


SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating FROM blinkit_data  ---- Calculates overall average product rating

-- Analyzes sales by fat content
SELECT Item_Fat_Content, SUM(Sales) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Fat_Content


SELECT Item_Type,  ---- Analyzes sales performance by item type
CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,      
CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
COUNT(*) AS No_Of_Items,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
From blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC


SELECT Outlet_Location_Type, Item_Fat_Content,     ---- Compares outlet sales by fat content and location
CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
COUNT(*) AS No_Of_Items,
CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
From blinkit_data
GROUP BY Outlet_Location_Type, Item_Fat_Content
ORDER BY Total_Sales ASC

SELECT Outlet_Location_Type,    ---- Creates fat content sales pivot report
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

SELECT Outlet_Establishment_Year,  ---- Analyzes sales trend by outlet year
CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
From blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Total_Sales ASC

SELECT    ---- Evaluates yearly outlet sales performance
    Outlet_Establishment_Year,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Total_Sales DESC;



SELECT  ---- Calculates sales contribution by outlet size
    Outlet_Size, 
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

SELECT          ---- Compares  sales across outlet types
    Outlet_Type,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER ()) AS DECIMAL(10,2)) AS Sales_Percentage,
    CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;

SELECT           --performance of outlets by location
    Outlet_Location_Type,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
    CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;
