
-- create
CREATE TABLE EMPLOYEE (
  empId INTEGER PRIMARY KEY,
  EmpName varchar(255) NOT NULL,
  Gender varchar(255) NOT NULL,
  Salary FLOAT NOT NULL,
  City varchar(255) NOT NULL
);

-- insert
INSERT INTO EMPLOYEE VALUES (1, 'Arjun', 'M', 75000, 'Pune');
INSERT INTO EMPLOYEE VALUES (2, 'Ekadanta', 'M', 125000, 'Bangalore');
INSERT INTO EMPLOYEE VALUES  (3, 'Lalita', 'F', 125000 , 'Mathura');
INSERT INTO EMPLOYEE VALUES (4, 'Madhav', 'M', 250000 , 'Delhi');
INSERT INTO EMPLOYEE VALUES (5, 'Paul', 'M', 120000 , 'Mathura');
INSERT INTO EMPLOYEE VALUES (6, 'Visakha', 'F', 100000 , 'Mathura');
CREATE TABLE EmployeeDetail (
  empId INTEGER PRIMARY KEY,
  Project varchar(255) NOT NULL,
  EmpPosition varchar(255) NOT NULL,
  DOJ date NOT NULL
);

-- insert
INSERT INTO EmployeeDetail VALUES (1, 'P1', 'Executive', '2019-01-26');
INSERT INTO EmployeeDetail VALUES (2, 'P2', 'Executive', '2020-05-04');
INSERT INTO EmployeeDetail VALUES (3, 'P1', 'Lead', '2021-10-21');
INSERT INTO EmployeeDetail VALUES (4, 'P3', 'Manager', '2019-11-29');
INSERT INTO EmployeeDetail VALUES (5, 'P2', 'Manager', '2020-08-01');
INSERT INTO EmployeeDetail VALUES (6, 'P3', 'lead', '2020-09-01');
-- fetch

-- SELECT * FROM EMPLOYEE
/* select Gender, COUNT(DISTINCT City), SUM(Salary)
FROM EMPLOYEE
GROUP BY Gender IN ('M' */


-- Q1(a)Find the list of employees whose salary ranges between 2L to 3L. 
/*SELECT EmpName
FROM EMPLOYEE
WHERE SALARY BETWEEN 200000 AND 300000*/

-- Q1(b) Write a query to retrieve the list of employees from the same city.
/*SELECT E1.EmpName, E1.City
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 
ON E1.CITY = E2.CITY AND E1.empId != E2.empId*/

-- Q2 (A) Query to find the cumulative sum of employee’s salary.
/*SELECT EmpID, Salary, SUM(Salary) OVER (ORDER BY EmpID) AS CumulativeSum
FROM Employee*/

-- Q2 (B) What is the male and female emp ratio: 
/* with ctef as 
(
SELECT *, 
CASE 
WHEN Gender IN ('M') THEN 0 
WHEN Gender IN ('F') THEN 1
END AS GENDER_CHECK, 
CASE 
WHEN Gender IN ('M','F') THEN 'FEMALE' 
END AS GEND
FROM EMPLOYEE
ORDER BY Gender
),  
ctef2 as 
(
SELECT 
GEND, SUM(GENDER_CHECK)/ COUNT(*) AS RATIO
FROM CTEF
group by GEND
), 
ctem as 
(
SELECT *, 
CASE 
WHEN Gender IN ('M') THEN 1 
WHEN Gender IN ('F') THEN 0
END AS GENDER_CHECK, 
CASE 
WHEN Gender IN ('M','F') THEN 'MALE' 
END AS GEND
FROM EMPLOYEE
ORDER BY Gender
),  
ctem2 as 
(
SELECT 
GEND, SUM(GENDER_CHECK)/ COUNT(*) AS RATIO
FROM ctem
group by GEND
)
select * from ctem2
union 
select * from ctef2*/ 

-- Q2 (C) Write a query to fetch 50% record from the employee table 
/*M1: 
Select * from EMPLOYEE
WHERE empId <= (SELECT COUNT(*)/2 FROM EMPLOYEE)*/ 

-- SELECT COUNT(*)/2 FROM EMPLOYEE
/* SELECT * 
FROM EMPLOYEE
LIMIT 3*/

-- Q3 Query to fetch the emp salary but replace the last two digit by xx. 

/* Select *, concat(left(salary, length(salary)-2), 'XX')    as replaced_salary 
from EMPLOYEE*/ 

-- Q4: Write a query to fetch even and odd rows from EMPLOYEE table 
/* SELECT * 
FROM EMPLOYEE
WHERE empId % 2 = 0
UNION 
SELECT * FROM EMPLOYEE
WHERE empId % 2 <>  0*/ 

