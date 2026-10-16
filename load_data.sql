USE bctransit;

LOAD DATA INFILE '/var/lib/mysql-files/routes.csv'
INTO TABLE bus_route
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(route_id, route_name);

LOAD DATA INFILE '/var/lib/mysql-files/stops.csv'
INTO TABLE bus_stop
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(stop_id, stop_name, latitude, longitude);

LOAD DATA INFILE '/var/lib/mysql-files/route_stops.csv'
INTO TABLE route_stops
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(stop_id, route_id, position_index);

