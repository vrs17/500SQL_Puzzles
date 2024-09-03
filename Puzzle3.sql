
CREATE TABLE #EmpBirth
(
 EmpId INT  IDENTITY(1,1) 
,EmpName VARCHAR(50) 
,BirthDate DATETIME 
)
 
--Insert Data
INSERT INTO #EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983'
 
--Verify data
SELECT EmpId,EmpName,BirthDate FROM #EmpBirth



-- My Solution 1
select
	EmpName
	, BirthDate
from #EmpBirth
where MONTH(BirthDate) = 5 and DAY(BirthDate) between 5 and 17 



--
 
/************   SOLUTION 1    | Pawan Kumar Khowal     ****************/
 
;WITH CTE AS
(  
        SELECT EmpId , EmpName,BirthDate , MONTH(BirthDate) AS Mont, DAY(BirthDate) AS days
        FROM #EmpBirth
)
SELECT EmpId , EmpName,BirthDate FROM CTE WHERE Mont = 5 AND days >= 7 AND days <= 15
 
 
/************   SOLUTION 2    | Pawan Kumar Khowal     ****************/
 
;WITH CTE  
AS ( 
    SELECT EmpId , EmpName,BirthDate,
    CASE
      WHEN  MONTH(BirthDate) < 10 THEN  '0' + CAST(MONTH(BirthDate) AS VARCHAR(1))
            ELSE
                CAST(MONTH(BirthDate) AS VARCHAR(2))
      END
    + CASE WHEN DAY(BirthDate) < 10 THEN '0' + CAST(DAY(BirthDate) AS VARCHAR(1))
            ELSE
                  CAST(DAY(BirthDate) AS VARCHAR(2))
            END FormattedDOB
FROM #EmpBirth
)
SELECT EmpId , EmpName,BirthDate FROM CTE WHERE FormattedDOB BETWEEN '0507' AND '0515'
 
 
 
--
