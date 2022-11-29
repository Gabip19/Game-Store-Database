USE MAGAZIN_DE_JOCURI
GO


SELECT * FROM Tab GO
----- Aleg cele trei tabele pentru teste -----

-- tabela doar cu un PK
INSERT INTO Tables VALUES ('PLATFORME');

-- tabela cu un PK si cel putin un FK
INSERT INTO Tables VALUES ('JOCURI');

-- tabela cu doua PK
INSERT INTO Tables VALUES ('JOCURI_PLATFORME');

SELECT * FROM Tables
GO


----- Creez cele trei view-uri pt tabelele selectate -----

-- pentru un PK
GO
CREATE VIEW VIEW_PLATFORME AS
	SELECT Pid, nume FROM PLATFORME
GO

-- pentru un PK si cel putin un FK
GO
CREATE VIEW VIEW_JOCURI AS
	SELECT J.Jid, J.nume, J.data_aparitie, C.Cid, C.categorie
	FROM JOCURI J
		INNER JOIN CATEGORII C
		ON J.Cid = C.Cid
GO

-- pentru doua PK
GO
CREATE VIEW VIEW_JOCURI_PLATFORME AS
	SELECT P.Pid, P.nume, J.Jid, J.nume AS nume_joc
	FROM PLATFORME P
		INNER JOIN JOCURI_PLATFORME JP
		ON P.Pid = JP.Pid
		INNER JOIN JOCURI J
		ON JP.Jid = J.Jid
	GROUP BY P.nume, P.Pid, J.Jid, J.nume
GO



----- Adaug view-urile in tabel -----

INSERT INTO Views VALUES
	('VIEW_PLATFORME'),
	('VIEW_JOCURI'),
	('VIEW_JOCURI_PLATFORME');
SELECT * FROM Views
GO


----- Adaug testele de efectuat in tabela Tests -----

INSERT INTO Tests VALUES
	('DIV_PLATFORME_10'),
	('DIV_PLATFORME_100'),
	('DIV_PLATFORME_1000'),
	('DIV_JOCURI_10'),
	('DIV_JOCURI_100'),
	('DIV_JOCURI_1000'),
	('DIV_JOCURI_PLATFORME_10'),
	('DIV_JOCURI_PLATFORME_100'),
	('DIV_JOCURI_PLATFORME_1000');
SELECT * FROM Tests
GO


----- Fac legatura intre teste si tabele -----

SELECT * FROM Tables;
SELECT * FROM Tests;
INSERT INTO TestTables VALUES
	-- DIV_PLATFORME_10
	(1, 1, 10, 1),
	(1, 3, 10, 2),
	-- DIV_PLATFORME_100
	(2, 1, 100, 1),
	(2, 3, 100, 2),
	-- DIV_PLATFORME_1000
	(3, 1, 1000, 1),
	(3, 3, 1000, 2),

	-- DIV_JOCURI_10
	(4, 2, 10, 1),
	(4, 3, 10, 2),
	-- DIV_JOCURI_100
	(5, 2, 100, 1),
	(5, 3, 100, 2),
	-- DIV_JOCURI_1000
	(6, 2, 1000, 1),
	(6, 3, 1000, 2),

	-- DIV_JOCURI_PLATFORME_10
	(7, 1, 10, 1),
	(7, 2, 10, 2),
	(7, 3, 10, 3),
	-- DIV_JOCURI_PLATFORME_100
	(8, 1, 100, 1),
	(8, 2, 100, 2),
	(8, 3, 100, 3),
	-- DIV_JOCURI_PLATFORME_1000
	(9, 1, 1000, 1),
	(9, 2, 1000, 2),
	(9, 3, 1000, 3);

SELECT * FROM TestTables;
GO



----- Fac legatura intre teste si view-uri -----

SELECT * FROM Views;
SELECT * FROM Tests;
INSERT INTO TestViews VALUES
	(1, 1),
	(2, 1),
	(3, 1),
	(4, 2),
	(5, 2),
	(6, 2),
	(7, 3),
	(8, 3),
	(9, 3);
SELECT * FROM TestViews;



----- Creez procedurile de inserare -----

-- pentru PLATFORME
GO
CREATE PROCEDURE ins_test_PLATFORME
@NoOfRows INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @nume VARCHAR(30);
	DECLARE @n INT = 0;
	DECLARE @last_id INT = 
		(SELECT MAX(Pid) FROM PLATFORME)

	WHILE @n < @NoOfRows
	BEGIN
		SET @nume = 'Platforma TEST ' + CONVERT(VARCHAR(10), @last_id);
		INSERT INTO PLATFORME VALUES (@nume);
		SET @last_id = @last_id + 1
		SET @n = @n + 1;
	END

	PRINT 'S-au inserat ' + CONVERT(VARCHAR(10), @NoOfRows) + ' valori in PLATFORME.';
END


