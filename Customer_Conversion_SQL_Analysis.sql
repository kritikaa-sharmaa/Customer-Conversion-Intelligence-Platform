--create database capstone
--use capstone

--CREATE TABLE CustomerMarketing(
--    CustomerID INT PRIMARY KEY,
--    Age INT,
--    Gender VARCHAR(10),
--    Income DECIMAL(12,2),
--    CampaignChannel VARCHAR(50),
--    CampaignType VARCHAR(50),
--    AdSpend DECIMAL(12,2),
--    ClickThroughRate DECIMAL(10,6),
--    ConversionRate DECIMAL(10,6),
--    WebsiteVisits INT,
--    PagesPerVisit DECIMAL(10,2),
--    TimeOnSite DECIMAL(10,2),
--    SocialShares INT,
--    EmailOpens INT,
--    EmailClicks INT,
--    PreviousPurchases INT,
--    LoyaltyPoints INT,
--    AdvertisingPlatform VARCHAR(100),
--    AdvertisingTool VARCHAR(100),
--    Conversion BIT)

--BULK INSERT dbo.CustomerMarketing
--FROM 'C:\Users\acer\Downloads\Digital Marketing Analysis\Digital Marketing Analysis\Digital_Marketing_dataset\digital_marketing_campaign_dataset.csv'
--WITH
--    (FORMAT = 'CSV',
--    FIRSTROW = 2,
--    ROWTERMINATOR = '0x0a')

--QUERY
SELECT COUNT(*) AS ConvertedCustomers
FROM CustomerMarketing
WHERE Conversion = 1
SELECT COUNT(*) AS ConvertedCustomers
FROM CustomerMarketing
WHERE Conversion = 0
select avg(Income)[Income Average] from CustomerMarketing 
select avg(adspend)[Adspend Average] from CustomerMarketing
select avg(WebsiteVisits)[WebsiteVisits Average] from CustomerMarketing
select avg(LoyaltyPoints)[LoyaltyPoints Average] from CustomerMarketing

--Aggregate Analysis
--Business question: Does average advertising spend differ across campaign types?
select CampaignType, avg(AdSpend)[Average Adspend] from CustomerMarketing group by CampaignType
select AdvertisingPlatform, avg(ClickThroughRate)[Average CTR] from CustomerMarketing group by AdvertisingPlatform
select CampaignType, avg(ConversionRate)[Average ConversionRate] from CustomerMarketing group by CampaignType
select AdvertisingPlatform, avg(TimeOnSite)[Average TimeOnSite] from CustomerMarketing group by AdvertisingPlatform
select Gender, (sum(CAST(Conversion AS INT))*100.0)/COUNT(*)[conversion rate] from CustomerMarketing  group by Gender
select CampaignChannel, (sum(CAST(Conversion AS INT))*100.0)/COUNT(*)[conversion rate] from CustomerMarketing  group by CampaignChannel
select CampaignType, (sum(CAST(Conversion AS INT))*100.0)/COUNT(*)[conversion rate] from CustomerMarketing  group by CampaignType
select AdvertisingTool, (sum(CAST(Conversion AS INT))*100.0)/COUNT(*)[conversion rate] from CustomerMarketing  group by AdvertisingTool
---
SELECT CASE
        WHEN Age < 30 THEN 'Young Adult'
        WHEN Age BETWEEN 30 AND 44 THEN 'Adult'
        WHEN Age BETWEEN 45 AND 59 THEN 'Middle-Aged'
        ELSE 'Senior'
    END AS AgeGroup, SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*) AS ConversionRate
FROM CustomerMarketing
GROUP BY CASE
        WHEN Age < 30 THEN 'Young Adult'
        WHEN Age BETWEEN 30 AND 44 THEN 'Adult'
        WHEN Age BETWEEN 45 AND 59 THEN 'Middle-Aged'
        ELSE 'Senior'
    END
ORDER BY ConversionRate DESC
----
SELECT
    CASE
        WHEN Income < 40000 THEN 'Low Income'
        WHEN Income < 70000 THEN 'Middle Income'
        WHEN Income < 100000 THEN 'Upper-Middle Income'
        ELSE 'High Income'
    END AS IncomeCategory,
    SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*) AS ConversionRate
