/* to do:
Goal: Write an SQL query for proposals that apply to the same category and stop and are still pending. Output the value to be changed to and the change description. This information can be used to understand the reason for, as well as the validity of, the proposals that are currently pending so that they can be effectively accepted or denied.

Specific: All pending proposals wanting to change the shelter attribute on a specific stop, whether they want to set it to True or False, ordered from the most recent to the oldest

- use a transaction then rollback? will have to look up more.
- bypass current timestamp? just put a date in some specific timestamp format?

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
    
- the query itself:
    - output schema: user_id, date_time (ORDER BY), value, description
        - no need to include status, stop_id, and type because they're part of the question we're asking
    - doesn't need to join on anything i don't think
    - where stop_id and type match and status is pending
    - order by date added descending
*/
USE bctransit;

START TRANSACTION;

-- load users
INSERT INTO user (user_id, email, password)
VALUES
    (0001, 'alice@mail.com', 'alice_password'),
    (0002, 'bob@mail.com', 'bob_password'),
    (0003, 'carol@mail.com', 'carol_password'),
    (0004, 'danny@mail.com', 'danny_password');

INSERT INTO privileged_user (user_id)
VALUES (0001);

SELECT * FROM user LIMIT 5;

ROLLBACK;
