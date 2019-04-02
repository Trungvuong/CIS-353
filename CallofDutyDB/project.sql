SPOOL project.out
SET ECHO ON
/*
CIS 353 Section 01- Call of Duty Tournament Database Design Project
Team 03
Trungvuong Pham
Carson Uecker-Herman
Nate Wichman
Atone Joryman
*/
--
-- Drop any pre-existing tables if present.
--
DROP TABLE Team CASCADE CONSTRAINTS;
DROP TABLE Player CASCADE CONSTRAINTS;
DROP TABLE Weapons CASCADE CONSTRAINTS;
DROP TABLE Venue CASCADE CONSTRAINTS;
DROP TABLE Match CASCADE CONSTRAINTS;
DROP TABLE Weapon_Accessories CASCADE CONSTRAINTS;
DROP TABLE Uses CASCADE CONSTRAINTS;
--
/*
< The SQL/DDL code that creates your schema >
In the DDL, every IC must have a unique name; e.g. IC5, IC10, IC15, etc.
*/
--
-- Create new tables
-- -----------------------------------------------------------------------------
CREATE TABLE Team (
  tID	INTEGER PRIMARY KEY NOT NULL,
  tName CHAR(20) NOT NULL,
  numMembers INTEGER,
  seed INTEGER NOT NULL,
-- tIC1: The team ID and team name is unique
CONSTRAINT tIC1 UNIQUE(tID, tName),
-- tIC2: The team must have between 4 and 6 players
CONSTRAINT tIC2 CHECK (numMembers >= 4 AND numMembers <= 6),
-- tIC3: There are only 6 teams participating in this tournament
CONSTRAINT tIC3 CHECK(tID >= 1 AND tID <= 6),
-- tIC4: Seed references the team ID
CONSTRAINT tIC4 FOREIGN KEY (seed) REFERENCES Team(tID)
            ON DELETE CASCADE
            DEFERRABLE INITIALLY DEFERRED
);
--
-- -----------------------------------------------------------------------------
CREATE TABLE Player (
  pID	CHAR(25) NOT NULL,
  pTeam CHAR(20) NOT NULL,
  pAge	CHAR(5),
  pName CHAR(20) NOT NULL,
  tID  INTEGER NOT NULL,
  role CHAR(15),
--
-- pIC1: Player id is unique
CONSTRAINT pIC1 PRIMARY KEY(pID, pTeam),
-- pIC2: No two players can have the same name and be on the same team
CONSTRAINT pIC2 UNIQUE(pName, pTeam),
-- pIC3: pTeam is a foreign key to tName in the Team tables
CONSTRAINT pIC3 FOREIGN KEY (tID) REFERENCES Team(tID)
            ON DELETE CASCADE
			      DEFERRABLE INITIALLY DEFERRED
);
--
-- -----------------------------------------------------------------------------
CREATE TABLE Weapons (
  wName	CHAR(15) PRIMARY KEY NOT NULL,
  wType CHAR(16),
  accessories CHAR(50),
--
-- wIC1: Weapon type and weapon names are all unique
CONSTRAINT wIC1 UNIQUE(wName, wType),
-- wIC2: Checks for valid gun types
CONSTRAINT wIC2 CHECK(wType IN('Assault Rifle', 'Submachine Gun', 'Sniper Rifle'))
);
--
-- -----------------------------------------------------------------------------
CREATE TABLE Venue (
  vID	INTEGER NOT NULL PRIMARY KEY,
  location  CHAR(25) NOT NULL,
  capacity  INTEGER,
--
-- vIC1: Check for valid venue locations for matches
CONSTRAINT vIC1 CHECK(location IN('Anaheim', 'Las Vegas', 'Philadelphia', 'New York City')),
-- vIC2: 2 attributes 1 row: Checks the capacity of New York City to be <= 30000
CONSTRAINT vIC2 CHECK(location != 'New York City' OR capacity >= 30000)
);
--
-- -----------------------------------------------------------------------------
CREATE TABLE Match (
  tID1 INTEGER,
  tID2 INTEGER,
  mDate	DATE,
  mTime CHAR(10),
  attendance INTEGER,
  score1 INTEGER,
  score2 INTEGER,
  vID INTEGER NOT NULL,
--
-- mIC1:The team Ids of two teams and the date of match are unique
CONSTRAINT mIC1 PRIMARY KEY(tID1, tID2, mDate),
-- mIC2: vID references the venue ID from the Venue table
CONSTRAINT mIC2 FOREIGN KEY (vID) REFERENCES Venue(vID)
            ON DELETE CASCADE
            DEFERRABLE INITIALLY DEFERRED,
-- mIC3: Check that when the vID is 101 the attendance is at capacity
CONSTRAINT mIC3 CHECK(NOT(vID = 101 AND attendance >= 15000))
);
--
-- -----------------------------------------------------------------------------
CREATE TABLE Weapon_Accessories (
  wName	CHAR(15),
  accessories	CHAR(25),
  wNum  INTEGER,
--
--aIC1: Weapon name and accessories are unique
CONSTRAINT aIC1 PRIMARY KEY(wName, accessories),
-- aIC2: Only 28 confirmed weapons usable in Tournament
CONSTRAINT aIC2 CHECK(wNum >= 1 AND wNum <= 28)
);
--
-- -----------------------------------------------------------------------------
CREATE TABLE USES (
  pID CHAR(25) NOT NULL,
  wName	CHAR(15),
  wNum INTEGER,
--
-- uIC1: The player ID and weapon name are unique
CONSTRAINT uIC1 UNIQUE(pID, wName)
);
--
SET FEEDBACK OFF
--
/*  The INSERT statements that populate the table
*/
--
-- Team Table inserts
INSERT INTO Team VALUES (1, 'Team Awesome', 4, 4);
INSERT INTO Team VALUES (2, 'Ultra Instinct', 4, 6);
INSERT INTO Team VALUES (3, 'Children of God', 5, 5);
INSERT INTO Team VALUES (4, 'TrickStars', 6, 1);
INSERT INTO Team VALUES (5, 'UniqueGaming', 4, 2);
INSERT INTO Team VALUES (6, 'BitterGaming', 4, 3);
--
-- Player Table inserts
INSERT INTO Player VALUES('HufflePuff', 'Team Awesome', 22, 'Trevor James', 1, 'Captain');
INSERT INTO Player VALUES('AznPersuasion', 'Team Awesome', 20, 'Kevin Lin', 1, 'Support');
INSERT INTO Player VALUES('NoobSlayer', 'Team Awesome', 19, 'Josh Front', 1, 'Slayer');
INSERT INTO Player VALUES('DoughBoy', 'Team Awesome', 18, 'Micah Danah', 1, 'Objective');
INSERT INTO Player VALUES('SSGodGoku', 'Ultra Instinct', 22, 'Akira Toriyama', 2, 'Captain');
INSERT INTO Player VALUES('SSGodVegeta', 'Ultra Instinct', 19, 'Dan Shisuki', 2, 'Objective');
INSERT INTO Player VALUES('LordBeerus', 'Ultra Instinct', 18, 'Sam Sizuki', 2, 'Support');
INSERT INTO Player VALUES('WhisMaster', 'Ultra Instinct', 19, 'Kyle Takanawa', 2, 'Slayer');
INSERT INTO Player VALUES('Crimson_Chin', 'Children of God', 21, 'Carlos Davila', 3, 'Coach');
INSERT INTO Player VALUES('BasedGod', 'Children Of God', 19, 'Bob Gordon', 3, 'Captain');
INSERT INTO Player VALUES('ReignGod', 'Children Of God', 20, 'Karl Thornapple', 3, 'Slayer');
INSERT INTO Player VALUES('PceMaker', 'Children Of God', 19, 'Casey Jimenez', 3, 'Objective');
INSERT INTO Player VALUES('KillMonger', 'Children Of God', 22, 'Chris Smith', 3,  'Support');
INSERT INTO Player VALUES('RelicStar', 'TrickStars', 25, 'David Martinez', 4, 'Coach');
INSERT INTO Player VALUES('NightStar', 'TrickStars', 24, 'Gregory Nelson', 4, 'Co-Captain');
INSERT INTO Player VALUES('DeathStar', 'TrickStars', 24, 'Seth Palmer', 4, 'Co-Captain');
INSERT INTO Player VALUES('ReamStar', 'TrickStars', 23, 'Sam Smith', 4, 'Support');
INSERT INTO Player VALUES('MoonStar', 'TrickStars', 22, 'Logan Wreath', 4, 'Objective');
INSERT INTO Player VALUES('GenoStar', 'TrickStars', 19, 'Kevin Garner', 4, 'Slayer');
INSERT INTO Player VALUES('Unique_Epsilon', 'UniqueGaming', 20, 'Conrad Newman', 5, 'Captain');
INSERT INTO Player VALUES('Unique_Merciless', 'UniqueGaming', 21, 'Joe Puma', 5, 'Slayer');
INSERT INTO Player VALUES('Unique_Heartless', 'UniqueGaming', 22, 'Trung Pham', 5, 'Objective');
INSERT INTO Player VALUES('Unique_Sorrow', 'UniqueGaming', 21, 'Thao Phan', 5, 'Slayer');
INSERT INTO Player VALUES('BitterTetra', 'BitterGaming', 18, 'Edward Elric', 6, 'Captain');
INSERT INTO Player VALUES('Bitter_Vision', 'BitterGaming', 20, 'Brandon Nguyen', 6, 'Slayer');
INSERT INTO Player VALUES('BitterGhost', 'BitterGaming', 22, 'Jubentino Cifuentes', 6, 'Objective');
INSERT INTO Player VALUES('BitterSweet', 'BitterGaming', 23, 'Joshua Norton', 6, 'Support');
--
-- Weapons Table Insert
INSERT INTO Weapons VALUES('M1-Garand', 'Assault Rifle', 'Red Dot Sight, Quickdraw, and Stock');
INSERT INTO Weapons VALUES('BAR', 'Assault Rifle', 'Extended Mag, Foregrip, and Stock');
INSERT INTO Weapons VALUES('M1A1 Carbine', 'Assault Rifle', 'Silencer, Foregrip, and Extended Mag');
INSERT INTO Weapons VALUES('FG-42', 'Assault Rifle', 'Red Dot Sight, Bayonet, and Quickdraw ');
INSERT INTO Weapons VALUES('Grease Gun', 'Submachine Gun', 'Red Dot Sight and Stock');
INSERT INTO Weapons VALUES('PPSH-41', 'Submachine Gun', 'Quickdraw, Foregrip, and Stock');
INSERT INTO Weapons VALUES('Type 100', 'Submachine Gun', 'Quickdraw, Silencer, and Foregrip');
INSERT INTO Weapons VALUES('MP-40', 'Submachine Gun', 'Extended Mag, High Caliber Bullets, and Stock');
INSERT INTO Weapons VALUES('Lee Enfield', 'Sniper Rifle', '4x Optic and Advanced Rifling');
INSERT INTO Weapons VALUES('M1903', 'Sniper Rifle', '6x Optic and Advanced Rifling');
INSERT INTO Weapons VALUES('Kar98k', 'Sniper Rifle', '4x Optic');
--
-- Venue Table inserts
INSERT INTO Venue VALUES(101, 'Anaheim', 15000);
INSERT INTO Venue VALUES(102, 'Las Vegas', 20000);
INSERT INTO Venue VALUES(103, 'Philadelphia', 25000);
INSERT INTO Venue VALUES(104, 'New York City', 30000);
--
-- Match Table inserts
INSERT INTO Match VALUES(1, 2, '07-APR-18', '10:00am', 10000, 2, 4, 101);
INSERT INTO Match VALUES(3, 4, '08-APR-18', '12:00pm', 12000, 1, 4, 101);
INSERT INTO Match VALUES(5, 6, '10-APR-18', '12:00pm', 17000, 4, 3, 102);
INSERT INTO Match VALUES(2, 4, '11-APR-18', '12:00pm', 23000, 4, 0, 103);
INSERT INTO Match VALUES(2, 5, '12-APR-18', '5:00pm', 30000, 4, 3, 104);
--
-- Weapon_Accessories inserts
INSERT INTO Weapon_Accessories VALUES('M1-Garand', 'Red Dot Sight', 1);
INSERT INTO Weapon_Accessories VALUES('M1-Garand', 'Quickdraw', 2);
INSERT INTO Weapon_Accessories VALUES('M1-Garand', 'Stock', 3);
INSERT INTO Weapon_Accessories VALUES('BAR', 'Extended Mag', 4);
INSERT INTO Weapon_Accessories VALUES('BAR', 'Foregrip', 5);
INSERT INTO Weapon_Accessories VALUES('BAR', 'Stock', 6);
INSERT INTO Weapon_Accessories VALUES('M1A1 Carbine', 'Silencer, Foregrip', 7);
INSERT INTO Weapon_Accessories VALUES('M1A1 Carbine', 'Foregrip', 8);
INSERT INTO Weapon_Accessories VALUES('M1A1 Carbine', 'Extended Mag', 9);
INSERT INTO Weapon_Accessories VALUES('FG-42', 'Red Dot Sight', 10);
INSERT INTO Weapon_Accessories VALUES('FG-42', 'Bayonet', 11);
INSERT INTO Weapon_Accessories VALUES('FG-42', 'Quickdraw', 12);
INSERT INTO Weapon_Accessories VALUES('Grease Gun', 'Red Dot Sight', 13);
INSERT INTO Weapon_Accessories VALUES('Grease Gun', 'Stock', 14);
INSERT INTO Weapon_Accessories VALUES('PPSH-41', 'Quickdraw', 15);
INSERT INTO Weapon_Accessories VALUES('PPSH-41', 'Foregrip', 16);
INSERT INTO Weapon_Accessories VALUES('PPSH-41', 'Stock', 17);
INSERT INTO Weapon_Accessories VALUES('Type 100', 'Quickdraw', 18);
INSERT INTO Weapon_Accessories VALUES('Type 100', 'Silencer', 19);
INSERT INTO Weapon_Accessories VALUES('Type 100', 'Foregrip', 20);
INSERT INTO Weapon_Accessories VALUES('MP-40', 'Extended Mag', 21);
INSERT INTO Weapon_Accessories VALUES('MP-40', 'High Caliber Bullets', 22);
INSERT INTO Weapon_Accessories VALUES('MP-40', 'Stock', 23);
INSERT INTO Weapon_Accessories VALUES('Lee Enfield', '4x Optic', 24);
INSERT INTO Weapon_Accessories VALUES('Lee Enfield', 'Advanced Rifling', 25);
INSERT INTO Weapon_Accessories VALUES('M1903', '6x Optic', 26);
INSERT INTO Weapon_Accessories VALUES('M1903', 'Advanced Rifling', 27);
INSERT INTO Weapon_Accessories VALUES('Kar98k', '4x Optic', 28);
--
-- Uses Table inserts
INSERT INTO Uses VALUES('Hufflepuff', 'Type 100', 19);
INSERT INTO Uses VALUES('AznPersuasion', 'PPSH-41', 17);
INSERT INTO Uses VALUES('NoobSlayer', 'BAR', 6);
INSERT INTO Uses VALUES('DoughBoy', 'BAR', 5);
INSERT INTO Uses VALUES('SSGodGoku', 'FG-42', 11);
INSERT INTO Uses VALUES('SSGodVegeta', 'FG-42', 10);
INSERT INTO Uses VALUES('LordBeerus', 'Lee Enfield', 24);
INSERT INTO Uses VALUES('WhisMaster', 'M1903', 27);
INSERT INTO Uses VALUES('Crimson_Chin', 'Type 100', 20);
INSERT INTO Uses VALUES('BasedGod', 'MP-40', 23);
INSERT INTO Uses VALUES('ReignGod', 'Type 100', 18);
INSERT INTO Uses VALUES('PceMaker', 'PPSH-41', 15);
INSERT INTO Uses VALUES('KillMonger', 'M1A1 Carbine', 9);
INSERT INTO Uses VALUES('RelicStar', 'MP-40', 21);
INSERT INTO Uses VALUES('NightStar', 'PPSH-41', 16);
INSERT INTO Uses VALUES('DeathStar', 'PPSH-41', 16);
INSERT INTO Uses VALUES('ReamStar', 'MP-40', 22);
INSERT INTO Uses VALUES('MoonStar', 'BAR', 4);
INSERT INTO Uses VALUES('GenoStar', 'M1-Garand', 3);
INSERT INTO Uses VALUES('Unique_Epsilon', 'M1-Garand', 2);
INSERT INTO Uses VALUES('Unique_Merciless', 'M1-Garand', 1);
INSERT INTO Uses VALUES('Unique_Heartless', 'M1A1 Carbine', 7);
INSERT INTO Uses VALUES('Unique_Sorrow', 'Grease Gun', 14);
INSERT INTO Uses VALUES('BitterTetra', 'Type 100', 18);
INSERT INTO Uses VALUES('Bitter_Vision', 'M1903', 26);
INSERT INTO Uses VALUES('BitterGhost', 'Lee Enfield', 25);
INSERT INTO Uses VALUES('BitterSweet', 'Kar98k', 28);
--
SET FEEDBACK ON
COMMIT;
--
/* One query (per table) of the form: SELECT * FROM table;
in order to print out your database
*/
SELECT * FROM Team;
SELECT * FROM Player;
SELECT * FROM Weapons;
SELECT * FROM Venue;
SELECT * FROM Match;
SELECT * FROM Weapon_Accessories;
SELECT * FROM Uses;
--
/* The SQL queries>. Include the following for each query:
1. A comment line stating the query number and the feature(s) it demonstrates
(e.g. – Q25 – correlated subquery).
2. A comment line stating the query in English.
3. The SQL code for the query.
*/
--
-- QUERY 1: A join involving at least four relations.
-- For every team that has a match in 'New York City', and is the first Team entered,
-- find the team name, player iDs, player names, and roles of player in match
SELECT DISTINCT T.tID, P.pID, P.pAge, P.role
FROM Player P, Venue V, Team T, Match M
WHERE  P.tId = T.tID AND
       T.tID = M.tID1 AND
       M.vID = V.vID AND
       V.location = 'New York City'
