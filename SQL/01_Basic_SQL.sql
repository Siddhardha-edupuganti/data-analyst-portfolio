--- BASIC SQL

--- Challenge 1: Display All Users

--- Question:
--- Display all columns from the users table.

SELECT *
FROM users;


--- Challenge 2: Display Selected Columns

--- Question:
--- Display user_id, name and city.

SELECT
    user_id,
    name,
    city
FROM users;


--- Challenge 3: Active Drivers

--- Question:
--- Display active drivers.

SELECT
    driver_id,
    user_id,
    vehicle_model,
    rating
FROM drivers
WHERE is_active = 1;


--- Challenge 4: Completed Trips

--- Question:
--- Display completed trips only.

SELECT
    trip_id,
    driver_id,
    rider_id,
    total_fare
FROM trips
WHERE status = 'completed';


--- Challenge 5: Trips Above Average Fare Threshold

--- Question:
--- Display trips whose fare is greater than 500.

SELECT
    trip_id,
    driver_id,
    total_fare
FROM trips
WHERE total_fare > 500;


--- Challenge 6: Sort Drivers by Rating

--- Question:
--- Display drivers ordered by rating.

SELECT
    driver_id,
    vehicle_model,
    rating
FROM drivers
ORDER BY rating DESC;


--- Challenge 7: Top 10 Highest Fare Trips

--- Question:
--- Display the top 10 trips by fare.

SELECT
    trip_id,
    driver_id,
    total_fare
FROM trips
ORDER BY total_fare DESC
LIMIT 10;


--- Challenge 8: Distinct Cities

--- Question:
--- Display all unique cities.

SELECT DISTINCT city
FROM users
ORDER BY city;


--- Challenge 9: Trips Between 500 and 1000

--- Question:
--- Display trips whose fare is between 500 and 1000.

SELECT
    trip_id,
    total_fare
FROM trips
WHERE total_fare BETWEEN 500 AND 1000;


--- Challenge 10: Drivers With Rating Above 4.5

--- Question:
--- Display drivers whose rating is greater than 4.5.

SELECT
    driver_id,
    vehicle_model,
    rating
FROM drivers
WHERE rating > 4.5
ORDER BY rating DESC;
