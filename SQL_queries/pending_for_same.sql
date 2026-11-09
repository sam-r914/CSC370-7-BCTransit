/* to do:
Goal: Write an SQL query for proposals that apply to the same category and stop and are still pending. 
Output the value to be changed to and the change description. This information can be used to understand the 
reason for, as well as the validity of, the proposals that are currently pending so that they can be 
effectively accepted or denied.

Specific: All pending proposals wanting to change the shelter attribute on a specific stop, 
whether they want to set it to True or False, ordered from the most recent to the oldest

*/

USE bctransit;

START TRANSACTION;

-- load users
INSERT INTO user (user_id, email, password)
VALUES
    (0001, 'alice@mail.com', '1_password'),
    (0002, 'bob@mail.com', '2_password'),
    (0003, 'carol@mail.com', '3_password'),
    (0004, 'danny@mail.com', '4_password'),
    (0005, 'evelyn@mail.com', '5_password');

INSERT INTO privileged_user (user_id)
VALUES (0001);

/*
- load dummy data
    - add 5 dummy users
    - add 2-3 dummy priveleged user
    - will use Cadboro Bay Rd at Killarney Rd (101100) because it's nearby and doesn't have a duplicate
    - put in 3 pending proposals:
        - 1 TRUE (accidentaly thought it was a stop a few blocks up)
        - 1 FALSE (from the same user as above)
        - 1 FALSE (the usual this stop has no shelter)
    - 2 rejected proposals (thought the tree counted as a shelter)
    - 1 accepted proposal (imagine the stop used to have a shelter but it's been removed because of construction or something. 
      realistically this probably wouldn't happen because of the automatic deletion but it's here for testing purposes)

    - some other pending proposals for that stop (other attributes)
    - pending proposals for shelter on different stops
*/

INSERT INTO proposed_changes (user_id, stop_id, date_time, status, description, value, type, reviewed_by)
VALUES
    (0004, 101100, DATE_SUB(NOW(), INTERVAL 12 DAY), 'approved', 
        'This bus stop has a shelter.', 1, 'shelter', 0001),
    (0003, 101100, DATE_SUB(NOW(), INTERVAL 13 DAY), 'denied', 
        'This bus stop has a big tree covering it.', 1, 'shelter', 0001),
    (0002, 101100, DATE_SUB(NOW(), INTERVAL 8 DAY), 'pending', 
        'This bus stop used to have a shelter but it got removed bcause of construction.', 0, 'shelter', NULL),
    (0005, 101100, DATE_SUB(NOW(), INTERVAL 7 DAY), 'pending',
        'This bus stop has a shelter! There was a new shelter put in recently', 1, 'shelter', NULL),
    (0005, 101100, DATE_SUB(NOW(), INTERVAL 6 DAY), 'pending',
        'Whoops my bad I meant to add this for the stop up the street', 0, 'shelter', NULL),
    (0005, 102702, DATE_SUB(NOW(), INTERVAL 5 DAY), 'pending',
        'There was a new shelter put in recently (at the other bus stop).', 1, 'shelter', NULL),
    (0005, 101100, DATE_SUB(NOW(), INTERVAL 4 DAY), 'pending', 
        'This stop has a trashcan.', 1, 'trashcan', NULL),
    (0004, 101100, DATE_SUB(NOW(), INTERVAL 8 DAY), 'pending', 
        'This stop does not have a bench.', 0, 'seating', NULL),
    (0003, 101079, DATE_SUB(NOW(), INTERVAL 10 DAY), 'pending', 
        'This bus stop (other one) has a shelter.', 1, 'shelter', NULL),
    (0003, 101053, DATE_SUB(NOW(), INTERVAL 9 DAY), 'pending', 
        'This bus stop (yet another one) does not have a shelter.', 0, 'shelter', NULL);

SELECT * FROM proposed_changes;

/* rows that should be selected by the query:
    - 0002's proposal
    - 0005's first proposal
    - 0005's second proposal
*/

SELECT user_id, date_time, value, description
FROM proposed_changes 
WHERE (stop_id = 101100)
    AND (type = 'shelter')
    AND (status = 'pending')
ORDER BY date_time DESC;

ROLLBACK;