-- Q5: WRITE A QUERY TO find all employees whose name: 
-- begin with A, Contain 'A' or 'Y' at second place, end with 'L' and 
-- contain 4 alphabet, begin with 'V' and ends with 'A' 

/* SELECT *
FROM EMPLOYEE
WHERE 
EmpName LIKE ('A%') OR 
EmpName LIKE ('_A%') OR 
EmpName LIKE ('_Y%') OR 
EmpName LIKE ( ('%L') AND length(EmpName) = 4)   OR 
EmpName LIKE ('V%A')*/ 

-- Q6: Find nth highest salary from EMPLOYEE table with and without using 
-- the top/LIMIT keyword 
-- WITH LIMIT 
/* SELECT * 
FROM EMPLOYEE
ORDER BY Salary DESC
LIMIT 1,1*/ -- SECOND HIGHEST

/* WITH RANKED_SALARY AS  -- WITHOUT LIMIT 
(
SELECT *, DENSE_RANK() OVER (ORDER BY Salary DESC) AS SALARY_RANK
FROM EMPLOYEE
) 
-- HIGHEST
SELECT * 
FROM RANKED_SALARY
WHERE SALARY_RANK =1*/

-- Q7(A): Write a query to find and remove duplicate records from table: 
-- FINDING DUPLICATE RECORDS  
/* SELECT empId, COUNT(*) AS DUPLICATE_COUNT
FROM employees
GROUP BY empId
HAVING COUNT(*) >  1*/ 
-- DELETING DUPLICATE RECORDS
/* DELETE FROM employees
WHERE empId IN 
(
SELECT empId FROM employees GROUP BY empId HAVING COUNT(*)> 1
)*/ 

-- Q7(B): Query to retrive the list of employees working in same project 

/* WITH CTE AS
(
SELECT A.empId, A.EmpName, B.project
FROM EMPLOYEE AS A
JOIN EmployeeDetail AS B ON A.empId = B.empId
ORDER BY B.project
)
SELECT project, 
GROUP_CONCAT(EmpName SEPARATOR ', ') AS SAME_PROJECT_EMP
FROM CTE 
WHERE project = 'P1'
UNION 
SELECT project, 
GROUP_CONCAT(EmpName SEPARATOR ', ') AS SAME_PROJECT_EMP
FROM CTE 
WHERE project = 'P2'
UNION 
SELECT project, 
GROUP_CONCAT(EmpName SEPARATOR ', ') AS SAME_PROJECT_EMP
FROM CTE 
WHERE project = 'P3'*/ 
/* WITH CTE AS 
(
SELECT A.empId, A.EmpName, B.project
FROM EMPLOYEE AS A
JOIN EmployeeDetail AS B ON A.empId = B.empId
ORDER BY B.project
) 
SELECT C1.EmpName, C2.EmpName, C1.project
FROM CTE AS C1
JOIN CTE AS C2 ON C1.project = C2.project 
AND C1.empId != C2.empId
AND C1.empId >= C2.empId*/ 

-- Q8 SHOW THE EMPLOYEE WITH HIGHEST SALARY OF EACH PROJECT 
/* WITH CTE AS 
(
SELECT 
A.empId, A.EmpName,  A.SALARY, 
B.Project, 
ROW_NUMBER() OVER (PARTITION BY B.Project ORDER BY A.SALARY DESC) AS SALARY_RANK 
FROM EMPLOYEE AS A 
JOIN EmployeeDetail AS B ON A.empId = B.empId
)
SELECT * FROM CTE 
WHERE SALARY_RANK = 1*/ 

-- Q9: Query to find the total count of employee joined each year 
/* With cte as 
(
select *, extract(year from DOJ) as year_joined 
from EmployeeDetail
)
SELECT year_joined, COUNT(*) AS NUMBER_EMP_JOINED 
FROM CTE 
GROUP BY year_joined*/ 

/* select  extract(year from DOJ) as year_joined, COUNT(*) AS NUMBER_EMP_JOINED 
from EmployeeDetail
GROUP BY year_joined*/ 

-- Q10: Create 3 groups based on salary column, salary < 1lac is low, 
-- salary between 1-2 lac is medium and > 2lac is high 

/* SELECT *, 
CASE 
WHEN Salary < 100000 THEN 'Low'
WHEN Salary BETWEEN 100000 and 200000 THEN 'Medium'
WHEN Salary > 200000 THEN 'High'
END AS SALARY_GROUP 
FROM EMPLOYEE
ORDER BY SALARY_GROUP*/ 








