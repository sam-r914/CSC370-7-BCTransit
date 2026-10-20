-- FD 1: stop_id -> stop attributes
-- stop_id is the primary key.
SELECT stop_id, COUNT(*) AS occurrences
FROM bus_stop
GROUP BY stop_id
HAVING COUNT(*) > 1;

-- FD 2: route_id -> route attributes
-- route_id is the primary key, not route_name.
SELECT route_id, COUNT(*) AS occurrences
FROM bus_route
GROUP BY route_id
HAVING COUNT(*) > 1;

-- FD 3: (route_id, position_index) -> stop_id
SELECT route_id, position_index,
       COUNT(DISTINCT stop_id) AS distinct_stops
FROM route_stops
GROUP BY route_id, position_index
HAVING COUNT(DISTINCT stop_id) > 1;

-- FD 4: (stop_id, type) -> rating attributes
SELECT stop_id, type, COUNT(*) AS occurrences
FROM ratings
GROUP BY stop_id, type
HAVING COUNT(*) > 1;

-- FD 5: (stop_id, name) -> accessibility attributes
SELECT stop_id, name, COUNT(*) AS occurrences
FROM tf_accessibility
GROUP BY stop_id, name
HAVING COUNT(*) > 1;

-- FD 6: user_id -> user attributes
SELECT user_id, COUNT(*) AS occurrences
FROM `user`
GROUP BY user_id
HAVING COUNT(*) > 1;

-- FD 7: user_id -> privileged_user attributes
SELECT user_id, COUNT(*) AS occurrences
FROM privileged_user
GROUP BY user_id
HAVING COUNT(*) > 1;

-- FD 8: (user_id, date_time) -> proposed change attributes
SELECT user_id, date_time, COUNT(*) AS occurrences
FROM proposed_changes
GROUP BY user_id, date_time
HAVING COUNT(*) > 1;

-- Check whether stop_name is unique.
-- Duplicate stop names are present in the current data.
SELECT stop_name, COUNT(*) AS occurrences
FROM bus_stop
GROUP BY stop_name
HAVING COUNT(*) > 1;

-- Check whether route_name is unique in the current data.
-- route_name is NOT the declared identifier.
SELECT route_name, COUNT(*) AS occurrences
FROM bus_route
GROUP BY route_name
HAVING COUNT(*) > 1;

-- Show the primary keys and UNIQUE constraints.
SELECT TABLE_NAME, INDEX_NAME,
       GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX
                    SEPARATOR ', ') AS key_columns
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
  AND NON_UNIQUE = 0
GROUP BY TABLE_NAME, INDEX_NAME
ORDER BY TABLE_NAME, INDEX_NAME;