--( Ordering & failure reasons fro QC)

-- product.workorder: no of product, no of scrap, date
--product.costhistory: productid, standard cost (scrap cost = standard cost * scrap qty)
-- product.scrapreason: scrap reason
-- production.product: product names

SELECT wo.ProductID, ppc.Name'CategoryName', pps.Name 'SubCategoryName', pp.Name'ProductName', wo.ModifiedDate, wo.OrderQty, pch.StandardCost,wo.OrderQty * pch.StandardCost 'ProductionCostQty', 
		wo.StockedQty, wo.ScrappedQty, psc.Name'ScrapReason', wo.ScrappedQty * pch.StandardCost 'ScrapCostQty'
FROM Production.WorkOrder wo
JOIN Production.ProductCostHistory pch ON wo.ProductID = pch.ProductID
LEFT JOIN Production.ScrapReason psc ON wo.ScrapReasonID = psc.ScrapReasonID
LEFT JOIN Production.Product pp ON pp.ProductID = wo.ProductID
LEFT JOIN Production.ProductSubcategory pps ON pps.ProductSubcategoryID = pp.ProductSubcategoryID
LEFT JOIN Production.ProductCategory ppc ON ppc.ProductCategoryID = pps.ProductCategoryID