use sql_500Puzzles

--drop table #lag;
CREATE TABLE #lag
(
 BusinessEntityID INT
,SalesYear   INT
,CurrentQuota DECIMAL(20,4)
)
 
GO
 
--Insert Data
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
SELECT 275 , 2006 ,   '1324000.00'
 
--Check data
SELECT BusinessEntityID,SalesYear,CurrentQuota FROM #lag


------------------------------------------------------------
--My solution 1
SELECT 
	BusinessEntityID
	,SalesYear
	,CurrentQuota
	,lead(CurrentQuota) over(order by (select null)) as NextCurrentQuota
FROM 
	#lag


--My solution 2
;with cte as (
	SELECT 
		BusinessEntityID
		,SalesYear
		,CurrentQuota
		,ROW_NUMBER() over(order by (select null)) as id
	FROM 
		#lag
)
select
		a.BusinessEntityID
		,a.SalesYear
		,cast(a.CurrentQuota as decimal(10,2) )
		,cast(ISNULL(b.CurrentQuota, 0) as decimal(10,2) ) as NextCurrentQuota
from cte a
	left join cte b 
		on a.id = b.id-1


-- My Solution 3
;with cte as (
	SELECT 
		BusinessEntityID
		,SalesYear
		,CurrentQuota
		,ROW_NUMBER() over(order by (select null)) as id
	FROM 
		#lag
)
SELECT 
	BusinessEntityID
	,SalesYear
	,CurrentQuota
	,CAST(isnull((select CurrentQuota 
		from cte b 
		where a.id = b.id-1), 0) as decimal(10,2)) as NextCurrentQuota
FROM 
	cte a
	

	

--
 

---------------------------------------
--Sol 1 | Pawan Kumar Khowal
---------------------------------------
 
 
;WITH CTE AS
(
    SELECT BusinessEntityID,SalesYear,CurrentQuota,ROW_NUMBER() OVER (ORDER BY %%Physloc%%) rnk  
    FROM #lag
)
SELECT    BusinessEntityID,SalesYear,CurrentQuota
        , ISNULL(( SELECT TOP 1 CurrentQuota FROM CTE c2 WHERE c1.rnk < c2.rnk ),0) NextCurrentData
FROM CTE c1
 
 
---------------------------------------
--Sol 2 | Pawan Kumar Khowal
---------------------------------------
 
 
;WITH CTE AS
(
    SELECT 
		BusinessEntityID
		,SalesYear
		,CurrentQuota
		,ROW_NUMBER() OVER (ORDER BY %%Physloc%%) rnk  
    FROM #lag
)
SELECT    
	BusinessEntityID
	,SalesYear
	,CurrentQuota
    ,ISNULL(LEAD(CurrentQuota) OVER (ORDER BY rnk),0) NextCurrentData     
FROM CTE c1
 
 
--