-- pentru JOCURI
GO
CREATE PROCEDURE ins_test_JOCURI
@NoOfRows INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @nume VARCHAR(30);
	DECLARE @last_id INT = 
		(SELECT MAX(Jid) FROM JOCURI);
	DECLARE @n INT = 0;

	DECLARE @data DATE =
			(CAST(GETDATE() AS DATE))

	DECLARE @fk1 INT;
	DECLARE @fk2 INT;
	DECLARE @fk3 INT;

	WHILE @n < @NoOfRows
	BEGIN
		SET @nume = 'Joc TEST ' + CONVERT(VARCHAR(10), @last_id);
		SET @fk1 = (SELECT TOP 1 Did FROM DEZVOLTATORI ORDER BY NEWID());
		SET @fk2 = (SELECT TOP 1 Cid FROM CATEGORII ORDER BY NEWID());
		SET @fk3 = (SELECT TOP 1 Rvid FROM RESTRICTII_VARSTA ORDER BY NEWID());

		INSERT INTO JOCURI VALUES (@nume, 'multiplayer', 'online', @data, @fk1, @fk2, @fk3);
		
		SET @last_id = @last_id + 1
		SET @n = @n + 1;
	END

	PRINT 'S-au inserat ' + CONVERT(VARCHAR(10), @NoOfRows) + ' valori in JOCURI.';
END


-- pentru JOCURI_PLATFORME
GO
CREATE PROCEDURE ins_test_JOCURI_PLATFORME
@NoOfRows INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @n INT = 0;
	DECLARE @Jid INT;
	DECLARE @Pid INT;

	DECLARE cursorJocuri CURSOR FAST_FORWARD FOR
		SELECT Jid FROM JOCURI WHERE nume LIKE 'Joc TEST %';
	DECLARE cursorPlatforme CURSOR SCROLL FOR
		SELECT Pid FROM PLATFORME WHERE nume LIKE 'Platforma TEST %';

	OPEN cursorJocuri;
	OPEN cursorPlatforme;

	FETCH NEXT FROM cursorJocuri INTO @Jid;
	WHILE (@n < @NoOfRows) AND (@@FETCH_STATUS = 0)
	BEGIN
		FETCH FIRST FROM cursorPlatforme INTO @Pid;
		WHILE (@n < @NoOfRows) AND (@@FETCH_STATUS = 0)
		BEGIN
			INSERT INTO JOCURI_PLATFORME(Jid, Pid) VALUES (@Jid, @Pid);
			SET @n = @n + 1;
			FETCH NEXT FROM cursorPlatforme INTO @Pid;
		END
		FETCH NEXT FROM cursorJocuri INTO @Jid;
	END

	CLOSE cursorJocuri;
	ClOSE cursorPlatforme;
	DEALLOCATE cursorJocuri;
	DEALLOCATE cursorPlatforme;

	PRINT 'S-au inserat ' + CONVERT(VARCHAR(10), @n) + ' valori in JOCURI_PLATFORME.';
END



----- Creez procedurile de stergere -----

-- pentru PLATFORME
GO
CREATE PROCEDURE del_test_PLATFORME
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM PLATFORME
	WHERE nume LIKE 'Platforma TEST %';
	PRINT 'S-au sters ' + CONVERT(VARCHAR(10), @@ROWCOUNT) + ' valori din PLATFORME.';
END


-- pentru JOCURI
GO
CREATE PROCEDURE del_test_JOCURI
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM JOCURI
	WHERE nume LIKE 'Joc TEST %';
	PRINT 'S-au sters ' + CONVERT(VARCHAR(10), @@ROWCOUNT) + ' valori din JOCURI.';
END


-- pentru JOCURI_PLATFORME
GO
CREATE PROCEDURE del_test_JOCURI_PLATFORME
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM JOCURI_PLATFORME;
	PRINT 'S-au sters ' + CONVERT(VARCHAR(10), @@ROWCOUNT) + ' valori din JOCURI_PLATFORME.';
END



SELECT * FROM PLATFORME;
SELECT * FROM JOCURI;
SELECT * FROM JOCURI_PLATFORME;
EXECUTE ins_test_PLATFORME 100;
EXECUTE del_test_PLATFORME;
EXECUTE ins_test_JOCURI 100;
EXECUTE del_test_JOCURI;
EXECUTE ins_test_JOCURI_PLATFORME 50;
EXECUTE del_test_JOCURI_PLATFORME;
GO


----- Creez procedura generala de inserare -----

GO
CREATE PROCEDURE inserare_testgen
@idTest INT
AS
BEGIN
	DECLARE @numeTest NVARCHAR(50) = (SELECT T.Name FROM Tests T WHERE T.TestID = @idTest);
	DECLARE @numeTabela NVARCHAR(50);
	DECLARE @NoOfRows INT;
	DECLARE @procedura NVARCHAR(50);

	DECLARE cursorTab CURSOR FORWARD_ONLY FOR
		SELECT Tab.Name, Test.NoOfRows FROM TestTables Test
		INNER JOIN Tables Tab ON Test.TableID = Tab.TableID
		WHERE Test.TestID = @idTest
		ORDER BY Test.Position;
	OPEN cursorTab;

	FETCH NEXT FROM cursorTab INTO @numeTabela, @NoOfRows;
	WHILE (@numeTest NOT LIKE N'DIV_' + @numeTabela + N'_' + CONVERT(NVARCHAR(10), @NoOfRows)) AND (@@FETCH_STATUS = 0)
	BEGIN
		SET @procedura = N'ins_test_' + @numeTabela;
		EXECUTE @procedura @NoOfRows;
		FETCH NEXT FROM cursorTab INTO @numeTabela, @NoOfRows;
	END

	SET @procedura = N'ins_test_' + @numeTabela;
	EXECUTE @procedura @NoOfRows;

	CLOSE cursorTab;
	DEALLOCATE cursorTab;
