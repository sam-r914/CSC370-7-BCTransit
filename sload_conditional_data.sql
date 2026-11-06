UPDATE tf_accessibility
SET value = 1
WHERE stop_id % 2 = 0 ;

UPDATE tf_accessibility
SET value = 0
WHERE stop_id % 2 = 1;

UPDATE ratings
SET count = 22
WHERE stop_id % 2 = 0;

UPDATE ratings
SET sum = 99
WHERE stop_id % 2 = 0;

UPDATE ratings
SET count = 56
WHERE stop_id % 2 = 1;

UPDATE ratings
SET sum = 150
WHERE stop_id % 2 = 1;