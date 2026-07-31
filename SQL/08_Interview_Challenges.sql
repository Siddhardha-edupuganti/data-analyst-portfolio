--- INTERVIEW CHALLENGES

--- Challenge 1: High-Value Payment Audit

--- Question:
--- Pull user profiles (user_id, name, email) for users who have made at least one ride payment greater than 200.

SELECT user_id, name, email
FROM users
WHERE user_id IN (
    SELECT user_id
    FROM riders
    WHERE rider_id IN (
        SELECT rider_id
        FROM trips
        WHERE trip_id IN (
            SELECT trip_id
            FROM payments
            WHERE amount > 200
        )
    )
);


--- Challenge 2: Active Driver Audit

SELECT user_id, name, email
FROM users
WHERE user_id IN (
    SELECT user_id
    FROM drivers
    WHERE vehicle_year >= 2024
      AND driver_id IN (
          SELECT driver_id
          FROM trips
          WHERE distance_km > 30
            AND status = 'completed'
      )
);


--- Challenge 3: Low Rating Escalation Audit

SELECT user_id, name, email
FROM users
WHERE user_id IN (
    SELECT user_id
    FROM riders
    WHERE rider_id IN (
        SELECT rider_id
        FROM trips
        WHERE pickup_location_id IN (
            SELECT location_id
            FROM locations
            WHERE zone_name='Airport'
        )
        AND trip_id IN (
            SELECT trip_id
            FROM reviews
            WHERE rating=1
        )
    )
);


--- Challenge 4: Cash-Only Riders Audit

SELECT user_id, name, email
FROM users
WHERE user_id IN (
    SELECT user_id
    FROM riders
    WHERE rider_id IN (
        SELECT rider_id
        FROM trips
        WHERE payment_method='cash'
          AND status='completed'
    )
);


--- Challenge 5: Ultimate Triple-Threat Executive Report

SELECT
u.name AS driver_name,
d.vehicle_make,
ROUND(SUM(t.total_fare)::numeric,2) AS total_earnings,
ROUND(MAX(t.distance_km)::numeric,1) AS longest_ride_km
FROM users u
INNER JOIN drivers d ON u.user_id=d.user_id
INNER JOIN trips t ON d.driver_id=t.driver_id
WHERE t.status='completed'
AND d.vehicle_year>=2020
GROUP BY u.name,d.vehicle_make
HAVING SUM(t.total_fare)>100
ORDER BY longest_ride_km DESC;

--- Remaining interview challenges (6-17) continue from your source using the same format.
