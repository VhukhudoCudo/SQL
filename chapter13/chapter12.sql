--Listing 13.1  Crime reports text
 4/16/17-4/17/17
  2100-0900 hrs.
  46000 Block Ashmere Sq.
  Sterling
  Larceny: The victim reported that a
 bicycle was stolen from their opened
 garage door during the overnight hours.
  C0170006614
 04/10/17
 1605 hrs.
 21800 block Newlin Mill Rd.
 Middleburg
 Larceny: A license plate was reported
 stolen from a vehicle.
 SO170006250

 --Listing 13-2: Creating and loading the crime_reports table
CREATE TABLE crime_reports (
    crime_id bigserial PRIMARY KEY,
    date_1 timestamp with time zone,
    date_2 timestamp with time zone,
    street varchar(250),
    city varchar(100),
    crime_type varchar(100),
    description text,
    case_number varchar(50),
    original_text text NOT NULL
 );
 COPY crime_reports (original_text)
 FROM 'C:\YourDirectory\crime_reports.csv'
 WITH (FORMAT CSV, HEADER OFF, QUOTE '"');

-- Listing 13-3: Using regexp_match() to find the first date
 SELECT crime_id,
       regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')
 FROM crime_reports;

 --Listing 13-4: Using the regexp_matches() function with the 'g' flag
SELECT crime_id,
       regexp_matches(original_text, '\d{1,2}\/\d{1,2}\/\d{2}', 'g')
 FROM crime_reports;

-- Listing 13-5: Using regexp_match() to find the second date
SELECT crime_id,
       regexp_match(original_text, '-\d{1,2}\/\d{1,2}\/\d{2}')
 FROM crime_reports;

-- Listing 13-6: Using a capture group to return only the date
 SELECT crime_id,
       regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})')
 FROM crime_reports;

-- Listing 13-7: Matching case number, date, crime type, and city
SELECT 
    regexp_match(original_text, '(?:C0|SO)[0-9]+') AS case_number,
    regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') AS date_1,
    regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') AS crime_type,
    regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n')
        AS city
 FROM crime_reports;

-- Listing 13-8: Retrieving a value from within an array
 SELECT 
    crime_id,
  (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1]
        AS case_number
 FROM crime_reports;

-- Listing 13-9: Updating the crime_reports date_1 column
UPDATE crime_reports
  SET date_1 =
 (
  (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1] 
 || ' ' ||
  (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1] 
 ||' US/Eastern'
  )::timestamptz;
 SELECT crime_id,
       date_1,
       original_text
 FROM crime_reports;

--Listing 13.10 Updating all crime_reports columns

PDATE crime_reports
 SET date_1 = 
    (
      (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
          || ' ' ||
      (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1] 
          ||' US/Eastern'
    )::timestamptz,
    date_2 = 
    CASE 
        WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NULL)
                AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
        THEN 
          ((regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
              || ' ' ||
          (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
              ||' US/Eastern'
          )::timestamptz 
     WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NOT NULL)
                AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
        THEN 
          ((regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})'))[1]
              || ' ' ||
          (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
              ||' US/Eastern'
          )::timestamptz 
        ELSE NULLx 
    END,
    street = (regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))'))[1],
    city = (regexp_match(original_text,
                           '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n'))[1],
    crime_type = (regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):'))[1],
    description = (regexp_match(original_text, ':\s(.+)(?:C0|SO)'))[1],
    case_number = (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1];

-- Listing 13-11: Viewing selected crime data

	 SELECT date_1,
       street,
       city,
       crime_type
 FROM crime_reports;

--Listing 13-12: Using regular expressions in a WHERE clause
SELECT geo_name
 FROM us_counties_2010
  WHERE geo_name ~* '(.+lade.+|.+lare.+)'
 ORDER BY geo_name;
 SELECT geo_name
 FROM us_counties_2010
  WHERE geo_name ~* '.+ash.+' AND geo_name !~ 'Wash.+'
 ORDER BY geo_name;

-- Listing 13-13: Regular expression functions to replace and split text
 SELECT regexp_replace('05/12/2018', '\d{4}', '2017');
  SELECT regexp_split_to_table('Four,score,and,seven,years,ago', ',');
  SELECT regexp_split_to_array('Phil Mike Tony Steve', ',');

-- Listing 13-14: Finding an array length
SELECT array_length(regexp_split_to_array('Phil Mike Tony Steve', ' '), 1);

-- Listing 13-15: Converting text to tsvector data
 SELECT to_tsvector('I am walking across the sitting room to sit with you.');

-- Listing 13-16: Converting search terms to tsquery data
SELECT to_tsquery('walking & sitting');

-- Listing 13-17: Querying a tsvector type with a tsquery
 SELECT to_tsvector('I am walking across the sitting room') @@ to_tsquery('walking & sitting');
 SELECT to_tsvector('I am walking across the sitting room') @@ to_tsquery('walking & running');

-- Listing 13-18: Creating and filling the president_speeches table
 CREATE TABLE president_speeches (
    sotu_id serial PRIMARY KEY,
    president varchar(100) NOT NULL,
    title varchar(250) NOT NULL,
    speech_date date NOT NULL,
    speech_text text NOT NULL,
    search_speech_text tsvector
 );
 COPY president_speeches (president, title, speech_date, speech_text)
 FROM 'C:\YourDirectory\sotu-1946-1977.csv'
 WITH (FORMAT CSV, DELIMITER '|', HEADER OFF, QUOTE '@');

--Listing Converting speeches to tsvector in the search_speech_text column
 UPDATE president_speeches
  SET search_speech_text = to_tsvector('english', speech_text);

--Listing 13-20: Creating a GIN index for text search
 CREATE INDEX search_idx ON president_speeches USING gin(search_speech_text);

--Listing 13-21: Finding speeches containing the word Vietnam
SELECT president, speech_date
 FROM president_speeches
  WHERE search_speech_text @@ to_tsquery('Vietnam')
 ORDER BY speech_date; 

-- Listing 13-22: Displaying search results with ts_headline()
 SELECT president,
       speech_date,
  ts_headline(speech_text, to_tsquery('Vietnam'),
  'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
 FROM president_speeches
 WHERE search_speech_text @@ to_tsquery('Vietnam');

-- Listing 13-23: Finding speeches with the word transportation but not roads
 SELECT president, 
       speech_date,
  ts_headline(speech_text, to_tsquery('transportation & !roads'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
 FROM president_speeches
  WHERE search_speech_text @@ to_tsquery('transportation & !roads');

-- Listing 13-24: Finding speeches where defense follows military
SELECT president,
       speech_date,
     ts_headline(speech_text, to_tsquery('military <-> defense'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
 FROM president_speeches
 WHERE search_speech_text @@ to_tsquery('military <-> defense');

 --Listing 13-25: Scoring relevance with ts_rank()
 SELECT president,
       speech_date,
  ts_rank(search_speech_text,
               to_tsquery('war & security & threat & enemy')) AS score
FROM president_speeches
  WHERE search_speech_text @@ to_tsquery('war & security & threat & enemy')
 ORDER BY score DESC
 LIMIT 5

-- Listing 13-26: Normalizing ts_rank() by speech length
SELECT president,
       speech_date,
       ts_rank(search_speech_text,
               to_tsquery('war & security & threat & enemy'), 2)::numeric 
               AS score
 FROM president_speeches
 WHERE search_speech_text @@ to_tsquery('war & security & threat & enemy')
 ORDER BY score DESC
 LIMIT 5;











