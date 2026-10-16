/* The code below is adapted from code generated with Claude Sonnet 5.5 */

USE `bctransit`;

-- 1. Staging tables (raw GTFS files) -------------------------------------
CREATE TABLE temp_stops (
  stop_id INT, stop_name VARCHAR(255),
  stop_lat DOUBLE, stop_lon DOUBLE,
);
CREATE TABLE temp_routes (
  route_id VARCHAR(15), 
  route_short_name VARCHAR(50), route_long_name VARCHAR(255)
);
CREATE TABLE temp_trips (
  route_id VARCHAR(15), trip_id INT, direction_id TINYINT
);
CREATE TABLE temp_stop_times (
  trip_id VARCHAR(50), stop_id INT, stop_sequence INT
);

LOAD DATA LOCAL INFILE 'BCT-data/BCTstops.txt' INTO TABLE stg_stops
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
  (stop_id, stop_name, stop_lat, stop_lon, @wheelchair_boarding, @stop_code);

LOAD DATA LOCAL INFILE 'BCT-data/BCTroutes.txt' INTO TABLE stg_routes
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
  (route_id, route_short_name, route_long_name, @route_type, @route_color, @route_text_color);

LOAD DATA LOCAL INFILE 'BCT-data/BCTtrips.txt' INTO TABLE stg_trips
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
  (route_id, @service_id, trip_id, @trip_headsign, @shape_id, @block_id, direction_id);

LOAD DATA LOCAL INFILE 'BCT-data/BCTstop_times.txt' INTO TABLE stg_stop_times
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
  (trip_id, @arrival_time, @departure_time, stop_id, stop_sequence,
  @shape_dist_traveled, @stop_headsign, @pickup_type, @drop_off_type, @timepoint);

-- 2. Insert into real tables (parents before children) -------------------
INSERT INTO bus_stop (stop_id, latitude, longitude, stop_name)
SELECT stop_id, stop_lat, stop_lon, LEFT(stop_name, 100)
FROM stg_stops;

INSERT INTO bus_route (route_id, route_name)
SELECT route_id, LEFT(CONCAT(route_short_name, ': ', route_long_name), 100)
FROM stg_routes;

-- One representative trip per route (lowest trip_id)
CREATE TEMPORARY TABLE rep_trips AS
SELECT route_id, MIN(trip_id) AS trip_id
FROM stg_trips
GROUP BY route_id;

INSERT INTO route_stops (stop_id, route_id, position_index)
SELECT st.stop_id, rt.route_id, st.stop_sequence
FROM stg_stop_times AS st
JOIN rep_trips AS rt ON rt.trip_id = st.trip_id
JOIN bus_stop  AS bs ON bs.stop_id = st.stop_id   -- guards the FK
JOIN bus_route AS br ON br.route_id = rt.route_id; -- guards the FK

-- 3. Optional: use the wheelchair data you previously dropped ------------
-- GTFS: 0 = unknown, 1 = accessible, 2 = not accessible
INSERT INTO tf_accessibility (stop_id, name, value)
SELECT stop_id, 'wheelchair', CASE wheelchair_boarding WHEN 1 THEN 1 ELSE 0 END
FROM stg_stops
WHERE wheelchair_boarding IN (1, 2);

-- 4. Clean up -------------------------------------------------------------
DROP TABLE stg_stops, stg_routes, stg_trips, stg_stop_times;

