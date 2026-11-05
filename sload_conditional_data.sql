UPDATE tf_accessibility
SET value = 1
WHERE stop_id % 7 = 0 AND stop_id % 5 = 0;

UPDATE ratings
SET count = 22
WHERE stop_id % 6 = 0 AND stop_id % 4 = 0;

UPDATE ratings
SET sum = 99
WHERE stop_id % 6 = 0 AND stop_id % 4 = 0;