FROM CustomerMarketing
GROUP BY
    CASE
        WHEN Income < 40000 THEN 'Low Income'
        WHEN Income < 70000 THEN 'Middle Income'
        WHEN Income < 100000 THEN 'Upper-Middle Income'
        ELSE 'High Income'
    END
ORDER BY ConversionRate DESC;
---
SELECT
    CASE
        WHEN LoyaltyPoints < 1000 THEN 'Low Loyalty'
        WHEN LoyaltyPoints < 2500 THEN 'Moderate Loyalty'
        WHEN LoyaltyPoints < 4000 THEN 'High Loyalty'
        ELSE 'Very High Loyalty'
    END AS LoyaltyCategory,
    SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*) AS ConversionRate
FROM CustomerMarketing
GROUP BY
    CASE
        WHEN LoyaltyPoints < 1000 THEN 'Low Loyalty'
        WHEN LoyaltyPoints < 2500 THEN 'Moderate Loyalty'
        WHEN LoyaltyPoints < 4000 THEN 'High Loyalty'
        ELSE 'Very High Loyalty'
    END
ORDER BY ConversionRate DESC;
---
SELECT
    CASE
        WHEN PreviousPurchases = 0 THEN 'New Customer'
        WHEN PreviousPurchases BETWEEN 1 AND 2 THEN 'Occasional Customer'
        WHEN PreviousPurchases BETWEEN 3 AND 5 THEN 'Regular Customer'
        ELSE 'Frequent Customer'
    END AS CustomerSegment,
    SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*) AS ConversionRate
FROM CustomerMarketing
GROUP BY
    CASE
        WHEN PreviousPurchases = 0 THEN 'New Customer'
        WHEN PreviousPurchases BETWEEN 1 AND 2 THEN 'Occasional Customer'
        WHEN PreviousPurchases BETWEEN 3 AND 5 THEN 'Regular Customer'
        ELSE 'Frequent Customer'
    END
ORDER BY ConversionRate DESC;
---
SELECT
    CASE
        WHEN WebsiteVisits < 10 THEN 'Low Engagement'
        WHEN WebsiteVisits BETWEEN 10 AND 19 THEN 'Moderate Engagement'
        WHEN WebsiteVisits BETWEEN 20 AND 29 THEN 'High Engagement'
        ELSE 'Very High Engagement'
    END AS EngagementLevel,
    SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*) AS ConversionRate
FROM CustomerMarketing
GROUP BY
    CASE
        WHEN WebsiteVisits < 10 THEN 'Low Engagement'
        WHEN WebsiteVisits BETWEEN 10 AND 19 THEN 'Moderate Engagement'
        WHEN WebsiteVisits BETWEEN 20 AND 29 THEN 'High Engagement'
        ELSE 'Very High Engagement'
    END
ORDER BY ConversionRate DESC;
---
--RANKINGS
SELECT TOP 10
    CustomerID,
    AdSpend,
    RANK() OVER (ORDER BY AdSpend DESC) AS SpendRank
FROM CustomerMarketing
ORDER BY AdSpend DESC
---
WITH ChannelPerformance AS
(  SELECT
        CampaignChannel,
        COUNT(*) AS TotalCustomers,
        SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*) AS ConversionRate
    FROM CustomerMarketing
    GROUP BY CampaignChannel)
SELECT
    CampaignChannel,
    TotalCustomers,
    ConvertedCustomers,
    ConversionRate,
    RANK() OVER (ORDER BY ConversionRate DESC) AS ChannelRank
FROM ChannelPerformance
ORDER BY ChannelRank;
---
SELECT TOP 10
    CustomerID,
    LoyaltyPoints,
    DENSE_RANK() OVER (ORDER BY LoyaltyPoints DESC) AS LoyaltyRank
FROM CustomerMarketing
ORDER BY LoyaltyPoints DESC;
---
WITH SpendGroups AS(
    SELECT
        CustomerID,
        AdSpend,
        NTILE(4) OVER (ORDER BY AdSpend) AS SpendQuartile
    FROM CustomerMarketing)
SELECT
    SpendQuartile,
    COUNT(*) AS CustomerCount,
    MIN(AdSpend) AS MinimumAdSpend,
    MAX(AdSpend) AS MaximumAdSpend,
    AVG(AdSpend) AS AverageAdSpend
