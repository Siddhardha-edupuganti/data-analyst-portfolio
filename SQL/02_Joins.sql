--- SQL Joins

--- LEFT JOIN

SELECT u.user_id, u.name, t.status
FROM users u
LEFT JOIN trips t
ON u.user_id = t.trip_id
AND t.status = 'cancelled';


--- RIGHT JOIN

SELECT t.*, u.name
FROM trips t
RIGHT JOIN users u
ON u.user_id = t.trip_id;


--- INNER JOIN

SELECT *
FROM users
INNER JOIN trips
ON users.user_id = trips.trip_id;


--- FULL JOIN

SELECT *
FROM users
FULL JOIN trips
ON users.user_id = trips.trip_id;


--- Challenge 1

--- Question:
--- Display every driver's driver_id, name, email,
--- vehicle_model and profile rating.

SELECT d.driver_id,
       u.name,
       u.email,
       d.vehicle_model,
       d.rating
FROM drivers d
INNER JOIN users u
ON d.user_id = u.user_id
ORDER BY d.rating DESC;


--- Challenge 2

--- Question:
--- Display rider_id, name and email of riders
--- who have zero trips.

SELECT r.rider_id,
       u.name,
       u.email
FROM users u
INNER JOIN riders r
ON u.user_id = r.user_id
WHERE total_trips = 0;
