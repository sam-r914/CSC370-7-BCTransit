/*
    Goal:
        Delete proposals that are too old (past certain date time)

    Specific example to meet goal:
        Set a cutoff threshold of 2 weeks from the current date and put in some dummy 
        data and verify that the old records are removed (unless they’re still pending) 
        and no recent data will be affected.

    Test cases:
        Proposal (User 11, Bus stop 100024):
            Status: denied
            Date: 2026-10-20
            Expected: Should be deleted as it is older than two weeks and has already been denied.

        Proposal (User 12, Bus stop 100025):
            Status: approved
            Date: 2026-10-22
            Expected: Should be deleted because it is older than two weeks and has already been approved.

        Proposal (User 13, Bus stop 100028):
            Status: pending
            Date: 2026-10-20
            Expected: Should not be deleted because it is pending, even though it is older than two weeks.

        Proposal (User 14, Bus stop 100030):
            Status: denied
            Date: 2026-11-05
            Expected: Should NOT be deleted because it is less than two weeks old.

        Proposal (User 15, Bus stop 100031):
            Status: approved
            Date: 2026-11-06
            Expected: Should NOT be deleted because it is less than two weeks old.

    Summary:
        Expect the following proposals to be deleted:
            Proposal with user 11, bus stop 100024
            Proposal with user 12, bus stop 100025

        Expect the following proposals to remain:
            Proposal with user 13, bus stop 100028
            Proposal with user 14, bus stop 100030
            Proposal with user 15, bus stop 100031
*/

USE bctransit;

START TRANSACTION;

INSERT INTO user (user_id, email, password)
VALUES
    (11, 'john@mail.com', 'password11'),
    (12, 'testuser12@mail.com', 'password12'),
    (13, 'testuser13@mail.com', 'password13'),
    (14, 'testuser14@mail.com', 'password14'),
    (15, 'testuser15@mail.com', 'password15');

INSERT INTO proposed_changes
(user_id, stop_id, date_time, status, description, value, type, reviewed_by)
VALUES
    (11, 100024, DATE_SUB(NOW(), INTERVAL 18 DAY), 'denied', 'Old denied proposal', '1', 'trashcan', NULL),
    (12, 100025, DATE_SUB(NOW(), INTERVAL 16 DAY), 'approved', 'Old approved proposal', '1', 'shelter', NULL),
    (13, 100028, DATE_SUB(NOW(), INTERVAL 18 DAY), 'pending', 'Old pending proposal', '1', 'trashcan', NULL),
    (14, 100030, DATE_SUB(NOW(), INTERVAL 2 DAY), 'denied', 'Recent denied proposal', '0', 'seating', NULL),
    (15, 100031, DATE_SUB(NOW(), INTERVAL 1 DAY), 'approved', 'Recent approved proposal', '1', 'wheelchair', NULL);

/* show proposals before deleting */
SELECT user_id, stop_id, date_time, status
FROM proposed_changes
ORDER BY user_id;


DELETE FROM proposed_changes
WHERE date_time < DATE_SUB(NOW(), INTERVAL 14 DAY)
AND status <> 'pending';

/* show after deleting */
SELECT user_id, stop_id, date_time, status
FROM proposed_changes
ORDER BY user_id;

ROLLBACK;