FROM SpendGroups
GROUP BY SpendQuartile
ORDER BY SpendQuartile;
---
--Business question: Which campaign channels have the lowest recorded advertising spend per converted customer?
SELECT
    CampaignChannel,
    COUNT(*) AS TotalCustomers,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    SUM(AdSpend) AS TotalAdSpend,
    SUM(AdSpend) / NULLIF(SUM(CAST(Conversion AS INT)), 0)
        AS SpendPerConversion,
    SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*)
        AS ConversionRate
FROM CustomerMarketing
GROUP BY CampaignChannel
ORDER BY SpendPerConversion ASC;

--Do customers in higher ad-spend groups have higher conversion rates?
WITH SpendGroups AS
(  SELECT
        CustomerID,
        AdSpend,
        Conversion,
        NTILE(4) OVER (ORDER BY AdSpend) AS SpendQuartile
    FROM CustomerMarketing)
SELECT
    SpendQuartile,
    COUNT(*) AS TotalCustomers,
    AVG(AdSpend) AS AverageAdSpend,
    SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*)
        AS ConversionRate
FROM SpendGroups
GROUP BY SpendQuartile
ORDER BY SpendQuartile;

--Which campaign types perform better, and how much do they spend?
SELECT
    CampaignType,
    COUNT(*) AS TotalCustomers,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*)
        AS ConversionRate,
    AVG(AdSpend) AS AverageAdSpend,
    SUM(AdSpend) AS TotalAdSpend
FROM CustomerMarketing
GROUP BY CampaignType
ORDER BY ConversionRate DESC;

--Does the conversion rate change depending on both the campaign type and the channel used?
SELECT
    CampaignType,
    CampaignChannel,
    COUNT(*) AS TotalCustomers,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRate
FROM CustomerMarketing
GROUP BY
    CampaignType,
    CampaignChannel
ORDER BY
    CampaignType,
    ConversionRate DESC;

--Which customers meet our definition of high-value customers based on income, ad spend, and loyalty points?
WITH HighValueCustomers AS
( SELECT
        CustomerID,
        Income,
        AdSpend,
        LoyaltyPoints
    FROM CustomerMarketing
    WHERE Income >= 100000
      AND AdSpend >= 7000
      AND LoyaltyPoints >= 3500)
SELECT *
FROM HighValueCustomers
ORDER BY Income DESC;
---
WITH HighValueCustomers AS
(
    SELECT
        CustomerID,
        Income,
        AdSpend,
        LoyaltyPoints
    FROM CustomerMarketing
    WHERE Income >= 100000
      AND AdSpend >= 7000
      AND LoyaltyPoints >= 3500
)
SELECT
    COUNT(*) AS HighValueCustomerCount,
    AVG(Income) AS AverageIncome,
    AVG(AdSpend) AS AverageAdSpend,
    AVG(LoyaltyPoints) AS AverageLoyaltyPoints
FROM HighValueCustomers;
---
--Which customers show high engagement with the website?
WITH HighlyEngagedCustomers AS
(
    SELECT
        CustomerID,
        WebsiteVisits,
        PagesPerVisit,
        TimeOnSite,
        Conversion
    FROM CustomerMarketing
    WHERE WebsiteVisits >= 30
      AND PagesPerVisit >= 5
      AND TimeOnSite >= 8
)
SELECT *
FROM HighlyEngagedCustomers
ORDER BY TimeOnSite DESC;
---
WITH HighlyEngagedCustomers AS
(
    SELECT
        CustomerID,
        WebsiteVisits,
        PagesPerVisit,
        TimeOnSite,
        Conversion
    FROM CustomerMarketing
    WHERE WebsiteVisits >= 30
      AND PagesPerVisit >= 5
      AND TimeOnSite >= 8
)
SELECT
    COUNT(*) AS HighlyEngagedCustomerCount,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRate,
    AVG(WebsiteVisits) AS AverageWebsiteVisits,
    AVG(PagesPerVisit) AS AveragePagesPerVisit,
    AVG(TimeOnSite) AS AverageTimeOnSite
FROM HighlyEngagedCustomers;
---
--How many customers have high loyalty points, and how do they perform in terms of conversion?
WITH LoyalCustomers AS
(
    SELECT
        CustomerID,
        LoyaltyPoints,
        PreviousPurchases,
        Conversion
    FROM CustomerMarketing
    WHERE LoyaltyPoints >= 3500
)
SELECT
    COUNT(*) AS LoyalCustomerCount,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRate,
    AVG(LoyaltyPoints) AS AverageLoyaltyPoints,
    AVG(PreviousPurchases) AS AveragePreviousPurchases
