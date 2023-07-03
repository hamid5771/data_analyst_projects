--1: Sales REGION (COUNTRY)

SELECT st.Name, st.[Group]'Continent', st.CountryRegionCode, SUM(st.SalesLastYear) 'TotalSales'

FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY st.Name,st.CountryRegionCode, st.[Group]

--------------------------------
--2: (products review) for text mining although it's nothing to analyze

SELECT pp.ProductID, pp.Name, pp.Color, pp.StandardCost, pp.ListPrice, pr.Rating, pr.Comments
FROM Production.Product pp
 JOIN Production.ProductReview pr ON pp.ProductID = pr.ProductID

 --2.1: (PRODUCT COST)

SELECT pp.ProductID, pp.Name, pp.Color, pp.StandardCost, pp.ListPrice, pch.StandardCost
FROM Production.Product pp
LEFT JOIN Production.ProductCostHistory pch ON pp.ProductID = pch.ProductID
ORDER BY pp.Name

--3: (THOSE Who seperated from company vs those who NOT)

SELECT * 
FROM HumanResources.Department hd
JOIN HumanResources.EmployeeDepartmentHistory hdh ON hd.DepartmentID = hdh.DepartmentID
WHERE EndDate is not NULL

-- 3.1
SELECT hd.DepartmentID, hd.Name, hdh.BusinessEntityID, hdh.StartDate, hdh.EndDate, he.NationalIDNumber, he.JobTitle, he.MaritalStatus, 
	ROW_NUMBER () OVER (PARTITION BY hd.name ORDER BY hd.DepartmentID) as 'Rank'
FROM HumanResources.Department hd
JOIN HumanResources.EmployeeDepartmentHistory hdh ON hd.DepartmentID = hdh.DepartmentID
JOIN HumanResources.Employee he ON he.BusinessEntityID = hdh.BusinessEntityID
WHERE hdh.EndDate is NULL
ORDER BY hd.Name DESC

--4: Sale performance

SELECT * FROM

(SELECT soh.SalesOrderID, soh.OnlineOrderFlag, soh.CustomerID, soh.SalesPersonID, soh.TerritoryID,
	SUM (soh.TotalDue) 'final payment',sp.CommissionPct 
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
GROUP BY soh.SalesOrderID, soh.OnlineOrderFlag, soh.CustomerID, soh.SalesPersonID, soh.TerritoryID,sp.CommissionPct) TST

WHERE TST.OnlineOrderFlag = 0

--4.1: (Sales performance by seller)

SELECT  BusinessEntityID, SalesQuota, QuotaDate,
	ROW_NUMBER() OVER(PARTITION BY BusinessEntityID ORDER BY SalesQuota desc) AS 'performance report '
  FROM Sales.SalesPersonQuotaHistory

--4.2: (Sales teritory comparison) can show online sales 1 VS store or offline sales 0 !

SELECT soh.TerritoryID, st.CountryRegionCode, soh.SalesOrderID, soh.OnlineOrderFlag, soh.CustomerID, soh.SalesPersonID, st.SalesLastYear,
	ROW_NUMBER() OVER(PARTITION BY st.CountryRegionCode ORDER BY st.SalesLastYear desc ) AS 'Rank!' --st.Group 
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
 WHERE soh.OnlineOrderFlag = 0