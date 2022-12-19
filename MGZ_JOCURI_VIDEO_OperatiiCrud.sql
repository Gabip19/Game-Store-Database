USE MAGAZIN_DE_JOCURI
GO



----- CRUD PENTRU PLATFORME -----

CREATE OR ALTER PROCEDURE CRUD_platforme
	@nume_platforma VARCHAR(30),
	@num_of_rows INT = 1
AS
BEGIN
	SET NOCOUNT ON;
	IF (dbo.ExistaPlatforma(@nume_platforma)=0)
	BEGIN
		-- INSERT
		DECLARE @n INT = 0;
		WHILE (@n < @num_of_rows)
		BEGIN
			INSERT INTO PLATFORME(nume) VALUES (@nume_platforma);
			SET @n = @n + 1;
		END

		-- SELECT
		SELECT * FROM PLATFORME;

		-- UPDATE
		UPDATE PLATFORME 
		SET nume = @nume_platforma + '_CRUD'
		WHERE nume = @nume_platforma;
		SELECT * FROM PLATFORME;
		
		-- DELETE
		DELETE FROM JOCURI_PLATFORME
		WHERE Pid IN (SELECT P.Pid FROM PLATFORME P WHERE nume LIKE @nume_platforma + '_CRUD');

		DELETE FROM PLATFORME
		WHERE nume LIKE @nume_platforma + '_CRUD';
		SELECT * FROM PLATFORME ORDER BY nume;

		PRINT 'Operatii CRUD pentru PLATFORME executate.';
	END
	ELSE
	BEGIN
		RAISERROR('O platforma cu numele dat exista deja.', 16, 1);
	END
END

-- functie pt verificare existenta nume platforme
GO
CREATE OR ALTER FUNCTION ExistaPlatforma(@nume_platforma VARCHAR(30))
RETURNS INT
AS
BEGIN
	IF (EXISTS (SELECT * FROM PLATFORME WHERE nume = @nume_platforma))
	BEGIN
		RETURN 1;
	END
	RETURN 0;
END
GO

SELECT * FROM PLATFORME
EXEC CRUD_platforme NUME, 5;




----- CRUD PENTRU JOCURI -----
GO
CREATE OR ALTER PROCEDURE CRUD_jocuri
	@nume_joc VARCHAR(50),
	@nr_jucatori VARCHAR(50),
	@status VARCHAR(50),
	@data_ap DATE,
	@id_dev INT,
	@id_cat INT,
	@id_res INT,
	@num_of_rows INT = 1
AS
BEGIN
	SET NOCOUNT ON;
	IF (dbo.ExistaNumeJoc(@nume_joc)=0 AND
		dbo.ValidStatus(@status)=1 AND
		dbo.ValidData(@data_ap)=1 AND
		dbo.CheiStraineJocValide(@id_dev, @id_cat, @id_res)=1)
	BEGIN
		-- INSERT
		DECLARE @n INT = 0;
		WHILE (@n < @num_of_rows)
		BEGIN
			INSERT INTO JOCURI VALUES(@nume_joc, @nr_jucatori, @status, @data_ap, @id_dev, @id_cat, @id_res);
			SET @n = @n + 1;
		END

		-- SELECT
		SELECT * FROM JOCURI ORDER BY nume;

		-- UPDATE
		UPDATE JOCURI
		SET nume = @nume_joc + '_CRUD'
		WHERE nume = @nume_joc;
		SELECT * FROM JOCURI ORDER BY nume;
		
		-- DELETE
		DELETE FROM JOCURI_PLATFORME
		WHERE Jid IN (SELECT J.Jid FROM JOCURI J WHERE nume LIKE @nume_joc + '_CRUD');

		DELETE FROM JOCURI
		WHERE nume LIKE @nume_joc + '_CRUD';
		SELECT * FROM JOCURI ORDER BY nume;

		PRINT 'Operatii CRUD pentru JOCURI executate.';
	END
	ELSE
	BEGIN
		RAISERROR('Datele de intrare nu sunt valide.', 16, 1);
	END