ORDER BY T.tID;
--
-- QUERY 2: A self-join
--Finds pairs of players on the same team with the same roles
SELECT DISTINCT P1.pID, P2.pID
FROM Player P1, Player P2
WHERE P1.role = P2.role AND
      P1.pTeam = P2.pTeam AND
      P1.pName < P2.pName;
--
-- QUERY 3: UNION, INTERSECT, and/or MINUS.
--For any team that is in the top 2 seed or hasa coach, find the
-- tId and tName
SELECT T.tID, T.tName
FROM Team T
WHERE T.seed < 3
UNION
SELECT T.tID, T.tName
FROM Team T, Player P
WHERE T.tID = P.tID AND
      P.role = 'Coach';
--
-- QUERY 4: SUM, AVG, MAX, and/or MIN.
--Finds all teams that have more than 4 members on a team
SELECT T.tName, T.numMembers
FROM team T
WHERE T.numMembers > (SELECT AVG(numMembers)
                             FROM team)
ORDER BY T.tName;
--
--QUERY 5: GROUP BY, HAVING, and ORDER BY, all appearing in the same query
--Finds all venues that have more than 1 match scheduled at that location
SELECT V.vID, V.location, count(*) AS "MATCHES SCHEDULED"
FROM Match M, Venue V
WHERE M.vID = V.vID
GROUP BY V.vID, V.location
HAVING count(*) > 1
ORDER BY V.vID;
--
-- QUERY 6: A correlated subquery.
--Find all locations that have at least one match scheduled
SELECT V.vID, V.location
FROM Venue V
WHERE EXISTS (SELECT *
	      FROM Match M
              WHERE V.vID = M.vID)
