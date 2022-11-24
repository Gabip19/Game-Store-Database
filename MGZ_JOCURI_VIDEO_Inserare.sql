/*
	INSEREAZA VALORI IN TABELE
*/
USE MAGAZIN_DE_JOCURI
GO

INSERT INTO CATEGORII VALUES
	('Aventura'),
	('Casual'),
	('Indie'),
	('Curse'),
	('RPG'),
	('Simulator'),
	('Sport'),
	('Strategie'),
	('Puzzle'),
	('Survival'),
	('Horror'),
	('Sci-Fi'),
	('FPS')


INSERT INTO RESTRICTII_VARSTA VALUES
	('PEGI 3'),
	('PEGI 7'),
	('PEGI 12'),
	('PEGI 16'),
	('PEGI 18')


INSERT INTO DEZVOLTATORI VALUES
	('Mojang', '2009-05-01', 5),
	('Microsoft', '1975-04-04', 122),
	('Epic Games', '1991-01-15', 42),
	('Rockstar Games', '1998-12-01', 86),
	('Electronic Arts', '1982-5-27', 200),
	('Riot Games', '2006-09-01', 17),
	('Blizzard Entertainment', '1991-02-08', 19),
	('Activision', '1997-10-01', 103),
	('Valve', '1996-08-24', 23),
	('Ubisoft', '1986-03-28', 31),
	('Nexon', '2002-12-18', 52),
	('Psyonix', '2001-01-01', 5),
	('Sony Interactive', '1993-11-16', 90)


INSERT INTO PLATFORME VALUES
	('Windows'),
	('MacOS'),
	('Xbox 360'),
	('Xbox One'),
	('Xbox X/S'),
	('PlayStation 3'),
	('PlayStation 4'),
	('PlayStation 5'),
	('Nintendo Switch'),
	('Mobile')


INSERT INTO JOCURI VALUES
	('Minecraft', 'single/multiplayer', 'offline/online', '2011-11-18', 1, 10, 1),
	('World of Warcraft', 'MMO', 'online', '2004-11-23', 7, 5, 2),
	('Rocket League', 'multiplayer', 'online', '2015-07-07', 12, 2, 1),
	('Apex Legends', 'multiplayer', 'online', '2020-11-05', 5, 13, 3),
	('FIFA 22', 'single/multiplayer', 'online', '2021-10-1', 5, 7, 1),
	('FIFA 23', 'single/multiplayer', 'online', '2022-09-30', 5, 7, 1),
	('Valorant', 'multiplayer', 'online', '2020-06-02', 6, 13, 4),
	('League of Legends', 'multiplayer', 'online', '2013-03-01', 6, 8, 2),
	('Forza Horizon 5', 'single/multiplayer', 'offline/online', '2021-11-09', 2, 6, 3),
	('The Crew 2', 'single/multiplayer', 'offline/online', '2018-06-29', 10, 4, 1),
	('Counter-Strike: Global Offensive', 'single/multiplayer', 'offline/online', '', 9, 13, 4),
	('Call of Duty: Warzone', 'single/multiplayer', 'offline/online', '2020-03-10', 8, 13, 4),
	('Tom Clancys Rainbow Six Siege', 'multiplayer', 'online', '2015-12-01', 10, 13, 4),
	('Grand Theft Auto V', 'single/multiplayer', 'offline/online', '2015-04-14', 4, 1, 4),
	('Grand Theft Auto IV', 'single/multiplayer', 'offline/online', '2008-12-03', 4, 1, 4),
	('Fall Guys', 'multiplayer', 'online', '2020-08-04', 3, 2, 1),
	('Overwatch', 'multiplayer', 'online', '2016-05-24', 7, 13, 3),
	('Team Fortress 2', 'multiplayer', 'online', '2007-10-10', 9, 13, 4),
	('Microsoft Flying Simulator', 'singleplayer', 'offline/online', '2021-07-27', 2, 6, 1),
	('Age of Empires IV', 'single', 'offline', '2021-10-28', 8, 8, 2),
	('Sid Meier�s Civilization VI', 'single', 'offline', '2016-10-21', 8, 8, 2),
	('The Witcher 3: Wild Hunt', 'single', 'offline', '2015-05-18', 13, 5, 4),
	('The Sims 4', 'singleplayer', 'offline', '2014-09-02', 5, 6, 1),
	('Left 4 Dead 2', 'COOP 4', 'online', '2019-11-17', 9, 1, 4),
	('The Forest', 'single/multiplayer', 'offline/online', '2018-04-30', 7, 10, 5),
	('Dying Light', 'singleplayer', 'offline', '2015-01-26', 13, 11, 5),
	('Red Dead Redemption 2', 'singleplayer', 'offline', '2019-12-05', 4, 1, 5),
	('Fortnite', 'multiplayer', 'online', '2018-12-06', 3, 13, 2),
	('Crazyracing Kartrider', 'multiplayer', 'online', '2006-12-19', 11, 4, 1),
	('Wolfenstein: Youngblood', 'singleplayer', 'offline', '2019-07-25', 13, 13, 5),
	('Raft', 'COOP 4', 'online', '2022-06-20', 10, 10, 3),
	('God of War 4', 'singleplayer', 'offline', '2018-04-20', 13, 1, 4),
	('Uncharted 4', 'singleplayer', 'offline', '2016-05-10', 13, 1, 4)