FROM LoyalCustomers;
--
--How many customers visit the website at least 30 times, and how many of them convert?
WITH HighWebsiteActivity AS
(
    SELECT
        CustomerID,
        WebsiteVisits,
        Conversion
    FROM CustomerMarketing
    WHERE WebsiteVisits >= 30
)
SELECT
    COUNT(*) AS ActiveCustomerCount,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRate,
    AVG(WebsiteVisits) AS AverageWebsiteVisits
FROM HighWebsiteActivity;
---
--Which customers earn above-average income?
SELECT
    CustomerID,
    Income,
    CampaignChannel,
    Conversion
FROM CustomerMarketing
WHERE Income >
(
    SELECT AVG(Income)
    FROM CustomerMarketing
)
ORDER BY Income DESC;
---
WITH AboveAverageIncome AS
(
    SELECT
        CustomerID,
        Income,
        Conversion
    FROM CustomerMarketing
    WHERE Income >
    (
        SELECT AVG(Income)
        FROM CustomerMarketing
    )
)
SELECT
    COUNT(*) AS AboveAverageIncomeCustomers,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRate
FROM AboveAverageIncome;
---
--Do customers who have above-average ad spend show a different conversion rate?
SELECT
    COUNT(*) AS AboveAverageSpendCustomers,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRate
FROM CustomerMarketing
WHERE AdSpend >
(
    SELECT AVG(AdSpend)
    FROM CustomerMarketing
);
---
--Which customers have the highest loyalty points, and did they convert?
SELECT
    CustomerID,
    LoyaltyPoints,
    PreviousPurchases,
    Conversion
FROM CustomerMarketing
WHERE LoyaltyPoints =
(
    SELECT MAX(LoyaltyPoints)
    FROM CustomerMarketing
)
ORDER BY CustomerID;
---
--Which campaign types have an average ConversionRate higher than the overall average ConversionRate?
SELECT
    CampaignType,
    AVG(ConversionRate) AS AvgConversionRate
FROM CustomerMarketing
GROUP BY CampaignType
HAVING AVG(ConversionRate) >
(
    SELECT AVG(ConversionRate)
    FROM CustomerMarketing
)
ORDER BY AvgConversionRate DESC;
---
--Do customers with different purchase histories visit the website at different average frequencies?
SELECT
    CASE
        WHEN PreviousPurchases = 0 THEN 'New Customer'
        WHEN PreviousPurchases BETWEEN 1 AND 2
            THEN 'Occasional Customer'
        WHEN PreviousPurchases BETWEEN 3 AND 5
            THEN 'Regular Customer'
        ELSE 'Frequent Customer'
    END AS CustomerSegment,
    COUNT(*) AS TotalCustomers,
    AVG(CAST(WebsiteVisits AS DECIMAL(10,2)))
        AS AvgWebsiteVisits
FROM dbo.CustomerMarketing
GROUP BY
    CASE
        WHEN PreviousPurchases = 0 THEN 'New Customer'
        WHEN PreviousPurchases BETWEEN 1 AND 2
            THEN 'Occasional Customer'
        WHEN PreviousPurchases BETWEEN 3 AND 5
            THEN 'Regular Customer'
        ELSE 'Frequent Customer'
    END