END
GO

-- functie pt verificare existenta nume joc
GO
CREATE OR ALTER FUNCTION ExistaNumeJoc(@nume_joc VARCHAR(50))
RETURNS INT
AS
BEGIN
	IF (EXISTS (SELECT * FROM JOCURI WHERE nume = @nume_joc))
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

-- functie pt verificare daca id-urile cheilor straine din JOCURI exista
GO
CREATE OR ALTER FUNCTION CheiStraineJocValide(@id_dev INT, @id_cat INT, @id_res INT)
RETURNS INT
AS
BEGIN
	IF (
		EXISTS (SELECT * FROM DEZVOLTATORI D WHERE D.Did = @id_dev) AND
		EXISTS (SELECT * FROM CATEGORII C WHERE C.Cid = @id_cat) AND
		EXISTS (SELECT * FROM RESTRICTII_VARSTA R WHERE R.Rvid = @id_res)
	)
	BEGIN
		RETURN 1;
	END
	RETURN 0;
END
GO

EXEC CRUD_jocuri 'AaaaJoculetz', 'single', 'online', '2022-12-19', 1, 1, 1




----- CRUD PENTRU JOCURI_PLATFORME -----

GO
CREATE OR ALTER PROCEDURE CRUD_jocuri_platforme
	@id_joc INT,
	@id_platforma INT,
	@data_lansare DATE
AS
BEGIN
	IF (dbo.CheiStraineJocPlatformeValide(@id_joc, @id_platforma)=1 AND
		dbo.ValidData(@data_lansare)=1 AND
		dbo.ExistaDejaAsociere(@id_joc, @id_platforma)=0)
	BEGIN
		-- INSERT
		INSERT INTO JOCURI_PLATFORME VALUES(@id_joc, @id_platforma, @data_lansare);

		-- SELECT
		SELECT * FROM JOCURI_PLATFORME ORDER BY Jid;

		-- UPDATE
		UPDATE JOCURI_PLATFORME
		SET data_lansare = '2000-12-12'
		WHERE data_lansare = @data_lansare;
		SELECT * FROM JOCURI_PLATFORME ORDER BY Jid;
		
		-- DELETE
		DELETE FROM JOCURI_PLATFORME
		WHERE data_lansare < '2015-12-31';
		SELECT * FROM JOCURI_PLATFORME ORDER BY Jid;

		PRINT 'Operatii CRUD pentru JOCURI_PLATFORME executate.';
	END
	ELSE
	BEGIN
		RAISERROR('Datele de intrare nu sunt valide.', 16, 1);
	END
END
GO

-- functie pt verificare daca id-urile cheilor straine din JOCURI_PLATFORME exista
GO
CREATE OR ALTER FUNCTION CheiStraineJocPlatformeValide(@id_joc INT, @id_platforma INT)
RETURNS INT
AS
BEGIN
	IF (
		EXISTS (SELECT * FROM JOCURI J WHERE J.Jid = @id_joc) AND
		EXISTS (SELECT * FROM PLATFORME P WHERE P.Pid = @id_platforma)
	)
	BEGIN
		RETURN 1;
	END
	RETURN 0;
END
GO

-- functie pt verificare daca id-urile cheilor straine nu formeaza deja o pereche

GO
CREATE OR ALTER FUNCTION ExistaDejaAsociere(@id_joc INT, @id_platforma INT)
RETURNS INT
AS
BEGIN
	IF (EXISTS (SELECT * FROM JOCURI_PLATFORME WHERE Jid = @id_joc AND Pid = @id_platforma))
	BEGIN
		RETURN 1;
	END
	RETURN 0;
END
GO

EXEC CRUD_jocuri_platforme 1, 2, '2022-12-15'