INSERT INTO CLIENTI VALUES
	('5125714839421', 'Marin', 'Emil', '1999-03-08', 'Masculin'),
	('5520897994431', 'Doroftei', 'Adrian', '2002-01-12', 'Masculin'),
	('5325902128765', 'Filip', 'Natalia Mihaela', '2010-06-27', 'Feminin'),
	('5647429083123', 'Gavril', 'Lucian', '1998-10-19', 'Masculin'),
	('5289073581532', 'Stan', 'Elisabeta', '2009-05-08', 'Feminin'),
	('5604807561461', 'Apostol', 'Mihai', '1995-10-23', 'Masculin'),
	('5291733717582', 'Dragos', 'Roxana', '1995-05-11', 'Feminin'),
	('5797530167931', 'Mitica', 'Mihail', '2001-04-20', 'Masculin'),
	('5129623672681', 'Filimon', 'Alexandra', '1993-06-17', 'Feminin'),
	('5878018910256', 'Valeriu', 'Andrei', '2007-07-29', 'Masculin')


INSERT INTO ANGAJATI VALUES
	('5707699078421', 'Sara', 'Maria', '1997-07-31', 'Manager'),
	('5234469880612', 'Horia', 'Cristian', '2002-03-18', 'Casier'),
	('5232455979001', 'Hanganu', 'Ionut Matei', '2000-07-27', 'Casier'),
	('5920909432521', 'Simon', 'Flavian', '1992-08-22', 'Logistica')


INSERT INTO JOCURI_PLATFORME(Jid, Pid) VALUES
	(1, 1),
	(1, 2),
	(1, 3),
	(1, 4),
	(1, 6),
	(1, 9),
	(1, 10),
	(2, 1),
	(2, 2),
	(3, 1),
	(3, 2),
	(3, 4),
	(3, 7),
	(3, 9),
	(3, 10),
	(4, 1),
	(4, 5),
	(4, 8),
	(4, 10),
	(5, 1),
	(5, 9),
	(5, 7),
	(5, 8),
	(5, 4),
	(5, 6),
	(6, 1),
	(6, 4),
	(6, 7),
	(7, 1),
	(7, 2),
	(8, 1),
	(8, 2),
	(9, 1),
	(9, 4),
	(9, 5),
	(10, 1),
	(10, 2),
	(11, 1),
	(11, 2),
	(12, 1),
	(12, 4),
	(12, 5),
	(12, 7),
	(12, 8),
	(13, 1),
	(13, 2),
	(14, 1),
	(14, 2),
	(14, 4),
	(14, 7),
	(15, 1),
	(15, 2),
	(15, 4),
	(15, 5),
	(15, 7),
	(15, 8),
	(16, 1),
	(16, 4),
	(16, 7),
	(16, 9),
	(17, 1),
	(18, 1),
	(19, 1),
	(19, 5),
	(20, 1),
	(20, 2),
	(20, 10),
	(21, 1),
	(21, 2),
	(21, 10),
	(22, 1),
	(22, 4),
	(22, 5),
	(22, 7),
	(22, 8),
	(22, 9),
	(23, 1),
	(23, 2),
	(23, 9),
	(23, 10),
	(24, 1),
	(25, 1),
	(26, 1),
	(26, 2),
	(26, 4),
	(26, 5),
	(26, 7),
	(26, 8),
	(26, 9),
	(27, 1),
	(27, 4),
	(27, 7),
	(28, 1),
	(28, 2),
	(28, 4),
	(28, 5),
	(28, 7),
	(28, 8),
	(28, 9),
	(28, 10),
	(29, 1),
	(29, 2),
	(29, 9),
	(29, 10),
	(30, 1),
	(30, 4),
	(30, 7),
	(30, 9),
	(31, 1),
	(32, 1),
	(32, 7),
	(33, 7),
	(33, 8)


INSERT INTO TRANZACTII VALUES
	(10, 2, '2022-03-07 12:40:00'),
	(3, 4, '2022-05-12 13:15:00'),
	(3, 3, '2022-05-25 14:20:00'),
	(7, 3, '2022-05-25 14:46:00'),
	(10, 1, '2022-05-25 15:04:00'),
	(1, 4, '2022-07-04 10:30:00'),
	(7, 4, '2022-07-04 12:31:00'),
	(2, 1, '2022-07-27 13:20:00'),
	(2, 2, '2022-08-22 11:26:00'),
	(4, 3, '2022-08-22 12:20:00'),
	(6, 2, '2022-08-22 12:45:00'),
	(4, 2, '2022-08-22 15:36:00'),
	(9, 4, '2022-08-22 15:40:00'),
	(5, 1, '2022-09-20 09:11:00'),
	(4, 3, '2022-10-27 09:54:00')


INSERT INTO PACHETE_JOCURI VALUES
	(1, 7),
	(2, 11),
	(2, 18),
	(2, 1),
	(3, 14),
	(4, 12),
	(4, 10),
	(4, 31),
	(4, 24),
	(5, 29),
	(5, 7),
	(6, 26),
	(6, 30),
	(7, 5),
	(8, 20),
	(9, 23),
	(9, 14),
	(9, 26),
	(9, 1),
	(10, 26),
	(10, 21),
	(11, 2),
	(11, 8),
	(11, 33),
	(12, 17),
	(12, 27),
	(13, 17),
	(14, 3),
	(15, 4),
	(15, 23)



SELECT * FROM CATEGORII ORDER BY Cid
SELECT * FROM RESTRICTII_VARSTA ORDER BY Rvid
SELECT * FROM DEZVOLTATORI ORDER BY Did
SELECT * FROM PLATFORME ORDER BY Pid
SELECT * FROM JOCURI ORDER BY Jid
SELECT * FROM JOCURI_PLATFORME
SELECT * FROM CLIENTI ORDER BY Clid
SELECT * FROM ANGAJATI ORDER BY Aid
SELECT * FROM TRANZACTII ORDER BY Tid
SELECT * FROM PACHETE_JOCURI