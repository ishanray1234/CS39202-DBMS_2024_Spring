-- STUDENT Table
CREATE TABLE STUDENT (
    id SERIAL,
    Roll CHAR(9) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Dept VARCHAR(25) NOT NULL,
    rid INTEGER REFERENCES ROLE(Rid) ON DELETE CASCADE,
    eid INTEGER REFERENCES EVENT(Eid) ON DELETE CASCADE
);

-- ROLE Table
CREATE TABLE ROLE (
    id SERIAL,
    Rid INTEGER PRIMARY KEY,
    Rname VARCHAR(25),
    description TEXT
);

-- EVENT Table
CREATE TABLE EVENT (
    id SERIAL,
    Eid INTEGER PRIMARY KEY,
    Date DATE,
    Ename VARCHAR(20),
    Type VARCHAR(20)
);

-- COLLEGE Table
CREATE TABLE COLLEGE (
    id SERIAL,
    Cid INTEGER PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Location TEXT,
    UNIQUE(Cid,Name)
);

-- PARTICIPANT Table
CREATE TABLE PARTICIPANT (
    id SERIAL,
    Pid INTEGER PRIMARY KEY,
    Pname VARCHAR(50) NOT NULL,
    cid INTEGER REFERENCES COLLEGE(Cid) ON DELETE CASCADE,
    eid INTEGER REFERENCES EVENT(Eid) ON DELETE CASCADE
);

-- VOLUNTEER Table
CREATE TABLE VOLUNTEER (
    id SERIAL,
    Roll CHAR(10) PRIMARY KEY,
    eid INTEGER REFERENCES EVENT(Eid) ON DELETE CASCADE,
    pid INTEGER REFERENCES PARTICIPANT(Pid) ON DELETE CASCADE
);

-- HAS_EVENT_PARTICIPANT Table
CREATE TABLE EVENT_PARTICIPANT (
    id SERIAL,
    eid INTEGER REFERENCES EVENT(Eid) ON DELETE CASCADE,
    pid INTEGER REFERENCES PARTICIPANT(Pid)ON DELETE CASCADE
);


INSERT INTO EVENT (Eid, Date, Ename, Type) VALUES
(1233, '2024-01-26', 'Megaevent', 'Concert'),
(2342, '2024-01-26', 'TechTalk', 'Seminar'),
(3121, '2024-01-27', 'Workshop', 'Workshop'),
(4212, '2024-01-28', 'CulturalFest', 'Festival'),
(5343, '2024-01-28', 'SportsMeet', 'Sports');

INSERT INTO EVENT (Eid,Ename, Type) VALUES
(1000, 'NULL', 'NULL');

INSERT INTO COLLEGE (Cid, Name, Location) VALUES
(1, 'IITB','Mumbai'),
(2, 'IITD','Delhi'),
(3, 'IITKGP','Kharagpur'),
(4, 'IITM','Madras'),
(5, 'IITR','Rorkee');

INSERT INTO ROLE (Rid,Rname,description) VALUES
(1, 'Secretary', 'Coordinates all teams'),
(2, 'Coordinator', 'Coordinates events'),
(3, 'Volunteer', 'Assists in various tasks'),
(4, 'Treasurer', 'Manages finances'),
(5, 'Speaker', 'Delivers talks'),
(6, 'NULL', 'NULL');

INSERT INTO STUDENT (Roll, Name, Dept, rid, eid) VALUES
('21CS10099', 'Adam', 'CSE', 1, 1233),
('21EC10001', 'Eve', 'ECE', 2, 1233),
('20ME10066', 'Shakespere', 'ME', 4, 2342),
('22MA10008', 'Drake', 'MA', 3, 3121),
('23HS10022', 'Tony Stark', 'HA', 2, 4212),
('22CH10021', 'Modi', 'CH', 5, 1000),
('20EE10021', 'Virat', 'EE', 6, 1000);

INSERT INTO PARTICIPANT (Pid, Pname, Cid, Eid) VALUES
(1, 'Leonardo da Vinci', 1, 1233),
(2, 'Michael Jackson', 2, 2342),
(3, 'Usain Bolt', 3, 1233),
(4, 'Alan Turing', 4, 3121),
(5, 'Albert Einstein', 5, 3121),
(6, 'Ronaldo', 1, 3121),
(7, 'Messi', 1, 2342);

