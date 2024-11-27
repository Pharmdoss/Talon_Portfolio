SELECT * FROM world_life_expectancy.world_life_expectancy;

SELECT country, YEAR, CONCAT(country,Year), COUNT(CONCAT(country,Year))
FROM world_life_expectancy
GROUP BY Country, YEAR, CONCAT(country, Year)
HAVING COUNT(CONCAT(country,Year)) > 1
;


SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(country,Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(country,Year) ORDER BY CONCAT(country,Year)) AS Row_num
	FROM world_life_expectancy
    ) AS row_table
WHERE row_num > 1
;

DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT Row_ID, 
	CONCAT(country,Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(country,Year) ORDER BY CONCAT(country,Year)) AS Row_num
	FROM world_life_expectancy
    ) AS row_table
WHERE row_num > 1
)
;

SELECT * 
FROM world_life_expectancy.world_life_expectancy
WHERE status = '';

SELECT DISTINCT(Status)
FROM world_life_expectancy.world_life_expectancy
WHERE status <> '';

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;
    
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.status = ''
AND t2.Status <> ''
AND t2.status = 'Developing'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.status = ''
AND t2.Status <> ''
AND t2.status = 'Developed'
;

SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year +1
WHERE t1.`Life expectancy` = ''
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year +1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = ''
;

-- EDA

SELECT *
FROM world_life_expectancy
;

SELECT Country, 
MIN(`Life expectancy`),
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_years ASC
;

SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

SELECT *
FROM world_life_expectancy
;

SELECT Country, ROUND(AVG(`Life expectancy`),2) AS LIFE_EXP, ROUND(AVG(GDP),2) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC
;

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_expectancy
FROM world_life_expectancy
;

-- EDA

Select *
FROM world_life_expectancy
;

Select Country,
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS life_Increase_Over_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY life_Increase_Over_15_Years ASC
;


SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0
AND GDP > 0
ORDER BY GDP ASC
;

SELECT 
SUM(CASE
	WHEN GDP >= 1500 THEN 1 
    ELSE 0
END) HIGH_GDP_COUNT,
AVG (CASE
	WHEN GDP >= 1500 THEN `Life expectancy`
    ELSE NULL
END) High_GDP_Life_Expectancy,
SUM(CASE
	WHEN GDP <= 1500 THEN 1 
    ELSE 0
END) Low_GDP_COUNT,
AVG (CASE
	WHEN GDP <= 1500 THEN `Life expectancy`
    ELSE NULL
END) Low_GDP_Life_Expectancy
FROM world_life_expectancy
;

Select Status, ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

Select Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0
AND BMI > 0
ORDER BY BMI DESC
;

SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER( PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
;