ORDER BY AvgWebsiteVisits DESC;
---
--How does cumulative recorded ad spend build as we move through customers in CustomerID order?
SELECT
    CustomerID,
    AdSpend,
    SUM(AdSpend) OVER (
        ORDER BY CustomerID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RunningAdSpend
FROM dbo.CustomerMarketing
ORDER BY CustomerID;
---
--Customer Summary View
CREATE VIEW vw_CustomerSummary
AS
SELECT
    CustomerID,
    Age,
    Gender,
    Income,
    PreviousPurchases,
    LoyaltyPoints,
    WebsiteVisits,
    PagesPerVisit,
    TimeOnSite,
    EmailOpens,
    EmailClicks,
    Conversion
FROM CustomerMarketing;
SELECT * FROM vw_CustomerSummary
---
--Average ad spend by platform
SELECT
    CustomerID,
    AdvertisingPlatform,
    AdSpend,
    AVG(AdSpend) OVER (
        PARTITION BY AdvertisingPlatform
    ) AS AvgAdSpendByPlatform
FROM dbo.CustomerMarketing;
---
--How does the cumulative number of website visits increase as we move through the customer records?
SELECT
    CustomerID,
    WebsiteVisits,
    SUM(WebsiteVisits) OVER (
        ORDER BY CustomerID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningWebsiteVisits
FROM dbo.CustomerMarketing
ORDER BY CustomerID;
---
--Running Loyalty Points
SELECT
    CustomerID,
    LoyaltyPoints,
    SUM(LoyaltyPoints) OVER (
        ORDER BY CustomerID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningLoyaltyPoints
FROM dbo.CustomerMarketing
ORDER BY CustomerID;
---
--Do customers with higher-than-average ad spend have a higher observed conversion rate?
WITH SpendGroups AS
(
    SELECT
        CASE
            WHEN AdSpend > AvgSpend
                THEN 'Above Average Spend'
            ELSE 'Average or Below Average Spend'
        END AS SpendGroup,
        Conversion
    FROM CustomerMarketing
    CROSS JOIN
    (
        SELECT AVG(AdSpend) AS AvgSpend
        FROM CustomerMarketing
    ) AS A
)
SELECT
    SpendGroup,
    COUNT(*) AS TotalCustomers,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRatePct
FROM SpendGroups
GROUP BY SpendGroup;
---
WITH SpendGroups AS
(
    SELECT
        CASE
            WHEN AdSpend > AvgSpend
                THEN 'Above Average Spend'
            ELSE 'Average or Below Average Spend'
        END AS SpendGroup,
        AdSpend,
        Conversion
    FROM CustomerMarketing
    CROSS JOIN
    (
        SELECT AVG(AdSpend) AS AvgSpend
        FROM CustomerMarketing
    ) AS A
)
SELECT
    SpendGroup,
    COUNT(*) AS TotalCustomers,
    ROUND(AVG(AdSpend), 2) AS AverageAdSpend,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRatePct
FROM SpendGroups
GROUP BY SpendGroup;
---
SELECT
    CustomerID,
    CampaignChannel,
    CampaignType,
    AdSpend,
    Conversion
FROM CustomerMarketing
WHERE AdSpend > (
    SELECT AVG(AdSpend)
    FROM CustomerMarketing
)
ORDER BY AdSpend DESC;
---
SELECT
    CASE
        WHEN PreviousPurchases = 0 THEN 'New'
        WHEN PreviousPurchases BETWEEN 1 AND 2 THEN 'Occasional'
        WHEN PreviousPurchases BETWEEN 3 AND 5 THEN 'Regular'
        ELSE 'Frequent'
    END AS CustomerSegment,
    COUNT(*) AS TotalCustomers,
    ROUND(AVG(CAST(WebsiteVisits AS FLOAT)), 2) AS AvgWebsiteVisits,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRatePct
FROM CustomerMarketing
GROUP BY
    CASE
        WHEN PreviousPurchases = 0 THEN 'New'
        WHEN PreviousPurchases BETWEEN 1 AND 2 THEN 'Occasional'
        WHEN PreviousPurchases BETWEEN 3 AND 5 THEN 'Regular'
        ELSE 'Frequent'
    END
ORDER BY AvgWebsiteVisits DESC;
---
--Campaign Performance
CREATE VIEW vw_CampaignPerformance
AS
SELECT
    CampaignType,
    COUNT(*) AS TotalCustomers,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRatePct,
    ROUND(AVG(AdSpend), 2) AS AvgAdSpend,
    ROUND(AVG(ConversionRate) * 100, 2) AS AvgRecordedConversionRatePct
FROM CustomerMarketing
GROUP BY CampaignType
SELECT * FROM vw_CampaignPerformance ORDER BY ConversionRatePct DESC;
---
--Average CTR by campaign
SELECT
    CustomerID,
    CampaignType,
    ClickThroughRate,
    AVG(ClickThroughRate) OVER (
        PARTITION BY CampaignType
    ) AS AvgCTRByCampaign
FROM dbo.CustomerMarketing
ORDER BY CampaignType, CustomerID;
---
--Customer Engagement
CREATE VIEW dbo.vw_CustomerEngagement
AS
SELECT
    CustomerID,
    WebsiteVisits,
    PagesPerVisit,
    TimeOnSite,
    EmailOpens,
    EmailClicks,
    SocialShares,
    dbo.fn_EngagementScore(
        WebsiteVisits,
        PagesPerVisit,
        TimeOnSite
    ) AS EngagementScore
FROM dbo.CustomerMarketing;
SELECT * FROM dbo.vw_CustomerEngagement;
---
--Advertising Platform Analysis.
CREATE VIEW vw_AdvertisingPlatform
AS
SELECT
    AdvertisingPlatform,
    COUNT(*) AS TotalCustomers,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRatePct,
    ROUND(AVG(ClickThroughRate) * 100, 2) AS AvgCTRPct,
    ROUND(AVG(TimeOnSite), 2) AS AvgTimeOnSite,
    ROUND(AVG(AdSpend), 2) AS AvgAdSpend
FROM CustomerMarketing
GROUP BY AdvertisingPlatform;
SELECT * FROM vw_AdvertisingPlatform
---
--Loyalty Analysis
CREATE VIEW vw_LoyaltyAnalysis
AS
SELECT
    CASE
        WHEN LoyaltyPoints < 1000 THEN 'Low Loyalty'
        WHEN LoyaltyPoints < 2500 THEN 'Moderate Loyalty'
        WHEN LoyaltyPoints < 4000 THEN 'High Loyalty'
        ELSE 'Very High Loyalty'
    END AS LoyaltyCategory,
    COUNT(*) AS TotalCustomers,
    SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
    ROUND(
        SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
        2
    ) AS ConversionRatePct,
    ROUND(AVG(LoyaltyPoints), 2) AS AvgLoyaltyPoints,
    ROUND(AVG(PreviousPurchases), 2) AS AvgPreviousPurchases
FROM CustomerMarketing
GROUP BY
    CASE
        WHEN LoyaltyPoints < 1000 THEN 'Low Loyalty'
        WHEN LoyaltyPoints < 2500 THEN 'Moderate Loyalty'
        WHEN LoyaltyPoints < 4000 THEN 'High Loyalty'
        ELSE 'Very High Loyalty'
    END;
SELECT * FROM vw_LoyaltyAnalysis ORDER BY AvgLoyaltyPoints;
---
--Customer Summary Report
CREATE PROCEDURE usp_CustomerSummary
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        COUNT(*) AS TotalCustomers,
        SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
        COUNT(*) - SUM(CAST(Conversion AS INT))
            AS NonConvertedCustomers,
        ROUND(AVG(Income), 2) AS AvgIncome,
        ROUND(AVG(AdSpend), 2) AS AvgAdSpend,
        ROUND(AVG(LoyaltyPoints), 2) AS AvgLoyaltyPoints
    FROM CustomerMarketing;
END;
EXEC usp_CustomerSummary;
---
--Campaign Performance Report.
CREATE PROCEDURE usp_CampaignPerformance
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CampaignType,
        COUNT(*) AS TotalCustomers,
        SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
        ROUND(
            SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
            2
        ) AS ConversionRatePct,
        ROUND(AVG(AdSpend), 2) AS AvgAdSpend,
        ROUND(AVG(ConversionRate) * 100, 2)
            AS AvgRecordedConversionRatePct
    FROM CustomerMarketing
    GROUP BY CampaignType
    ORDER BY ConversionRatePct DESC;
END;
EXEC usp_CampaignPerformance;
---
--Advertising Platform Analysis
CREATE PROCEDURE usp_AdvertisingPlatformAnalysis
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        AdvertisingPlatform,
        COUNT(*) AS TotalCustomers,
        SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,
        ROUND(
            SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
            2
        ) AS ConversionRatePct,
        ROUND(AVG(ClickThroughRate) * 100, 2) AS AvgCTRPct,
        ROUND(AVG(AdSpend), 2) AS AvgAdSpend,
        ROUND(AVG(TimeOnSite), 2) AS AvgTimeOnSite
    FROM CustomerMarketing
    GROUP BY AdvertisingPlatform;
END;
EXEC usp_AdvertisingPlatformAnalysis;
---
--Loyalty Report
CREATE PROCEDURE dbo.usp_LoyaltyReport
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        CASE
            WHEN LoyaltyPoints < 1000 THEN 'Low Loyalty'
            WHEN LoyaltyPoints < 2500 THEN 'Moderate Loyalty'
            WHEN LoyaltyPoints < 4000 THEN 'High Loyalty'
            ELSE 'Very High Loyalty'
        END AS LoyaltyCategory,

        COUNT(*) AS TotalCustomers,

        SUM(CAST(Conversion AS INT)) AS ConvertedCustomers,

        ROUND(
            SUM(CAST(Conversion AS INT)) * 100.0 / COUNT(*),
            2
        ) AS ConversionRatePct,

        ROUND(AVG(LoyaltyPoints), 2) AS AvgLoyaltyPoints,

        ROUND(AVG(PreviousPurchases), 2) AS AvgPreviousPurchases

    FROM dbo.CustomerMarketing

    GROUP BY
        CASE
            WHEN LoyaltyPoints < 1000 THEN 'Low Loyalty'
            WHEN LoyaltyPoints < 2500 THEN 'Moderate Loyalty'
            WHEN LoyaltyPoints < 4000 THEN 'High Loyalty'
            ELSE 'Very High Loyalty'
        END

    ORDER BY AvgLoyaltyPoints;
END;
EXEC usp_LoyaltyReport;
---
--Engagement Score
CREATE FUNCTION dbo.fn_EngagementScore
(   @WebsiteVisits INT,
    @PagesPerVisit DECIMAL(10,2),
    @TimeOnSite DECIMAL(10,2))
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @EngagementScore VARCHAR(20);
    SET @EngagementScore =
        CASE
            WHEN @WebsiteVisits >= 30
                 AND @PagesPerVisit >= 5
                 AND @TimeOnSite >= 8
                THEN 'High Engagement'

            WHEN @WebsiteVisits >= 20
                 AND @PagesPerVisit >= 3
                 AND @TimeOnSite >= 5
                THEN 'Moderate Engagement'

            ELSE 'Low Engagement'
        END;
    RETURN @EngagementScore;
END;
SELECT TOP 10 CustomerID, WebsiteVisits, PagesPerVisit, TimeOnSite, dbo.fn_EngagementScore( WebsiteVisits, PagesPerVisit, TimeOnSite ) AS EngagementScore
FROM dbo.CustomerMarketing;
---
--Loyalty Category
CREATE FUNCTION dbo.fn_LoyaltyCategory
( @LoyaltyPoints INT)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Category VARCHAR(20);
    SET @Category =
        CASE
            WHEN @LoyaltyPoints < 1000 THEN 'Low Loyalty'
            WHEN @LoyaltyPoints < 2500 THEN 'Moderate Loyalty'
            WHEN @LoyaltyPoints < 4000 THEN 'High Loyalty'
            ELSE 'Very High Loyalty'
        END;
    RETURN @Category;
END;
SELECT TOP 10 CustomerID, LoyaltyPoints, dbo.fn_LoyaltyCategory(LoyaltyPoints) AS LoyaltyCategory FROM dbo.CustomerMarketing;
---
--Income Category
CREATE FUNCTION dbo.fn_IncomeCategory
( @Income DECIMAL(12,2))
RETURNS VARCHAR(30)
AS
BEGIN
    DECLARE @Category VARCHAR(30);
    SET @Category =
        CASE
            WHEN @Income < 40000 THEN 'Low Income'
            WHEN @Income < 70000 THEN 'Middle Income'
            WHEN @Income < 100000 THEN 'Upper-Middle Income'
            ELSE 'High Income'
        END;
    RETURN @Category;
END;
SELECT TOP 10 CustomerID, Income, dbo.fn_IncomeCategory(Income) AS IncomeCategory FROM dbo.CustomerMarketing;
---
--Customer Segment
CREATE FUNCTION dbo.fn_CustomerSegment
( @PreviousPurchases INT)
RETURNS VARCHAR(30)
AS
BEGIN
    DECLARE @Segment VARCHAR(30);
    SET @Segment =
        CASE
            WHEN @PreviousPurchases = 0
                THEN 'New Customer'
            WHEN @PreviousPurchases <= 2
                THEN 'Occasional Customer'
            WHEN @PreviousPurchases <= 5
                THEN 'Regular Customer'
            ELSE 'Frequent Customer'
        END;
    RETURN @Segment;
END;
SELECT TOP 10 CustomerID, PreviousPurchases, dbo.fn_CustomerSegment(PreviousPurchases) AS CustomerSegment FROM dbo.CustomerMarketing;

