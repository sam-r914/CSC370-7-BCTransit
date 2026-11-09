/* 
Goal: sql query for only stops that have an average rating above a certain value in a chosen category 
    (and possibly a rating count above certain threshold as well)

Specific: compute average cleanliness across all bus stops, then get the stop names of all the stops where more 
than 10 users rated it at having average or above average cleanliness. 

*/
USE bctransit;

START TRANSACTION;

DELETE FROM ratings;

INSERT INTO ratings (stop_id, type, count, sum)
VALUES
    (100146, 'noise', 22, 210),
    (100153, 'noise', 4, 25),
    (100162, 'cleanliness', 5, 40),
    (100170, 'cleanliness', 12, 24),
    (100196, 'cleanliness', 7, 56),
    (100227, 'cleanliness', 11, 77),
    (100330, 'cleanliness', 10, 90),
    (100405, 'cleanliness', 9, 45), 
    (101100, 'cleanliness', 10, 65);

SELECT * from ratings;

/* 
Average noise level across all bus stops: 6.5
Stops that should be selected:
    - 100227 (Fernwood Rd at Grant St)
    - 100330 (Begbie St at Vining St)
    - 101100 (Cadboro Bay Rd at Killarney Rd)
 */
SELECT r.stop_id, s.stop_name, r.average
FROM ratings AS r
JOIN bus_stop as s ON r.stop_id = s.stop_id
WHERE r.average >= (
    SELECT AVG(average) AS avg_cleanliness
    FROM ratings
    WHERE type = 'cleanliness')
AND r.type = 'cleanliness'
AND r.count >= 10
ORDER BY r.average DESC;

ROLLBACK;