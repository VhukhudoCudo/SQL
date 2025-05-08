--listing 1.2 (creating table)
 CREATE TABLE teachers (
       id bigserial,
       first_name varchar(25), --maximum characters--
       last_name varchar(50),
       school varchar(50)  
  );
 -- 
  SELECT first_name, last_name
FROM teachers
ORDER BY first_name ASC;