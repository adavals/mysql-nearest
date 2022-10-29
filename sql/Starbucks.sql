
-- STEP 1. Create localStarbucks database and directory table

CREATE DATABASE localStarbucks;

USE localStarbucks;

CREATE TABLE directory (
   brand VARCHAR(24),
   storeNumber VARCHAR(12),
   storeName VARCHAR(60),
   ownershipType VARCHAR(20),
   streetAddress VARCHAR(180),
   city VARCHAR(50),
   stateProvince VARCHAR(4),
   country VARCHAR(4),
   postcode VARCHAR(10),
   phoneNumber VARCHAR(18),
   timezone VARCHAR(30),
   longitude DECIMAL(5,2),
   latitude DECIMAL(5,2)
);
 
-- STEP 2. Import csv file into directory table 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Starbucks_directory.csv' 
INTO TABLE directory 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(brand, storeNumber, storeName, ownershipType, streetAddress, city, stateProvince, country, postcode,
phoneNumber, timezone, @longitude, @latitude)
SET longitude = nullif(@longitude,''), latitude = nullif(@latitude,'');
-- there a few records with empty longitude, latitude 

-- STEP 3. Do some cleaning deleting some rows with null values in longitude or latitude
SELECT * FROM directory WHERE longitude IS NULL OR latitude IS NULL;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM directory WHERE longitude IS NULL OR latitude IS NULL;

-- STEP 4. Get the nearest store to my location using a distance formula referenced on Stackoverflow
-- https://stackoverflow.com/questions/2234204/find-nearest-latitude-longitude-with-an-sql-query
-- Most voted answer, recommended for 'short distances' as this case
-- WARNING: the distance formula would be different depending on your case/needs

SELECT storeName, streetAddress, city, latitude, longitude, 
    SQRT( POW(69.1 * (latitude - 19.4891442), 2) +
          POW(69.1 * (-99.1323771 - longitude) * COS(latitude / 57.3), 2)) AS distance
FROM directory ORDER BY distance LIMIT 1;

-- NOTES:  * Conversion factor latitude to degrees is in miles (69.1) so the calculated distance field is in miles             
--         * To limit the results to a maximum distance in miles, use, for example: HAVING distance < 2
--         * Replace 19.48... with your latitude and -99.13... with your longitude