INSERT INTO VOLUNTEER (Roll, Eid, Pid) VALUES
('21CS10099', 1233, 1),
('21EC10001', 1233, 2),
('20ME10066', 2342, 3),
('22MA10008', 3121, 4),
('23HS10022', 1233, 5);

INSERT INTO EVENT_PARTICIPANT (EID, PID) VALUES
(1233, 1),
(1233, 2),
(2342, 3),
(3121, 4),
(1233, 5);



--Certainly! Let's structure the requirements into a more organized format. I'll define the relational schema, including table definitions, attribute definitions, and attribute data types. Then, I'll create SQL commands for table creation and insertion of sample records. Finally, I'll provide examples of SQL queries for the specified conditions.

--4. SQL Queries:
--(i) Roll number and name of all the students who are managing the “Megaevent”:
SELECT S.Roll, S.Name
FROM STUDENT S
JOIN EVENT E ON S.Eid = E.Eid
WHERE E.Ename = 'Megaevent';

--(ii) Roll number and name of all the students who are managing “Megaevent” as a “Secretary”:
SELECT S.Roll, S.Name
FROM STUDENT S
JOIN ROLE R ON S.Rid = R.Rid
JOIN EVENT E ON S.Eid = E.Eid
WHERE R.Rname = 'Secretary' AND E.Ename = 'Megaevent';

--(iii) Name of all the participants from the college “IITB” in “Megaevent”:
SELECT P.PName
FROM PARTICIPANT P
JOIN COLLEGE C ON P.Cid = C.Cid
JOIN EVENT E ON P.Eid = E.Eid
WHERE C.Name = 'IITB' AND E.EName = 'Megaevent';

--(iv) Name of all the colleges who have at least one participant in “Megaevent”:
SELECT DISTINCT C.Name
FROM COLLEGE C
JOIN PARTICIPANT P ON C.Cid = P.Cid
JOIN EVENT E ON P.Eid = E.Eid
WHERE E.Ename = 'Megaevent';

--(v) Name of all the events which are managed by a “Secretary”:
SELECT DISTINCT E.ENAME
FROM EVENT E
JOIN STUDENT S ON E.Eid = S.Eid
JOIN ROLE R ON S.Rid = R.Rid
WHERE R.Rname = 'Secretary';

--(vi) Name of all the “CSE” department student volunteers of “Megaevent”:
SELECT S.NAME
FROM STUDENT S
JOIN VOLUNTEER V ON S.ROLL = V.ROLL
JOIN EVENT E ON V.EID = E.EID
WHERE S.DEPT = 'CSE' AND E.ENAME = 'Megaevent';

--(vii) Name of all the events which have at least one volunteer from “CSE”:
SELECT DISTINCT E.ENAME
FROM EVENT E
JOIN VOLUNTEER V ON E.EID = V.EID
JOIN STUDENT S ON V.ROLL = S.ROLL
WHERE S.DEPT = 'CSE';

--(viii) Name of the college with the largest number of participants in “Megaevent”:
SELECT C.NAME
FROM COLLEGE C
JOIN PARTICIPANT P ON C.CID = P.CID
JOIN EVENT E ON P.EID = E.EID
WHERE E.ENAME = 'Megaevent'
GROUP BY C.NAME
ORDER BY COUNT(*) DESC
LIMIT 1;

--(ix) Name of the college with the largest number of participants overall:
SELECT C.NAME
FROM COLLEGE C
JOIN PARTICIPANT P ON C.CID = P.CID
GROUP BY C.NAME
ORDER BY COUNT(*) DESC
LIMIT 1;

--(x) Name of the department with the largest number of volunteers in all the events which have at least one participant from “IITB”:
SELECT S.DEPT
FROM STUDENT S
JOIN VOLUNTEER V ON S.ROLL = V.ROLL
JOIN EVENT E ON V.EID = E.EID
JOIN PARTICIPANT P ON E.EID = P.EID
JOIN COLLEGE C ON P.CID = C.CID
WHERE C.NAME = 'IITB'
GROUP BY S.DEPT
ORDER BY COUNT(DISTINCT V.ROLL) DESC
LIMIT 1;
