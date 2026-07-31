--- WINDOW FUNCTIONS

--- Ranking Functions

--- Challenge 1: Top-Earning Riders Per City (DENSE_RANK)

--- Question:
--- Display the top 3 riders by total spending in each city.

WITH rankcategory AS (
    SELECT
        u.city,
        u.name AS rider_name,
        ROUND(SUM(t.total_fare)::NUMERIC, 2) AS total_spent,
        DENSE_RANK() OVER(PARTITION BY u.city ORDER BY SUM(t.total_fare) DESC) AS city_rank
    FROM users u
    INNER JOIN riders r ON r.user_id = u.user_id
    INNER JOIN trips t ON t.rider_id = r.rider_id
    WHERE t.status = 'completed'
    GROUP BY u.city, u.name
)
SELECT city, rider_name, total_spent, city_rank
FROM rankcategory
WHERE city_rank <= 3
ORDER BY total_spent ASC, city_rank ASC;


--- Challenge 2: Rank Trips by Fare Per Driver

SELECT trip_id, driver_id, total_fare,
RANK() OVER(PARTITION BY driver_id ORDER BY total_fare DESC) AS rank_fare
FROM trips
ORDER BY trip_id;


--- Challenge 3: Dense Rank Trips Per Driver

SELECT trip_id, driver_id, total_fare,
DENSE_RANK() OVER(PARTITION BY driver_id ORDER BY total_fare DESC) AS fare_dense_rank
FROM trips;


--- Challenge 4: Overall Driver Rank by Revenue

SELECT
d.driver_id,
COUNT(t.trip_id) AS total_trips,
COUNT(CASE WHEN t.total_fare >=1000 THEN 1 END) AS premium_trips,
SUM(t.total_fare) AS total_revenue,
RANK() OVER(ORDER BY SUM(t.total_fare) DESC) AS driver_rank
FROM drivers d
JOIN trips t ON d.driver_id=t.driver_id
WHERE d.is_active=1
GROUP BY d.driver_id
ORDER BY driver_rank;


--- ROW_NUMBER()

--- Challenge 5: Number Driver Trips

SELECT trip_id,driver_id,requested_at AS trip_date,
ROW_NUMBER() OVER(PARTITION BY driver_id ORDER BY requested_at) AS trip_number
FROM trips;


--- Challenge 6: Highest Fare Trip Per Driver

WITH rank_trips AS(
SELECT driver_id,trip_id,total_fare,
ROW_NUMBER() OVER(PARTITION BY driver_id ORDER BY total_fare DESC) AS trip_fare
FROM trips
)
SELECT driver_id,trip_id,total_fare
FROM rank_trips
WHERE trip_fare=1;


--- Aggregate Window Functions

--- Challenge 7: City Average Fare vs Trip Fare

WITH city_wide_fare AS(
SELECT t.trip_id,l.city,
ROUND(t.total_fare::NUMERIC,2) AS total_fare,
ROUND(AVG(t.total_fare) OVER(PARTITION BY l.city)::NUMERIC,2) AS city_average_fare
FROM trips t
INNER JOIN locations l
ON t.pickup_location_id=l.location_id
WHERE t.status='completed'
)
SELECT *,
(total_fare-city_average_fare) AS fare_difference
FROM city_wide_fare;


--- Challenge 8: Driver Revenue Contribution

SELECT trip_id,driver_id,total_fare,
SUM(total_fare) OVER(PARTITION BY driver_id) AS driver_total_revenue,
ROUND((total_fare/SUM(total_fare) OVER(PARTITION BY driver_id))::NUMERIC*100,2) AS contribution_pct
FROM trips
WHERE status='completed';


--- Navigation Functions

--- Challenge 9: LAG()

SELECT trip_id,driver_id,requested_at,total_fare,
LAG(total_fare) OVER(PARTITION BY driver_id ORDER BY requested_at) AS previous_trip_fare
FROM trips;


--- Challenge 10: LEAD()

SELECT trip_id,driver_id,requested_at,total_fare,
LEAD(total_fare) OVER(PARTITION BY driver_id ORDER BY requested_at) AS next_trip_fare
FROM trips;


--- Challenge 11: FIRST_VALUE()

