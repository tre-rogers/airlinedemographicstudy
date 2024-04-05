USE airline_sent;

## Table for 'Age Distribution by Continent of Departure' in Tableau

-- Average age of passengers by gender per continent
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT
	d.continent_name,
	pd.gender,
    AVG(pd.age) AS avg_age
FROM
	pass_demo pd
		JOIN
	departures d ON pd.pass_id = d.pass_id
GROUP BY pd.gender, d.continent_name
ORDER BY continent_name;

## Table for 'Global Flight Status Distribution' in Tableau

SELECT
	COUNT(pass_id) AS no_flights,
    flight_status
FROM
	pilot_name_status
GROUP BY flight_status;

## Table for 'Distribution of Ages - Departing Passengers' in Tableau

-- Distribution of departure continents by age groups
-- Age groups <18, 18-24, 25-34, 45-54, 55-64, >65

SELECT
        SUM(IF(pd.age < 18,1,0)) AS 'Under 20',
        SUM(IF(pd.age BETWEEN 18 AND 24,1,0)) AS '18 - 29',
        SUM(IF(pd.age BETWEEN 25 AND 34,1,0)) AS '25 - 34',
        SUM(IF(pd.age BETWEEN 35 AND 44,1,0)) AS '35 - 44',
        SUM(IF(pd.age BETWEEN 45 AND 54,1,0)) AS '45 - 54',
        SUM(IF(pd.age BETWEEN 55 AND 64,1,0)) AS '55-64',
        SUM(IF(pd.age > 64,1,0)) AS '64+',
        COUNT(pd.pass_id) AS total_departures,
        d.continent_name
FROM
	pass_demo pd
		JOIN
	departures d ON pd.pass_id = d.pass_id
    GROUP BY d.continent_name
    ORDER BY d.continent_name;
    
-- Decided against this method, switched to using Tableau to designate
-- age ranges for dynamic pie chart, will instead use below table
-- Above still good for general ad hoc querying

SELECT 
	pd.age,
    d.continent_name
FROM
	pass_demo pd
		JOIN
	departures d ON pd.pass_id = d.pass_id;
    
## Table for 'Flight Status Percentages' in Tableau

-- On-Time percentage by pilot*

SELECT pilot, COUNT(pilot)
FROM pilot_name_status
GROUP BY pilot
HAVING COUNT(pilot) > 1;

-- *Although this would have been a nice stat to have, only 14 dups in above query
-- In essence, not worth analysis on 98000+ records by pilot
-- Instead, will simply make table for pie of overall on time percentage by continent departure

SELECT
	SUM(CASE WHEN pns.flight_status LIKE '%Delayed%' THEN 1 ELSE 0 END) AS no_delayed,
    SUM(CASE WHEN pns.flight_status LIKE '%On Time%' THEN 1 ELSE 0 END) AS no_on_time,
    SUM(CASE WHEN pns.flight_status LIKE '%Cancelled%' THEN 1 ELSE 0 END) AS no_cancelled,
    COUNT(pns.pass_id) AS total_flights,
    d.continent_name
FROM
	pilot_name_status pns
		JOIN
	departures d ON pns.pass_id = d.pass_id
GROUP BY d.continent_name
ORDER BY d.continent_name
;

## Table for map in Tableau

-- Number of departures out of each country
SELECT
	country_name,
    COUNT(pass_id) AS total_flights
FROM
	departures
GROUP BY country_name
ORDER BY COUNT(pass_id) DESC;