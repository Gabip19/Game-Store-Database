USE MAGAZIN_DE_JOCURI
GO



----- JURNALIZARE -----
GO
CREATE TABLE LOG_TABLE (
	METODA VARCHAR(50),
	TIP VARCHAR(12),
	MESAJ VARCHAR(1000),
	DATA_LANSARE DATETIME
);
GO

GO
CREATE OR ALTER PROCEDURE LOGGER
	@metoda VARCHAR(50),
	@tip VARCHAR(12),
	@mesaj VARCHAR(1000)
AS
BEGIN
	INSERT INTO LOG_TABLE(METODA, TIP, MESAJ, DATA_LANSARE)
	VALUES (@metoda, @tip, @mesaj, GETDATE());
END
GO



----- FULL COMMIT -----

CREATE OR ALTER PROCEDURE AddJocuriPlatforme
	@nume_joc VARCHAR(50),
	@nr_jucatori VARCHAR(50),
	@status VARCHAR(50),
	@data_aparitie DATE,
	@nume_dev VARCHAR(50),
	@categorie VARCHAR(40),
	@rating_varsta VARCHAR(30),
	@nume_platforma VARCHAR(30),
	@data_platforma DATE
AS
BEGIN
	EXEC LOGGER 'AddJocuriPlatforme', 'INFO', 'Tranzactie inceputa.';
	BEGIN TRAN;
	BEGIN TRY
		-- VALIDARI JOC
		IF (dbo.IncepeCuMajuscula(@nume_joc) = 0) BEGIN
			RAISERROR('Numele jocului trebuie sa inceapa cu o litera.', 14, 1);
		END
		IF (dbo.ValidStatus(@status) = 0) BEGIN
			RAISERROR('Statusul dat trebuie sa fie online, offline sau ambele.', 14, 1);
		END
		IF (dbo.ValidData(@data_aparitie) = 0) BEGIN
			RAISERROR('Data aparitiei nu trebuie sa fie dupa data curenta.', 14, 1);
		END
		DECLARE @Did INT = (dbo.ValidDev(@nume_dev));
		IF (@Did = -1) BEGIN
			RAISERROR('Numele dezvoltatorului dat nu exista.', 14, 1);
		END
		DECLARE @Cid INT = (dbo.ValidCategorie(@categorie));
		IF (@Cid = -1) BEGIN
			RAISERROR('Numele categoriei date nu exista.', 14, 1);
		END
		DECLARE @Rvid INT = (dbo.ValidRestrictie(@rating_varsta));
		IF (@Rvid = -1) BEGIN
			RAISERROR('Restrictia de varsta data nu exista.', 14, 1);
		END

		INSERT INTO JOCURI(nume, nr_jucatori, status_online, data_aparitie, Did, Cid, Rvid) 
		VALUES (@nume_joc, @nr_jucatori, @status, @data_aparitie, @Did, @Cid, @Rvid);

		-- VALIDARI PLATFORMA
		IF (dbo.IncepeCuMajuscula(@nume_platforma) = 0) BEGIN
			RAISERROR('Numele platformei trebuie sa inceapa cu o litera.', 14, 1);
		END

		INSERT INTO PLATFORME(nume) 
		VALUES (@nume_platforma);

		-- VALIDARI JOCURI_PLATFORMA
		IF (dbo.ValidData(@data_platforma) = 0) BEGIN
			RAISERROR('Data lansarii pe platforma nu trebuie sa fie dupa data curenta.', 14, 1);
		END

		DECLARE @Jid INT = (SELECT MAX(Jid) FROM JOCURI);
		DECLARE @Pid INT = (SELECT MAX(Pid) FROM PLATFORME);
		INSERT INTO JOCURI_PLATFORME(Jid, Pid, data_lansare)
		VALUES (@Jid, @Pid, @data_platforma);

		COMMIT TRAN;
		EXEC LOGGER 'AddJocuriPlatforme', 'INFO', 'Tranzactie realizata cu succes.';
		PRINT 'Transaction commited';
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		PRINT ERROR_MESSAGE();
		DECLARE @message VARCHAR(1000) = (SELECT ERROR_MESSAGE());
		EXEC LOGGER 'AddJocuriPlatforme', 'ERROR', @message;
		PRINT 'Transaction rollbacked';
		EXEC LOGGER 'AddJocuriPlatforme', 'INFO', 'Tranzactie rollbacked.';
	END CATCH
END
GO


-- exemplu bun
EXEC AddJocuriPlatforme 'JocNou', 'singleplayer', 'online', '2023-02-02', 'Valve', 'Aventura', 'PEGI 12', 'Xbox3000', '2023-03-02'

-- fail la date joc
EXEC AddJocuriPlatforme 'JocNou', 'singleplayer', 'gresit', '2023-05-02', 'Valve', 'Aventura', 'PEGI 12', 'Xbox3000', '2023-03-02'

-- fail la date platforma
EXEC AddJocuriPlatforme 'JocNou', 'singleplayer', 'online', '2023-02-02', 'Valve', 'Aventura', 'PEGI 12', '874Xbox3000', '2023-03-02'

