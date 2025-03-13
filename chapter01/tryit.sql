--listing 1--
CREATE TABLE animals (
      animal_name varchar(25), --maximum characters--
       animal_color varchar(50),
       animal_type varchar(50)
  );
-- Used name,color and type to easily class them accoerding to their type

  --listing 2(inserting data into table)
  INSERT INTO animals (animal_name, animal_color, animal_type)
  VALUES ('Lions', 'Brown', 'Carnivores),
         ('Giraffes', 'Yellow&Black', 'Herbivous'), 
         ('Bears', 'Black', 'omnivores');

  --listing 2(inserting data into table , missing sintax)
  INSERT INTO animals (animal_name, animal_color, animal_type)
  VALUES ('Lions', 'Brown', 'Carnivores),
         ('Giraffes', 'Yellow&Black', 'Herbivous'), 
         ('Bears', 'Black', 'omnivores);
