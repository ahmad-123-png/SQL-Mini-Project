-- Creating a new schema for storing unicorn company data
CREATE SCHEMA unicorn_companies;

-- Switching to the unicorn_companies schema
USE unicorn_companies;


-- Dropping the unicorns table if it exists, to avoid duplication issues
DROP TABLE unicorn_companies;


-- Creating the main table 'unicorns' to store details about each company
CREATE TABLE unicorns (
    -- Primary key with auto-increment to uniquely identify each company
    Company_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    -- Company_name stores the name of the company, with a maximum length of 255 characters
    Company_name VARCHAR(255),
    -- Country specifies the country where the company is based, limited to 100 characters
    Country VARCHAR(100),
    -- Sector represents the industry sector of the company, limited to 50 characters
    Sector VARCHAR(50),
    -- Valuation_in_Billions holds the company valuation in billions, allowing 2 decimal precision
    Valuation_in_Billions DECIMAL(10 , 2 ),
    -- Year_Founded stores the founding year of the company as an integer
    Year_Founded INT,
    -- Investors lists key investors in the company as a text field
    Investors TEXT
);

-- ALTER TABLE unicorns 
    -- Sector represents the industry sector of the company, limited to 50 characters
-- MODIFY COLUMN Sector VARCHAR(50);


-- show create table unicorns;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/unicorn_companies (1).csv"
-- C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\grocery_logbook.csv
INTO TABLE unicorns
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Company_name, Country, Sector, Valuation_in_Billions, Year_Founded, Investors);

SHOW VARIABLES LIKE "secure_file_priv";

-- Dropping the unicorns table if it exists, to avoid duplication issues
DROP TABLE unicorns;


-- Running a query to retrieve data based on specific conditions
SELECT * FROM unicorns;

-- Question 1 - Top 5 Countries by Number of Unicorn Companies


-- Running a query to retrieve data based on specific conditions
SELECT country, COUNT(company_name) AS number_of_unicorns
FROM unicorns
  -- Grouping results to aggregate data by unique values in specified columns
GROUP BY country
  -- Sorting the query result based on specified columns
ORDER BY number_of_unicorns DESC;

-- Question 2 - Top 3 Sectors by Average Valuation


-- Running a query to retrieve data based on specific conditions
SELECT sector, ROUND(AVG(Valuation_in_Billions),2) AS average_valuation
FROM unicorns
  -- Grouping results to aggregate data by unique values in specified columns
GROUP BY sector
  -- Sorting the query result based on specified columns
ORDER BY average_valuation DESC;

-- Question 3 - Find the number of unicorn companies founded after 2010


-- Running a query to retrieve data based on specific conditions
SELECT *
FROM unicorns
WHERE year_founded>2010;

-- Question 4- Total Valuation of Unicorns in the FinTech Sector


-- Running a query to retrieve data based on specific conditions
SELECT sector, SUM(valuation_in_billions)
FROM unicorns
  -- Grouping results to aggregate data by unique values in specified columns
GROUP BY sector
HAVING sector = "FinTech";

-- Question 5 -  Find the most common investors


-- Running a query to retrieve data based on specific conditions
SELECT investors, COUNT(investors)
FROM unicorns
  -- Grouping results to aggregate data by unique values in specified columns
GROUP BY investors;


-- Running a query to retrieve data based on specific conditions
SELECT SUBSTRING_INDEX(investors,",",1)
FROM unicorns;


-- Modifying table structure if adjustments to columns are necessary
ALTER TABLE unicorns
ADD COLUMN investors_1 TEXT DEFAULT NULL AFTER investors;


-- Modifying table structure if adjustments to columns are necessary
ALTER TABLE unicorns
ADD COLUMN investors_2 TEXT DEFAULT NULL AFTER investors_1;


-- Modifying table structure if adjustments to columns are necessary
ALTER TABLE unicorns
ADD COLUMN investors_3 TEXT DEFAULT NULL AFTER investors_2;


-- Modifying table structure if adjustments to columns are necessary
ALTER TABLE unicorns
ADD COLUMN investors_3_corrected TEXT DEFAULT NULL AFTER investors_3;


-- Modifying table structure if adjustments to columns are necessary
ALTER TABLE unicorns
DROP COLUMN investors_1;


-- Modifying table structure if adjustments to columns are necessary
ALTER TABLE unicorns
DROP COLUMN investors_2;


-- Modifying table structure if adjustments to columns are necessary
ALTER TABLE unicorns
DROP COLUMN investors_3;


-- Modifying table structure if adjustments to columns are necessary
ALTER TABLE unicorns
DROP COLUMN investors_3_corrected;


-- Running a query to retrieve data based on specific conditions
SELECT * FROM unicorns;

SET sql_safe_updates= 0;


-- Updating specific rows within the table based on conditions
UPDATE unicorns
SET investors_1 = SUBSTRING_INDEX(investors,",",1);