-- fail la date jocuri-platforma
EXEC AddJocuriPlatforme 'JocNou', 'singleplayer', 'online', '2023-02-02', 'Valve', 'Aventura', 'PEGI 12', 'Xbox3000', '2030-03-02'

SELECT * FROM JOCURI
SELECT * FROM PLATFORME
SELECT * FROM JOCURI_PLATFORME
SELECT * FROM LOG_TABLE

-- DELETE FROM JOCURI_PLATFORME WHERE data_lansare > '2023-01-01'
-- DELETE FROM PLATFORME WHERE nume = 'Xbox3000'
-- DELETE FROM JOCURI WHERE nume = 'JocNou'
-- DELETE FROM LOG_TABLE



---------- VALIDARI ----------


-- verifica daca un cuvant incepe cu majuscula
GO
CREATE OR ALTER FUNCTION IncepeCuMajuscula(@cuvant VARCHAR(50))
RETURNS INT
AS
BEGIN
	IF (@cuvant LIKE '[A-Z]%')
	BEGIN
		RETURN 1;
	END
	RETURN 0;
END
GO

-- functie pt verificare status joc
GO
CREATE OR ALTER FUNCTION ValidStatus(@status VARCHAR(50))
RETURNS INT
AS
BEGIN
	IF (@status  IN ('online', 'offline', 'online/offline', 'offline/online'))
	BEGIN
		RETURN 1;
	END
	RETURN 0;
END
GO

-- functie pt verificare daca o data este mai mica decat data actuala
GO
CREATE OR ALTER FUNCTION ValidData(@data_ap DATE)
RETURNS INT
AS
BEGIN
	IF (@data_ap <= CAST(GETDATE() AS DATE))
	BEGIN
		RETURN 1;
	END
	RETURN 0;
END
GO

