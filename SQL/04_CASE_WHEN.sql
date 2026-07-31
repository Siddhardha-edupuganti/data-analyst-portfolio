--- CASE WHEN

--- Challenge 1

--- Question:
--- Display every driver's driver_id, rating and performance_badge.

SELECT
    driver_id,
    rating,
    CASE
        WHEN rating >= 4.5 THEN 'Super diver'
        WHEN rating >= 3.5 AND rating <= 4.5 THEN 'Average driver'
        ELSE 'Needs training'
    END AS performance_badge
FROM drivers;


--- Challenge 2

--- Question:
--- Categorize every trip based on surge_multiplier.

SELECT
    trip_id,
    surge_multiplier,
    total_fare,
    CASE
        WHEN surge_multiplier = 1.0 THEN 'Normal fare'
        WHEN surge_multiplier > 1.0 AND surge_multiplier <= 1.5 THEN 'Moderate surge'
        ELSE 'high surge'
    END AS surge_type
FROM trips;


--- Challenge 3

--- Question:
--- Display reviewer_name, rating and review_urgnecy.

SELECT
    t.trip_id,
    u.name AS reviewer_name,
    r.rating,
    CASE
        WHEN r.rating IN (1,2) THEN 'urgent action required'
        WHEN r.rating = 3 THEN 'Follow up needed'
        WHEN r.rating IN (4,5) THEN 'Godd reveiw'
    END AS review_urgnecy
FROM reviews r
INNER JOIN trips t
ON r.trip_id = t.trip_id
INNER JOIN users u
ON r.reviewer_id = u.user_id
WHERE t.status = 'completed';