-- Updating specific rows within the table based on conditions
UPDATE unicorns
SET investors_2 = SUBSTRING_INDEX(SUBSTRING_INDEX(investors,",",2),",",-1);


-- Updating specific rows within the table based on conditions
UPDATE unicorns
SET investors_3 = SUBSTRING_INDEX(SUBSTRING_INDEX(investors,",",3),",",-1);


-- Running a query to retrieve data based on specific conditions
SELECT * FROM unicorns;


-- Updating specific rows within the table based on conditions
UPDATE unicorns
SET investors_3_corrected = IF
								(investors_3= investors_2, NULL, investors_3);
                                
-- We can also delete investors_3 column now that we have the corrected column. However, I am not deleting it so that all analysis can be viewed.


-- Running a query to retrieve data based on specific conditions
SELECT investors,COUNT(investors_1), COUNT(investors_2), COUNT(investors_3_corrected)
FROM unicorns
  -- Grouping results to aggregate data by unique values in specified columns
GROUP BY investors;


-- Running a query to retrieve data based on specific conditions
SELECT investors_1, COUNT(investors_1) AS first_investor
FROM unicorns
  -- Grouping results to aggregate data by unique values in specified columns
GROUP BY investors_1;


-- Running a query to retrieve data based on specific conditions
SELECT investors_2 ,COUNT(investors_2) AS second_investor
FROM unicorns
  -- Grouping results to aggregate data by unique values in specified columns
GROUP BY investors_2;


-- Running a query to retrieve data based on specific conditions
SELECT investors_3_corrected, COUNT(investors_3_corrected) AS third_investor
FROM unicorns
  -- Grouping results to aggregate data by unique values in specified columns
GROUP BY investors_3_corrected; -- This gave seperate counts for the 3 columns. We can pin them and then add up their counts. 

-- But this is a manual procedure and may not work in larger more practical datasets. Hence, the code below is with subqueries and dervied tables.

-- More info on derived tables:

/*

A derived table is essentially a subquery used in the FROM clause of a query, and it must have an alias. 

It’s like treating the result of a subquery as if it were a table, and it only exists for the duration of that query. 
Derived tables are often used when you need to reference the result of a subquery as a "temporary table."

Example of a Derived Table:


-- Running a query to retrieve data based on specific conditions
SELECT t.investor, COUNT(*) AS total_count
FROM (

-- Running a query to retrieve data based on specific conditions
    SELECT investors_1 AS investor FROM unicorns
    UNION ALL

-- Running a query to retrieve data based on specific conditions
    SELECT investors_2 AS investor FROM unicorns
    UNION ALL

-- Running a query to retrieve data based on specific conditions
    SELECT investors_3 AS investor FROM unicorns
) AS t
  -- Grouping results to aggregate data by unique values in specified columns
GROUP BY t.investor
  -- Sorting the query result based on specified columns
ORDER BY total_count DESC;
Alias (t): The derived table (the subquery inside the FROM clause) is given an alias (t) so that it can be referenced later in the query, for example, in GROUP BY or SELECT.)

*/

-- Running a query to retrieve data based on specific conditions
SELECT 
    investor_name, COUNT(*) AS Total_count
FROM
    (SELECT 
        investors_1 AS Investor_name
    FROM
        unicorns UNION ALL SELECT 
        investors_2 AS Investor_name
    FROM
        unicorns UNION ALL SELECT 
        investors_3_corrected AS Investor_name
    FROM
        unicorns) AS Combined_investors
  -- Grouping results to aggregate data by unique values in specified columns
GROUP BY Investor_name
  -- Sorting the query result based on specified columns
ORDER BY Total_count DESC;

select * from unicorns;

-- Identifying trends in valuations and sectors of unicorn companies

-- trends in term of valuation and sectors

select sector, count(company_name) as number_of_companies,sum(valuation_in_billions) as value
from unicorns
group by sector
order by value desc;

-- trends in terms of countries

select country, count(company_name) as number_of_companies,sum(valuation_in_billions) as value, GROUP_CONCAT(DISTINCT sector ORDER BY sector ASC) AS sectors
from unicorns
group by country
order by value desc;

SELECT 
    investor_name,
    COUNT(*) AS Total_count,
    GROUP_CONCAT(DISTINCT company_name
        ORDER BY company_name ASC) AS companies_owned
FROM
    (SELECT 
        investors_1 AS Investor_name, Company_name
    FROM
        unicorns UNION ALL SELECT 
        investors_2 AS Investor_name, company_name
    FROM
        unicorns UNION ALL SELECT 
        investors_3_corrected AS Investor_name, company_name
    FROM
        unicorns) AS investors_combined
GROUP BY Investor_name
HAVING investor_name IS NOT NULL
ORDER BY Total_count DESC , investor_name;

















                                