END

EXECUTE inserare_testgen 1;



----- Creez procedura generala de stergere -----

GO
CREATE PROCEDURE stergere_testgen
@idTest INT
AS
BEGIN
	DECLARE @numeTest NVARCHAR(50) = (SELECT T.Name FROM Tests T WHERE T.TestID = @idTest);
	DECLARE @numeTabela NVARCHAR(50);
	DECLARE @NoOfRows INT;
	DECLARE @procedura NVARCHAR(50);

	DECLARE cursorTab CURSOR FORWARD_ONLY FOR
		SELECT Tab.Name, Test.NoOfRows FROM TestTables Test
		INNER JOIN Tables Tab ON Test.TableID = Tab.TableID
		WHERE Test.TestID = @idTest
		ORDER BY Test.Position DESC;
	OPEN cursorTab;

	FETCH NEXT FROM cursorTab INTO @numeTabela, @NoOfRows;
	WHILE (@numeTest NOT LIKE N'DIV_' + @numeTabela + N'_' + CONVERT(NVARCHAR(10), @NoOfRows)) AND (@@FETCH_STATUS = 0)
	BEGIN
		SET @procedura = N'del_test_' + @numeTabela;
		EXECUTE @procedura;
		FETCH NEXT FROM cursorTab INTO @numeTabela, @NoOfRows;
	END

	SET @procedura = N'del_test_' + @numeTabela;
	EXECUTE @procedura;

	CLOSE cursorTab;
	DEALLOCATE cursorTab;
END

EXECUTE stergere_testgen 1;
SELECT * FROM PLATFORME;


----- Creez procedura generala pentru view-uri -----

GO
CREATE PROCEDURE view_testgen
@idTest INT
AS
BEGIN
	DECLARE @viewName NVARCHAR(50) = 
		(SELECT V.Name FROM Views V
		INNER JOIN TestViews TV ON TV.ViewID = V.ViewID
		WHERE TV.TestID = @idTest);

	DECLARE @comanda NVARCHAR(55) = 
		N'SELECT * FROM ' + @viewName;
	
	EXECUTE (@comanda);
END

EXECUTE view_testgen 1;



----- Creez procedura de rulare a unui test -----

GO
CREATE PROCEDURE run_test
@idTest INT
AS
BEGIN
	DECLARE @startTime DATETIME;
	DECLARE @interTime DATETIME;
	DECLARE @endTime DATETIME;

	SET @startTime = GETDATE();
	
	EXECUTE stergere_testgen @idTest;
	EXECUTE inserare_testgen @idTest;
	
	SET @interTime = GETDATE();
	
	EXECUTE view_testgen @idTest;

	SET @endTime = GETDATE();

	-- var pt insert
	DECLARE @testName NVARCHAR(50) =
		(SELECT T.Name FROM Tests T WHERE T.TestID = @idTest);
	INSERT INTO TestRuns VALUES (@testName, @startTime, @endTime);

	DECLARE @viewID INT =
		(SELECT V.ViewID FROM Views V
		INNER JOIN TestViews TV ON TV.ViewID = V.ViewID
		WHERE TV.TestID = @idTest);
	DECLARE @tableID INT =
		(SELECT TB.TableID FROM Tests T
		INNER JOIN TestTables TT ON T.TestID = TT.TestID
		INNER JOIN Tables TB ON TB.TableID = TT.TableID
		WHERE T.TestID = @idTest AND 
		T.Name LIKE N'DIV_' + TB.Name + N'_' + CONVERT(NVARCHAR(10), TT.NoOfRows));
	DECLARE @testRunID INT = 
		(SELECT TOP 1 T.TestRunID FROM TestRuns T
		WHERE T.Description = @testName
		ORDER BY T.TestRunID DESC);
	
	INSERT INTO TestRunTables VALUES (@testRunID, @tableID, @startTime, @interTime);
	INSERT INTO TestRunViews VALUES (@testRunID, @viewID, @interTime, @endTime);

	PRINT CHAR(10) + '---> TEST COMPLETAT CU SUCCES IN ' + 
		 CONVERT(VARCHAR(10), DATEDIFF(millisecond, @startTime, @endTime)) +
		 ' milisecunde. <---'
END


EXECUTE run_test 9;


SELECT * FROM PLATFORME;
SELECT * FROM JOCURI;
SELECT * FROM JOCURI_PLATFORME;

SELECT * FROM Tables;
SELECT * FROM TestRuns;
SELECT * FROM TestRunTables;
SELECT * FROM TestRunViews;
SELECT * FROM Tests;
SELECT * FROM TestTables;
SELECT * FROM TestViews;
SELECT * FROM Views;



DELETE FROM TestRuns;