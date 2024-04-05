USE airline_sent;

-- Creation of main table
DROP TABLE IF EXISTS main;
CREATE TABLE main(
	passenger_id VARCHAR(15) BINARY NOT NULL,  -- Were duplicates in case-insensitive version
    first_name VARCHAR(20),
    last_name VARCHAR(30),
    gender ENUM('Male', 'Female'),
    age INTEGER,
    nationality VARCHAR(255),
    airport_name VARCHAR(255),
    airport_country_code VARCHAR(2),
    country_name VARCHAR(255),
    airport_continent VARCHAR(5),
    continent_name VARCHAR(30),
    departure_date DATE,
    arrival_airport VARCHAR(4),
    pilot VARCHAR(50),
    flight_status VARCHAR(20));

-- Loading data from CSV file
LOAD DATA INFILE 'Airline Dataset Updated - v2.csv'
INTO TABLE main
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
    
DROP TABLE IF EXISTS pass_demo;
CREATE TABLE pass_demo(
	SELECT
		passenger_id AS pass_id,
        first_name,
        last_name,
        gender,
        age,
        nationality
	FROM
		main);
        
DROP TABLE IF EXISTS departures;
CREATE TABLE departures(
	SELECT
		passenger_id AS pass_id,
        airport_name,
        airport_country_code,
        country_name,
        airport_continent,
        continent_name,
        departure_date
	FROM
		main);
        
DROP TABLE IF EXISTS pilot_name_status;
CREATE TABLE pilot_name_status(
	SELECT
		pilot,
        flight_status,
        passenger_id AS pass_id
	FROM
		main);
      
      
DROP TABLE IF EXISTS arrivals;
CREATE TABLE arrivals(
	SELECT
		arrival_airport,
        passenger_id AS pass_id
	FROM
		main);