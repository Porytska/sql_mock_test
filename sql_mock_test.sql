-- Creating tables 'Events', 'Sales', 'Session'

CREATE TABLE Events (
Id_session int,
Id int,
Event_type varchar(50)
);


INSERT INTO Events (Id_session, Id, Event_type)
VALUES (48374834385734, 7382382, 'click'),
(48374834385734, 7382367, 'apply');


CREATE TABLE Sales (
Id_session int,
Purchase float
);

INSERT INTO Sales (Id_session, Purchase)
VALUES (48374834385734, 10.1),
(48374834385734, 5.1);


CREATE TABLE Session (
Id_session int,
Id_test int,
"Group" int
);


INSERT INTO Session (Id_session, Id_test, "Group")
VALUES (48374834385734, 1, 1),
(83923923734374, 1, 2);

-- According to the table to be obtained, we assemble the pieces from the existing tables

SELECT s.Id_session, s.Id_test, s.[Group]
FROM Session s;

SELECT
e.Id_session,
e.Event_type,
count(DISTINCT e.Id) events_count
from Events e
group by e.Event_type, e.Id_session;


-- Union 

-- we're picking data from the 'Session' table to build the result's basic structure.
SELECT s.Id_test,
s.[Group],
events.Event_type AS 'Event_type/sales',
SUM(events.events_count) AS 'Indicator'
FROM Session s
INNER JOIN
-- In the 'Events' table, this section counts the number of distinct events for each event category and session.
(SELECT
e.Id_session,
e.Event_type,
count(DISTINCT e.Id) events_count
FROM Events e
GROUP BY e.Event_type, e.Id_session) events
ON 
s.Id_session = events.Id_session
GROUP BY s.Id_test, 
s.[Group],
events.Event_type 
--we use a union for the next row in our table
UNION
-- creating the same structure for table and column names
SELECT s.Id_test,
s.[Group], 
'sales' AS 'Event_type/sales',
SUM(sales.sum_purchase) AS 'Indicator'
FROM Session s
INNER JOIN
-- join sum of purchases
(SELECT 
s.id_session,
SUM(s.Purchase) sum_purchase
FROM Sales s
GROUP BY s.id_session) sales
ON s.Id_session = sales.Id_session
GROUP BY s.Id_test,
s.[Group]


