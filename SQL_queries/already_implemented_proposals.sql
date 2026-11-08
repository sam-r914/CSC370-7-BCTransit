/* 
    Goal:
        Write an sql query that filters proposals to those that have not been reviewed 
        yet and checks if another proposal's change has already applied the same target 
        value to the relevant stop and category. Uses appropriate join and/or EXISTS. 

    Specific example to meet goal:
    	All pending or  proposals that want to say that a bus stop has or does not have a trashcan where that 
        bus stop’s trashcan attribute in tf_accessibility is already set to to the same value as the proposals.

        Test cases:
            Proposal (User 11, Bus stop 100024): 
                Expected: Should show in the query result since the bus stop trashcan is set to one and 
                the change value in the proposed change is also one

            Proposal (User 13, Bus stop 100024): 
                Expected: Should not show since the proposed value is different from the current bus stop tf value
                            i.e tests that unwanted proposals are excluded based on proposed value

            Proposal (User 14, Bus stop 100024): 
                Expected: Should show as the proposed value is equal to current value
                            i.e tests that mutliple proposals expected can be shown for same bus stops

            Proposal (User 13, Bus stop 100025): 
                Expected: should show as proposed value is equal to current. tests the oposite value of first bus stop (i.e 1 instead of 0)

            Proposal (User 14, Bus stop 100025): 
                Expected: should be excluded
            
            Proposal (User 15, Bus stop 100028): 
                Expected: should be excluded as it does not apply to trashcan even though it is an already implemented proposal
    Summary: 
        We expect the output to contain:
            Proposal with user 11, bus stop 100024
            Proposal with user 14, bus stop 100024
            Proposal with user 13, bus stop 100025
            
*/

USE bctransit;

START TRANSACTION;

INSERT INTO user (user_id, email, password)
VALUES
    (11, 'john@mail.com', 'password11'),
    (13, 'testuser13@mail.com', 'password13'),
    (14, 'testuser14@mail.com', 'password14'),
    (15, 'testuser15@mail.com', 'password15');

INSERT INTO proposed_changes (user_id, stop_id, date_time, status, description, value, type, reviewed_by)
VALUES
	(11, 100024, '2026-11-08 01:33:01', 'pending', 'now has a trash can', '1', 'trashcan', NULL),
    (13, 100024, '2026-11-08 01:43:02', 'pending', 'Stop does not have a trashcan', '0', 'trashcan', NULL),
    (14, 100024, '2026-11-08 01:33:07', 'pending', 'Stop just got a new trash can', '1', 'trashcan', NULL),
    (13, 100025, '2025-11-08 01:33:02', 'pending', 'Trashcan got removed', '0', 'trashcan', NULL),
    (14, 100025, '2026-11-09 01:33:02', 'approved', 'Trashcan already exists', '1', 'trashcan', NULL),
    (15, 100028, '2026-11-08 01:34:02', 'pending', 'Stop has a shelter', '1', 'shelter', NULL);

DELETE FROM tf_accessibility
WHERE stop_id IN (100024, 100025, 100028);

INSERT INTO tf_accessibility (stop_id, name, value, updated_at)
VALUES
	(100024, 'trashcan', 1, NOW()),
    (100024, 'shelter', 1, NOW()),
    (100025, 'trashcan', 0, NOW()),
    (100028, 'shelter', 1, NOW()),
    (100028, 'trashcan', 1, NOW());


SELECT  stop_id, user_id
FROM proposed_changes
JOIN tf_accessibility USING (stop_id)
WHERE (tf_accessibility.name = proposed_changes.type) 
    AND (tf_accessibility.value = proposed_changes.value)
    AND (tf_accessibility.name = 'trashcan')
    AND (proposed_changes.status = 'pending');


ROLLBACK;
