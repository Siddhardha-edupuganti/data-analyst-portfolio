--- CTEs (WITH)

--- Challenge 1

--- Question:
--- Show Top 3 riders by total spending within each city.

WITH rankcategory AS
(
    SELECT
        u.city,
        u.name AS rider_name,
        ROUND(SUM(t.total_fare)::numeric,2) AS total_spent,
        DENSE_RANK() OVER
        (
            PARTITION BY u.city
            ORDER BY SUM(t.total_fare) DESC
        ) AS city_rank
    FROM users u
    INNER JOIN riders r
        ON r.user_id = u.user_id
    INNER JOIN trips t
        ON t.rider_id = r.rider_id
    WHERE t.status='completed'
    GROUP BY u.city,u.name
)

SELECT
    city,
    rider_name,
    total_spent,
    city_rank
FROM rankcategory
WHERE city_rank<=3
ORDER BY total_spent ASC, city_rank ASC;


--- Challenge 2

--- Question:
--- Driver earnings, zone average and earnings difference.

WITH driver_metrics AS
(
    SELECT
        l.zone_name,
        t.driver_id,
        ROUND(SUM(t.total_fare)::numeric,2) AS driver_total_earnings,
        ROUND(
            AVG(SUM(t.total_fare)) OVER(PARTITION BY l.zone_name)::numeric,
            2
        ) AS zone_average
    FROM locations l
    INNER JOIN trips t
        ON t.pickup_location_id=l.location_id
    WHERE t.status='completed'
    GROUP BY l.zone_name,t.driver_id
)

SELECT
    zone_name,
    driver_id,
    driver_total_earnings,
    zone_average,
    (driver_total_earnings-zone_average) AS earnings_difference
FROM driver_metrics
ORDER BY zone_name ASC;