----- View-uri -----

-- pt JOCURI
GO
CREATE OR ALTER VIEW JOCURI_CRUD_VIEW AS
	SELECT Jid, nume FROM JOCURI
	WHERE nume LIKE 'J%'
GO

SELECT * FROM JOCURI_CRUD_VIEW

-- pt JOCURI reunit cu PLATFORME
GO
CREATE OR ALTER VIEW JOCURI_PLATFORME_CRUD_VIEW AS
	SELECT J.Jid, J.nume, P.Pid, P.nume AS Platforma  FROM JOCURI J
		INNER JOIN JOCURI_PLATFORME JP ON J.Jid = JP.Jid
		INNER JOIN PLATFORME P ON JP.Pid = P.Pid;
GO

SELECT * FROM JOCURI_PLATFORME_CRUD_VIEW


----- INDEX -----
GO
CREATE NONCLUSTERED INDEX N_idx_jocuri_nume ON JOCURI(nume);
-- DROP INDEX N_idx_jocuri_nume ON JOCURI;
-- CREATE NONCLUSTERED INDEX N_idx_jocuri_jid ON JOCURI(Jid);
-- DROP INDEX N_idx_jocuri_jid ON JOCURI;

CREATE NONCLUSTERED INDEX N_idx_jocplat_jid ON JOCURI_PLATFORME(Jid); -- 0.0035361
CREATE NONCLUSTERED INDEX N_idx_jocplat_pid ON JOCURI_PLATFORME(Pid); -- 0.0035361
-- DROP INDEX N_idx_jocplat_pid ON JOCURI_PLATFORME;
-- DROP INDEX N_idx_jocplat_jid ON JOCURI_PLATFORME;
GO


SELECT * FROM JOCURI_CRUD_VIEW;

SELECT * FROM JOCURI_PLATFORME_CRUD_VIEW;

SELECT * FROM JOCURI_PLATFORME






INSERT INTO JOCURI_PLATFORME(Jid, Pid) VALUES
--	(1, 1),
--	(1, 2),
--	(1, 3),
--	(1, 4),
--	(1, 5),
--	(1, 6),
--	(1, 7),
--	(1, 8),
--	(1, 9),
--	(1, 10),
--	(1, 50),
--	(1, 21),
--	(1, 22),
--	(1, 23),
--	(1, 24),
--	(1, 25),
--	(1, 26),
--	(2, 27),
--	(2, 1),
--	(2, 2),
--	(2, 3),
--	(2, 4),
--	(2, 5),
--	(2, 6),
--	(2, 7),
--	(2, 8),
--	(2, 9),
--	(2, 10),
--	(2, 50),
--	(2, 21),
--	(2, 22),
--	(2, 23),
--	(2, 24),
--	(2, 25),
--	(2, 26),
	(3, 28),
	(3, 1),
	(3, 2),
	(3, 3),
	(3, 4),
	(3, 5),
	(3, 6),
	(3, 7),
	(3, 8),
	(3, 9),
	(3, 10),
	(3, 50),
	(3, 21),
	(3, 22),
	(3, 23),
	(3, 24),
	(3, 25),
	(3, 26),
	(3, 27),
	(4, 1),
	(4, 2),
	(4, 3),
	(4, 4),
	(4, 5),
	(4, 6),
	(4, 7),
	(4, 8),
	(4, 9),
	(4, 10),
	(4, 50),
	(4, 21),
	(4, 22),
	(4, 23),
	(4, 24),
	(4, 25),
	(4, 26),
	(4, 27),
	(5, 1),
	(5, 2),
	(5, 3),
	(5, 4),
	(5, 5),
	(5, 6),
	(5, 7),
	(5, 8),
	(5, 9),
	(5, 10),
	(5, 50),
	(5, 21),
	(5, 22),
	(5, 23),
	(5, 24),
	(5, 25),
	(5, 26),
	(5, 27)