create database sql_500Puzzles


CREATE TABLE #lag
(
BusinessEntityID INT
,SalesYear   INT
,CurrentQuota  DECIMAL(20,4)
)
GO
 
 truncate table #lag

INSERT INTO #lag
SELECT 275 , 2005 , '367000.00'
UNION ALL
SELECT 275 , 2005 , '556000.00'
UNION ALL
SELECT 275 , 2006 , '502000.00'
UNION ALL
SELECT 275 , 2006 , '550000.00'
UNION ALL
SELECT 275 , 2006 , '1429000.00'
UNION ALL
SELECT 275 , 2006 ,  '1324000.00'

-- My Solution
select *, LAG(CurrentQuota, 1, 0) over(order by (select null)) from #lag


--Solutions
;WITH CTE AS
( 
    SELECT  BusinessEntityID ,SalesYear ,CurrentQuota
    , ROW_NUMBER() OVER (ORDER BY BusinessEntityID ) AS ID
    FROM #lag
)
SELECT c.BusinessEntityID ,c.SalesYear , c.CurrentQuota
    , ISNULL((SELECT TOP 1 d.CurrentQuota FROM CTE d WHERE c.ID > d.ID ORDER BY ID DESC ),0) lagCurrentData
FROM CTE c
 
 
/************   SOLUTION 2    | Pawan Kumar Khowal     ****************/
 
;WITH CTE AS
(
 SELECT BusinessEntityID ,SalesYear ,CurrentQuota ,ROW_NUMBER() OVER (ORDER BY BusinessEntityID )AS ID
 FROM #lag
)
SELECT c.Id ,c.BusinessEntityID ,c.SalesYear , c.CurrentQuota,ISNULL(d.CurrentQuota,0) lagCurrentData
FROM CTE c LEFT OUTER JOIN CTE d ON c.ID =(d.ID+1)