SELECT trip_id,driver_id,requested_at,total_fare,
FIRST_VALUE(total_fare) OVER(PARTITION BY driver_id ORDER BY requested_at) AS first_trip_fare
FROM trips;


--- Challenge 12: LAST_VALUE()

SELECT trip_id,driver_id,requested_at,total_fare,
LAST_VALUE(total_fare) OVER(
PARTITION BY driver_id
ORDER BY requested_at
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS last_trip_fare
FROM trips;


--- Challenge 13: NTH_VALUE()

SELECT trip_id,driver_id,requested_at,total_fare,
NTH_VALUE(total_fare,2) OVER(
PARTITION BY driver_id
ORDER BY requested_at
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS second_trip_fare
FROM trips;


--- Distribution Functions

--- Challenge 14: NTILE()

SELECT trip_id,driver_id,total_fare,
NTILE(4) OVER(PARTITION BY driver_id ORDER BY total_fare DESC) AS fare_bucket
FROM trips;


--- Challenge 15: CUME_DIST()

SELECT trip_id,driver_id,total_fare,
CUME_DIST() OVER(PARTITION BY driver_id ORDER BY total_fare DESC) AS fare_distribution
FROM trips;


--- Challenge 16: PERCENT_RANK()

SELECT trip_id,driver_id,total_fare,
PERCENT_RANK() OVER(PARTITION BY driver_id ORDER BY total_fare) AS fare_percent_rank
FROM trips;




--- Advanced Window Function Challenges

--- Challenge 17: Top-Earning Riders Per City (DENSE_RANK)

WITH rankcategory AS (
    SELECT
        u.city,
        u.name AS rider_name,
        ROUND(SUM(t.total_fare)::numeric, 2) AS total_spent,
        DENSE_RANK() OVER(PARTITION BY u.city ORDER BY SUM(t.total_fare) DESC) AS city_rank
    FROM users u
    INNER JOIN riders r ON r.user_id = u.user_id
    INNER JOIN trips t ON t.rider_id = r.rider_id
    WHERE t.status = 'completed'
    GROUP BY u.city, u.name
)
SELECT city, rider_name, total_spent, city_rank
FROM rankcategory
WHERE city_rank <= 3
ORDER BY city_rank ASC, total_spent DESC;



--- Challenge 18: Driver Revenue Leaderboard (RANK)

WITH driver_revenue AS (
    SELECT
        u.city,
        t.driver_id,
        SUM(t.total_fare) AS driver_total_revenue
    FROM trips t
    JOIN drivers d ON t.driver_id = d.driver_id
    JOIN users u ON u.user_id = d.user_id
    WHERE t.status = 'completed'
    GROUP BY u.city, t.driver_id
)
SELECT
    city,
    driver_id,
    driver_total_revenue,
    RANK() OVER(PARTITION BY city ORDER BY driver_total_revenue DESC) AS revenue_rank_by_city,
    ROUND((driver_total_revenue - MAX(driver_total_revenue) OVER(PARTITION BY city))::numeric,2) AS diff_from_top_driver
FROM driver_revenue
ORDER BY city, revenue_rank_by_city;



--- Challenge 19: Highest Revenue Driver Per City (ROW_NUMBER)

WITH driver_revenue AS (
    SELECT
        u.city,
        t.driver_id,
        COUNT(t.trip_id) AS total_completed_trips,
        ROUND(SUM(t.total_fare)::numeric,2) AS total_revenue
    FROM trips t
    JOIN drivers d ON t.driver_id = d.driver_id
    JOIN users u ON u.user_id = d.user_id
    WHERE t.status='completed'
    GROUP BY u.city,t.driver_id
    HAVING COUNT(t.trip_id)>=3
)
SELECT
    city,
    driver_id,
    total_completed_trips,
    total_revenue,
    ROW_NUMBER() OVER(PARTITION BY city ORDER BY total_revenue DESC) AS city_rank
FROM driver_revenue;



--- Challenge 20: Highest Fare Trip Per Driver

WITH rank_trips AS (
    SELECT
        driver_id,
        trip_id,
        total_fare,
        ROW_NUMBER() OVER(PARTITION BY driver_id ORDER BY total_fare DESC) AS rn
    FROM trips
    WHERE status='completed'
)
SELECT driver_id, trip_id, total_fare
FROM rank_trips
WHERE rn=1
ORDER BY driver_id;