ORDER BY V.vID;
--
-- QUERY 7: A non-correlated subquery.
--Find the team ID and name of a team who did not enter a match as the tID1
SELECT T.tID, T.tName
FROM Team T
WHERE T.tID NOT IN(SELECT M.tID1
	      FROM Match M);
--
-- QUERY 8: A relational DIVISION query.
--Find all players who are on a team that has at least 4 members and has never lost a game as Team 1.
SELECT P.pName, P.tID
FROM Player P
WHERE NOT EXISTS(
	(SELECT T.tID
	 FROM Team T
	 WHERE P.pTeam = T.tName AND
	       T.numMembers >= 4)
	MINUS
	(SELECT M.tID1
	 FROM Match M
         WHERE M.score1 > M.score2));
--
-- QUERY 9: An outer join query
-- Find the Venue ID, location, match date, and time for every possible match
SELECT V.vID, V.location, M.mDate, M.mTime
FROM Venue V LEFT OUTER JOIN Match M ON V.vID = M.vID;
--
-- QUERY 10: Rank query
--Finds the rank (not dense) of each player based on attendance.
-- HINT (Should be 1)
SELECT RANK(30000) WITHIN GROUP
(ORDER BY attendance DESC)
FROM Match;
--
-- QUERY 11: A Top-N query
--Finds the three oldest players by descending order.
SELECT pName, pAge
FROM (SELECT * FROM Player ORDER BY pAge DESC)
WHERE ROWNUM < 4;
--
/*The insert/delete/update statements to test the enforcement of ICs >
Include the following items for every IC that you test (Important: see the next section titled
“Submit a final report” regarding which ICs to test).
1. A comment line stating: Testing: < IC name>
2.  A SQL INSERT, DELETE, or UPDATE that will test the IC.
*/
--
-- Testing constraint pIC1
INSERT INTO Player VALUES('HufflePuff', 'Team Awesome', 24, 'Trevor James', 1, 'Captain');
-- Testing constraint mIC3
INSERT INTO Match VALUES(1, 2, '07-APR-18', '10:00am', 17000, 2, 4, 101);
-- Testing constraint mIC2
DELETE FROM Venue WHERE vID = 101;
SELECT vID FROM Match;
SELECT vID FROM Venue;
-- Testing constraint tIC3
INSERT INTO Team VALUES (7, 'DreamTeam', 8, 7);
--
COMMIT;
SPOOL OFF
