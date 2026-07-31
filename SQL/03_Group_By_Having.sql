--- GROUP BY & HAVING

--- Challenge 1

--- Question:
--- Display zone_name and total revenue collected
--- from completed trips.

SELECT l.zone_name,
       SUM(t.total_fare) AS total_revenue
FROM trips t
INNER JOIN locations l
ON l.location_id = t.pickup_location_id
WHERE t.status = 'completed'
GROUP BY zone_name
ORDER BY total_revenue DESC;


--- Challenge 2

--- Question:
--- Display driver_name and bad_review_count.
--- Show only drivers with 2 or more reviews below rating 3.

SELECT
 u.name AS driver_name,
 COUNT(*) AS bad_review_count
FROM users u
INNER JOIN reviews r
ON u.user_id = r.reviewee_id
WHERE r.rating < 3
GROUP BY u.name
HAVING COUNT(*) >= 2
ORDER BY bad_review_count DESC;


--- Challenge 3

--- Question:
--- Total earnings and completed trips for each driver.

SELECT driver_id,
ROUND(SUM(total_fare)::NUMERIC,2) AS total_earnings,
COUNT(trip_id) AS total_trips
FROM trips
WHERE status='completed'
GROUP BY driver_id
ORDER BY total_earnings DESC;


--- Challenge 4

--- Question:
--- Total spending and completed trips for each rider.

SELECT rider_id,
ROUND(SUM(total_fare)::NUMERIC,2) AS total_spent,
COUNT(trip_id) AS total_trips
FROM trips
WHERE status='completed'
GROUP BY rider_id
ORDER BY total_spent DESC;


--- Challenge 5

--- Question:
--- Distance covered and average duration for each driver.

SELECT driver_id,
ROUND(SUM(distance_km)::NUMERIC,1) AS distance_covered,
ROUND(AVG(duration_mins)::NUMERIC,0) AS avg_time_spent
FROM trips
WHERE status='completed'
GROUP BY driver_id
ORDER BY distance_covered;
