--listing 1.1 (creating database)
CREATE DATABASE analysis;

--listing 1.2 (creating table)
 CREATE TABLE teachers (
       id bigserial,
       first_name varchar(25), --maximum characters--
       last_name varchar(50),
       school varchar(50),
       hire_date date,
       salary numeric
  );

  --listing 1.3 (inserting data into table)
  INSERT INTO teachers (first_name, last_name, school, hire_date, salary)
  VALUES ('Janet', 'Smith', 'F.D. Roosevelt HS', '2011-10-30', 36200),
       ('Lee', 'Reynolds', 'F.D. Roosevelt HS', '1993-05-22', 65000),
       ('Samuel', 'Cole', 'Myers Middle School', '2005-08-01', 43500),
       ('Samantha', 'Bush', 'Myers Middle School', '2011-10-30', 36200),
       ('Betty', 'Diaz', 'Myers Middle School', '2005-08-30', 43500),
       ('Kathleen', 'Roush', 'F.D. Roosevelt HS', '2010-10-22', 38500);