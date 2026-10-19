USE bctransit;

-- 1. Temprorary tables (raw GTFS files)
CREATE TABLE temp_stops (
  stop_id INT, stop_name VARCHAR(255),
  stop_lat DOUBLE, stop_lon DOUBLE
);
CREATE TABLE temp_routes (
  route_id VARCHAR(15), 
  route_short_name VARCHAR(50), route_long_name VARCHAR(255)
);
CREATE TABLE temp_trips (
  route_id VARCHAR(15), trip_id VARCHAR(50), direction_id TINYINT
);
CREATE TABLE temp_stop_times (
  trip_id VARCHAR(50), stop_id INT, stop_sequence INT
);

LOAD DATA INFILE '/var/lib/mysql-files/BCT-data/BCTstops.txt' INTO TABLE temp_stops
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
  (stop_id, stop_name, stop_lat, stop_lon, @wheelchair_boarding, @stop_code);

LOAD DATA INFILE '/var/lib/mysql-files/BCT-data/BCTroutes.txt' INTO TABLE temp_routes
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
  (route_id, route_short_name, route_long_name, @route_type, @route_color, @route_text_color);

LOAD DATA INFILE '/var/lib/mysql-files/BCT-data/BCTtrips.txt' INTO TABLE temp_trips
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
  (route_id, @service_id, trip_id, @trip_headsign, @shape_id, @block_id, direction_id);

LOAD DATA INFILE '/var/lib/mysql-files/BCT-data/BCTstop_times.txt' INTO TABLE temp_stop_times
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
  (trip_id, @arrival_time, @departure_time, stop_id, stop_sequence,
  @shape_dist_traveled, @stop_headsign, @pickup_type, @drop_off_type, @timepoint);

-- 2. Insert into real tables
INSERT INTO bus_stop (stop_id, latitude, longitude, stop_name)
SELECT stop_id, stop_lat, stop_lon, stop_name
FROM temp_stops;

INSERT INTO bus_route (route_id, route_name)
SELECT route_id, CONCAT(route_short_name, ': ', route_long_name)
FROM temp_routes;

/* Actual bus routes have lots of possible trips they can take, and dealing with that is 
   outside our scope, since the purpose of our project mainly deals with individual stops.
   So we're assigning a representative trip to each route, so that we don't have to unnecessarily deal
   with the complexity of actual bus routes, but we still have a simplified representation of
   bus routes with bus stop ordering in case we want to add functionality related to stop ordering  in the future
   (e.g. finding the closest stop on some route that has a desired accessibility feature). */
CREATE TEMPORARY TABLE rep_trips AS
SELECT route_id, MIN(trip_id) AS trip_id
FROM temp_trips
GROUP BY route_id;

INSERT INTO route_stops (stop_id, route_id, position_index)
SELECT st.stop_id, rt.route_id, st.stop_sequence
FROM temp_stop_times AS st
JOIN rep_trips AS rt ON rt.trip_id = st.trip_id
JOIN bus_stop  AS bs ON bs.stop_id = st.stop_id 
JOIN bus_route AS br ON br.route_id = rt.route_id;

-- 3. Clean up
DROP TABLE temp_stops, temp_routes, temp_trips, temp_stop_times;

/* This code was created with help and feedback from Claude Sonnet 5.5, mostly to deal with repetition 
   and clarify how to work with the GTFS data format, and to reason through the validity of using this
   representative trip method to simplify our data. */