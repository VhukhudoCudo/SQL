--Listing 2.1 (select all rows)
 SELECT * FROM teachers;

--Listing 2.2 (filtering columns)
  SELECT last_name, first_name, salary FROM teachers;

--Listing 2.3 (Querying distinct values in the school column)
 SELECT DISTINCT school 
FROM teachers;

--Listing 2.4(Filtering school values and salary columns)
SELECT DISTINCT school, salary 
FROM teachers;

--Listing 2.5(Sorting a column with ORDER by high to low)
SELECT first_name, last_name, salary 
FROM teachers
 ORDER BY salary DESC;

 --Listing 2.6(Sorting school column in ascending and hire date in descending)
 SELECT last_name, school, hire_date 
FROM teachers
  ORDER BY school ASC, hire_date DESC;

  --List 2.7( Filtering row using where)
   SELECT last_name, school, hire_date
 FROM teachers
 WHERE school = 'Myers Middle School';

  SELECT last_name, school, hire_date
 FROM teachers
 WHERE school = 'Myers Middle School';

  SELECT school
 FROM teachers
 WHERE school != 'F.D. Roosevelt HS';

  SELECT first_name, last_name, hire_date
 FROM teachers
 WHERE hire_date < '2000-01-01';

 SELECT first_name, last_name, salary
 FROM teachers
 WHERE salary >= 43500;

  SELECT first_name, last_name, school, salary
 FROM teachers
 WHERE salary BETWEEN 40000 AND 65000;

 SELECT first_name
 FROM teachers
 WHERE first_name LIKE 'sam%'

 SELECT first_name
 FROM teachers
  WHERE first_name ILIKE 'sam%';

--Listing 2.9(Combining operators using AND and OR)
FROM teachers
  WHERE school = 'Myers Middle School'
      AND salary < 40000;
 SELECT *
 FROM teachers
  WHERE last_name = 'Cole'
      OR last_name = 'Bush';
 SELECT *
 FROM teachers
  WHERE school = 'F.D. Roosevelt HS'
      AND (salary < 38000 OR salary > 40000);

      --Putting It all together
SELECT column_names
 FROM table_name
 WHERE criteria
 ORDER BY column_names

  SELECT first_name, last_name, school, hire_date, salary
 FROM teachers
 WHERE school LIKE '%Roos%'
 ORDER BY hire_date DESC; 