-- functie pt verificare daca dezvoltatorul exista
GO
CREATE OR ALTER FUNCTION ValidDev(@nume VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @did INT = (SELECT Did FROM DEZVOLTATORI WHERE nume = @nume);
	IF (@did IS NOT NULL)
	BEGIN
		RETURN @did;
	END
	RETURN -1;
END
GO

-- functie pt verificare daca categoria exista
GO
CREATE OR ALTER FUNCTION ValidCategorie(@nume VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @cid INT = (SELECT Cid FROM CATEGORII WHERE categorie = @nume);
	IF (@cid IS NOT NULL)
	BEGIN
		RETURN @cid;
	END
	RETURN -1;
END
GO

-- functie pt verificare daca restrictia de varsta exista
GO
CREATE OR ALTER FUNCTION ValidRestrictie(@nume VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Rvid INT = (SELECT Rvid FROM RESTRICTII_VARSTA WHERE rating_varsta = @nume);
	IF (@Rvid IS NOT NULL)
	BEGIN
		RETURN @Rvid;
	END
	RETURN -1;
END
GO



----- PARTIAL COMMIT -----

CREATE OR ALTER PROCEDURE AddJocuriPlatforme_partial
	@nume_joc VARCHAR(50),
	@nr_jucatori VARCHAR(50),
	@status VARCHAR(50),
	@data_aparitie DATE,
	@nume_dev VARCHAR(50),
	@categorie VARCHAR(40),
	@rating_varsta VARCHAR(30),
	@nume_platforma VARCHAR(30),
	@data_platforma DATE
AS
BEGIN
	DECLARE @message VARCHAR(1000);
	DECLARE @OK INT = 1;
	EXEC LOGGER 'AddJocuriPlatforme_partial', 'INFO', 'Tranzactie adauga joc inceputa.';
	----- JOCURI -----
	BEGIN TRAN;
	BEGIN TRY
		-- VALIDARI JOC
		IF (dbo.IncepeCuMajuscula(@nume_joc) = 0) BEGIN
			RAISERROR('Numele jocului trebuie sa inceapa cu o litera.', 14, 1);
		END
		IF (dbo.ValidStatus(@status) = 0) BEGIN
			RAISERROR('Statusul dat trebuie sa fie online, offline sau ambele.', 14, 1);
		END
		IF (dbo.ValidData(@data_aparitie) = 0) BEGIN
			RAISERROR('Data aparitiei nu trebuie sa fie dupa data curenta.', 14, 1);
		END
		DECLARE @Did INT = (dbo.ValidDev(@nume_dev));
		IF (@Did = -1) BEGIN
			RAISERROR('Numele dezvoltatorului dat nu exista.', 14, 1);
		END
		DECLARE @Cid INT = (dbo.ValidCategorie(@categorie));
		IF (@Cid = -1) BEGIN
			RAISERROR('Numele categoriei date nu exista.', 14, 1);
		END
		DECLARE @Rvid INT = (dbo.ValidRestrictie(@rating_varsta));
		IF (@Rvid = -1) BEGIN
			RAISERROR('Restrictia de varsta data nu exista.', 14, 1);
		END

		INSERT INTO JOCURI(nume, nr_jucatori, status_online, data_aparitie, Did, Cid, Rvid) 
		VALUES (@nume_joc, @nr_jucatori, @status, @data_aparitie, @Did, @Cid, @Rvid);

		COMMIT TRAN;
		EXEC LOGGER 'AddJocuriPlatforme_partial', 'INFO', 'Tranzactie adauga joc realizata cu succes.';
		PRINT 'Tranzactie adauga joc commited.';
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		PRINT ERROR_MESSAGE();
		SET @message = (SELECT ERROR_MESSAGE());
		EXEC LOGGER 'AddJocuriPlatforme_partial', 'ERROR', @message;
		PRINT 'Tranzactie adauga joc rollbacked.';
		EXEC LOGGER 'AddJocuriPlatforme_partial', 'INFO', 'Tranzactie adauga joc rollbacked.';
		SET @OK = 0;
	END CATCH

	----- PLATFORME -----
	EXEC LOGGER 'AddJocuriPlatforme_partial', 'INFO', 'Tranzactie adauga platforma inceputa.';
	BEGIN TRAN;
	BEGIN TRY
		-- VALIDARI PLATFORMA
		IF (dbo.IncepeCuMajuscula(@nume_platforma) = 0) BEGIN
			RAISERROR('Numele platformei trebuie sa inceapa cu o litera.', 14, 1);
		END

		INSERT INTO PLATFORME(nume) 
		VALUES (@nume_platforma);

		COMMIT TRAN;
		EXEC LOGGER 'AddJocuriPlatforme_partial', 'INFO', 'Tranzactie adauga platforma realizata cu succes.';
		PRINT 'Tranzactie adauga platforma commited.';
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		PRINT ERROR_MESSAGE();
		SET @message = (SELECT ERROR_MESSAGE());
		EXEC LOGGER 'AddJocuriPlatforme_partial', 'ERROR', @message;
		PRINT 'Tranzactie adauga platforma rollbacked.';
		EXEC LOGGER 'AddJocuriPlatforme_partial', 'INFO', 'Tranzactie adauga platforma rollbacked.';
		SET @OK = 0;
	END CATCH

	----- JOCURI_PLATFORME -----
	EXEC LOGGER 'AddJocuriPlatforme_partial', 'INFO', 'Tranzactie adauga joc la platforma inceputa.';
	BEGIN TRAN;
	BEGIN TRY
		-- VALIDARI JOCURI_PLATFORMA
		IF (@OK = 0) BEGIN
			RAISERROR('Adauga joc la platforma nu se poate realiza.', 14, 1);
		END
		IF (dbo.ValidData(@data_platforma) = 0) BEGIN
			RAISERROR('Data lansarii pe platforma nu trebuie sa fie dupa data curenta.', 14, 1);
		END

		DECLARE @Jid INT = (SELECT MAX(Jid) FROM JOCURI);
		DECLARE @Pid INT = (SELECT MAX(Pid) FROM PLATFORME);
		INSERT INTO JOCURI_PLATFORME(Jid, Pid, data_lansare)
		VALUES (@Jid, @Pid, @data_platforma);

		COMMIT TRAN;
		EXEC LOGGER 'AddJocuriPlatforme_partial', 'INFO', 'Tranzactie adauga joc la platforma realizata cu succes.';
		PRINT 'Tranzactie adauga joc la platforma commited.';
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		PRINT ERROR_MESSAGE();
		SET @message = (SELECT ERROR_MESSAGE());
		EXEC LOGGER 'AddJocuriPlatforme_partial', 'ERROR', @message;
		PRINT 'Tranzactie adauga joc la platforma rollbacked.';
		EXEC LOGGER 'AddJocuriPlatforme_partial', 'INFO', 'Tranzactie adauga joc la platforma rollbacked.';
	END CATCH
END
GO


-- exemplu bun
EXEC AddJocuriPlatforme_partial 
'JocNou-MultiTran', 'singleplayer', 'online', '2023-02-02', 'Valve', 'Aventura', 'PEGI 12', 'Xbox3000Multi', '2023-03-02'

-- fail la date joc
EXEC AddJocuriPlatforme_partial 
'JocNou-MultiTran', 'singleplayer', 'gresit', '2023-05-02', 'Valve', 'Aventura', 'PEGI 12', 'Xbox3000Multi', '2023-03-02'

-- fail la date platforma
EXEC AddJocuriPlatforme_partial 
'JocNou-MultiTran', 'singleplayer', 'online', '2023-02-02', 'Valve', 'Aventura', 'PEGI 12', '874Xbox3000Multi', '2023-03-02'

-- fail la date jocuri-platforma
EXEC AddJocuriPlatforme_partial 
'JocNou-MultiTran', 'singleplayer', 'online', '2023-02-02', 'Valve', 'Aventura', 'PEGI 12', 'Xbox3000Multi', '2030-03-02'

-- fail la date joc si date platforma
EXEC AddJocuriPlatforme_partial 
'JocNou-MultiTran', 'singleplayer', 'online', '2023-02-02', 'Valve', 'nu este', 'PEGI 12', '123Xbox3000Multi', '2023-03-02'

SELECT * FROM JOCURI
SELECT * FROM PLATFORME
SELECT * FROM JOCURI_PLATFORME
SELECT * FROM LOG_TABLE