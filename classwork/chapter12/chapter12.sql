--Listing 12.1
 UPDATE table
 SET column = (SELECT column
              FROM 
table_b
              WHERE 
table.column = table_b.column)
 WHERE EXISTS (SELECT column
              FROM 
table_b
              WHERE 
table.column = table_b.column);

SELECT geo_name,
       state_us_abbreviation,
       p0010001
 FROM us_counties_2010
  WHERE p0010001 >= (
    SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001)
    FROM us_counties_2010
    )
 ORDER BY p0010001 DESC;

--Listing 12.2 Using a subquery in a WHERE clause with DELETE
 CREATE TABLE us_counties_2010_top10 AS
 SELECT * FROM us_counties_2010;
 DELETE FROM us_counties_2010_top10
 WHERE p0010001 < (
    SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001)
    FROM us_counties_2010_top10
    ); 

--Listing 12.3 Subquery as a derived table in a FROM clause
SELECT round(calcs.average, 0) AS average,
       calcs.median,
       round(calcs.average - calcs.median, 0) AS median_average_diff
 FROM (
  SELECT avg(p0010001) AS average,
            percentile_cont(.5)
                WITHIN GROUP (ORDER BY p0010001)::numeric(10,1) AS median
     FROM us_counties_2010
     ) 
 AS calcs;

--Listing 12.4 Joining two derived tables

SELECT census.state_us_abbreviation AS st,
       census.st_population,
       plants.plant_count,
  round((plants.plant_count/census.st_population::numeric(10,1))*1000000, 1)
           AS plants_per_million
FROM
    (
  SELECT st,
               count(*) AS plant_count
        FROM meat_poultry_egg_inspect
        GROUP BY st
    )
    AS plants
 JOIN
    (
  SELECT state_us_abbreviation,
               sum(p0010001) AS st_population
        FROM us_counties_2010
        GROUP BY state_us_abbreviation
    ) 
    AS census
  ON plants.st = census.state_us_abbreviation
 ORDER BY plants_per_million DESC;

--Listing 12.6  Adding a subquery to a column list
 SELECT geo_name,
       state_us_abbreviation AS st,
       p0010001 AS total_pop,
       (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
        FROM us_counties_2010) AS us_median 
FROM us_counties_2010;

--Listing 12.7 Using a simple CTE to find large counties
 WITH
    large_counties (geo_name, st, p0010001)
 AS
    (
  SELECT geo_name, state_us_abbreviation, p0010001
        FROM us_counties_2010
        WHERE p0010001 >= 100000
    )
  SELECT st, count(*)
 FROM large_counties
 GROUP BY st
 ORDER BY count(*) DESC;

--Listing 12.8 : Using CTEs in a table join
WITH
  counties (st, population) AS
    (SELECT state_us_abbreviation, sum(population_count_100_percent)
     FROM us_counties_2010 
     GROUP BY state_us_abbreviation),
  plants (st, plants) AS
    (SELECT st, count(*) AS plants
     FROM meat_poultry_egg_inspect
     GROUP BY st)
     SELECT counties.st,
       population,
       plants,
       round((plants/population::numeric(10,1)) * 1000000, 1) AS per_million
  FROM counties JOIN plants
 ON counties.st = plants.st
 ORDER BY per_million DESC;

 --Listing 12.10
  CREATE TABLE ice_cream_survey (
    response_id integer PRIMARY KEY,
    office varchar(20),
    flavor varchar(20)
 );
 COPY ice_cream_survey
 FROM 'C:\YourDirectory\ice_cream_survey.csv'
 WITH (FORMAT CSV, HEADER);

--Listing 12.11  Generating the ice cream survey crosstab
SELECT *
  FROM crosstab('SELECT office,
 flavor,
 count(*)
               FROM ice_cream_survey
               GROUP BY office, flavor
               ORDER BY office',
  'SELECT flavor 
               FROM ice_cream_survey
               GROUP BY flavor
               ORDER BY flavor')
                AS (office varchar(20),
    chocolate bigint,
    strawberry bigint,
    vanilla bigint);

--Listing 12.12  Creating and filling a temperature_readings table
 CREATE TABLE temperature_readings (
    reading_id bigserial,
    station_name varchar(50),
    observation_date date,
    max_temp integer,
    min_temp integer
 );
 COPY temperature_readings 
     (station_name, observation_date, max_temp, min_temp)
 FROM 'C:\YourDirectory\temperature_readings.csv'
 WITH (FORMAT CSV, HEADER);

--Liting 12.13 : Generating the temperature readings crosstab
SELECT *
 FROM crosstab('SELECT 
 station_name,
  date_part(''month'', observation_date),
  percentile_cont(.5)  
                      WITHIN GROUP (ORDER BY max_temp) 
               FROM temperature_readings
               GROUP BY station_name,
                        date_part(''month'', observation_date)
               ORDER BY station_name',
              'SELECT month
               FROM 
generate_series(1,12) month')
 AS (station varchar(50),
    jan numeric(3,0),
    feb numeric(3,0),
    mar numeric(3,0),
    apr numeric(3,0),
    may numeric(3,0),
    jun numeric(3,0),
    jul numeric(3,0),
    aug numeric(3,0),
    sep numeric(3,0),
    oct numeric(3,0),
    nov numeric(3,0),
    dec numeric(3,0)
 );

--Listing 12.14  Reclassifying temperature data with CASE
SELECT max_temp,
       CASE WHEN max_temp >= 90 THEN 'Hot'
            WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
            WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
            WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
            WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
            ELSE 'Inhumane'
        END AS temperature_group
 FROM temperature_readings;

--Listing 12.15
 WITH temps_collapsed (station_name, max_temperature_group) AS
    (SELECT station_name,
           CASE WHEN max_temp >= 90 THEN 'Hot'
                WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
                WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
                WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
                WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
                ELSE 'Inhumane'
            END
     FROM temperature_readings)
 git SELECT station_name, max_temperature_group, count(*)
 FROM temps_collapsed
 GROUP BY station_name, max_temperature_group
 ORDER BY station_name, count(*) DESC;






