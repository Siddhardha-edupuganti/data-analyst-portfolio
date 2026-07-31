--- SUBQUERIES

--- Challenge 1

--- Question:
--- Display driver_id, vehicle_model and rating of drivers
--- whose rating is above the company average.

SELECT
    driver_id,
    vehicle_model,
    rating
FROM drivers
WHERE rating >
(
    SELECT AVG(rating)
    FROM drivers
)
ORDER BY rating DESC;


--- Challenge 2

--- Question:
--- Display user_id, name and email of riders
--- who completed at least one ride.

SELECT
    user_id,
    name,
    email
FROM users
WHERE user_id IN
(
    SELECT user_id
    FROM riders
    WHERE rider_id IN
    (
        SELECT rider_id
        FROM trips
        WHERE status = 'completed'
    )
);


--- Challenge 3

--- Question:
--- Show every user with the highest company fare.

SELECT
    user_id,
    name,
    date_joined,
    (
        SELECT MAX(total_fare)
        FROM trips
    ) AS highest_ever_fare
FROM users;


--- Challenge 4

--- Question:
--- Display riders whose total spending is greater than 500.

SELECT
    temp.rider_id,
    temp.highest_moneyspent
FROM
(
    SELECT
        rider_id,
        SUM(total_fare) AS highest_moneyspent
    FROM trips
    GROUP BY rider_id
) AS temp
WHERE temp.highest_moneyspent > 500;


--- Challenge 5

--- Question:
--- Display trips whose fare is less than or equal
--- to the average fare.

SELECT
    trip_id,
    status,
    total_fare
FROM trips
WHERE total_fare <=
(
    SELECT AVG(total_fare)
    FROM trips
);


--- Challenge 6

--- Question:
--- Display trips whose duration is less than or equal
--- to the average duration.

SELECT
    trip_id,
    status,
    duration_mins
FROM trips
WHERE duration_mins <=
(
    SELECT AVG(duration_mins)
    FROM trips
);
