INSERT INTO ratings (stop_id, type)
SELECT t.stop_id, 'noise'
FROM bus_stop t;

INSERT INTO tf_accessibility (stop_id, name)
SELECT t.stop_id, 'wheelchair'
FROM bus_stop t;

UPDATE tf_accessibility
SET value = 1
WHERE name = 'wheelchair' AND stop_id % 7 = 0;