USE MAGAZIN_DE_JOCURI
GO


/*	PROD 1
	Modifica tipul coloanei nr_jocuri din DEZVOLTATORI din INT in SMALL INT NOT NULL
*/
CREATE PROCEDURE modif_coloana
AS
BEGIN
	ALTER TABLE DEZVOLTATORI
	ALTER COLUMN nr_jocuri SMALLINT NOT NULL
	PRINT 'Coloana modificata cu succes.'
END

EXECUTE modif_coloana



/*	PROD 2
	Adauga constrangerea cu valoarea implicita 2 pt campul nr_jocuri din DEZVOLTATORI
*/
GO
CREATE PROCEDURE adauga_default
AS
BEGIN
	ALTER TABLE DEZVOLTATORI
	ADD CONSTRAINT df_2 DEFAULT 2
	FOR nr_jocuri
	PRINT 'Constrangere adaugata cu succes.'
END

EXECUTE adauga_default



/*	PROD 3
	Creeaza o noua tabela RECORDURI
*/
GO
CREATE PROCEDURE creeaza_tabela
AS
BEGIN
	CREATE TABLE RECORDURI(
		nume VARCHAR(15),
		scor INT,
		Jid INT,
		descriere VARCHAR(50)
	)
	PRINT 'Tabela creata cu succes.'
END

EXECUTE creeaza_tabela



/*	PROD 4
	Adauga un nou camp data_record in tabela RECORDURI de tipul date
*/
GO
CREATE PROCEDURE adauga_camp
AS
BEGIN
	ALTER TABLE RECORDURI
	ADD data_record date;
	PRINT 'Camp adaugat cu succes.'
END

EXECUTE adauga_camp



/*	PROD 5
	Adauga o constrangere de cheie straina pt campul Jid din tabela RECORDURI
*/
GO
CREATE PROCEDURE set_cheie_str
AS
BEGIN
	ALTER TABLE RECORDURI
	ADD CONSTRAINT fk_RECORDURI_Jid FOREIGN KEY (Jid) REFERENCES JOCURI(Jid);
	PRINT 'Constrangere adaugata cu succes.'
END

EXECUTE set_cheie_str


------------------------------------------------------------------------------------------------------------------


/*	PROD 1 INVERS	
	Modifica tipul coloanei nr_jocuri din DEZVOLTATORI in INT
*/
GO
CREATE PROCEDURE undo_modif_coloana
AS
BEGIN
	ALTER TABLE DEZVOLTATORI
	ALTER COLUMN nr_jocuri INT
	PRINT 'Coloana modificata cu succes.'
END

EXECUTE undo_modif_coloana



/*	PROD 2 INVERS
	Sterge constrangerea cu valoarea implicita 2 pt campul nr_jocuri din DEZVOLTATORI
*/
GO
CREATE PROCEDURE undo_adauga_default
AS
BEGIN
	ALTER TABLE DEZVOLTATORI
	DROP CONSTRAINT df_2;
	PRINT 'Constrangere stearsa cu succes.'
END

EXECUTE undo_adauga_default



/*	PROD 3 INVERS
	Sterge tabela RECORDURI
*/
GO
CREATE PROCEDURE undo_creeaza_tabela
AS
BEGIN
	DROP TABLE RECORDURI;
	PRINT 'Tabela stearsa cu succes.'
END

EXECUTE undo_creeaza_tabela



/*	PROD 4 INVERS
	Sterge campul data_record din tabela RECORDURI
*/
GO
CREATE PROCEDURE undo_adauga_camp
AS
BEGIN
	ALTER TABLE RECORDURI
	DROP COLUMN data_record;
	PRINT 'Camp sters cu succes.'
END

EXECUTE undo_adauga_camp



/*	PROD 5 INVERS
	Sterge constrangerea de cheie straina pt campul Jid din tabela RECORDURI
*/
GO
CREATE PROCEDURE undo_set_cheie_str
AS
BEGIN
	ALTER TABLE RECORDURI
	DROP CONSTRAINT fk_RECORDURI_Jid;
	PRINT 'Constrangere stearsa cu succes.'
END

EXECUTE undo_set_cheie_str;



/*
	Tabela tip dictionar pt proceduri
*/
CREATE TABLE PROCEDURI_VERSIUNE (
	index_proc SMALLINT,
	nume_proc VARCHAR(50)
);

INSERT INTO PROCEDURI_VERSIUNE VALUES
	(1, 'modif_coloana'),
	(2, 'adauga_default'),
	(3, 'creeaza_tabela'),
	(4, 'adauga_camp'),
	(5, 'set_cheie_str'),
	(0, 'undo_modif_coloana'),
	(-1, 'undo_adauga_default'),
	(-2, 'undo_creeaza_tabela'),
	(-3, 'undo_adauga_camp'),
	(-4, 'undo_set_cheie_str')

SELECT * FROM PROCEDURI_VERSIUNE


/*
	Tabela pt versiunea bazei de date
*/
CREATE TABLE VERSIUNE_DB (
	vers_curent SMALLINT NOT NULL,
	vers_max SMALLINT,
	data_actualizare DATETIME
);

INSERT INTO VERSIUNE_DB VALUES
	(0, 5, GETDATE());

SELECT * FROM VERSIUNE_DB



/*
	Procedura de schimbare a versiunii bazei de date
*/
GO
CREATE PROCEDURE main
@new_vers SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	-- verificam ca nr versiunii sa fie intre 0 si versiunea maxima
	IF @new_vers < 0 OR @new_vers > (SELECT vers_max FROM VERSIUNE_DB)
	BEGIN 
		RAISERROR('Versiune invalida.', 16, 1);
		RETURN;
	END

	-- extragem versiunea curenta
	DECLARE @current_vers SMALLINT = 
		(SELECT vers_curent FROM VERSIUNE_DB);

	-- daca noua versiune este chiar cea curenta
	IF @current_vers = @new_vers
	BEGIN
		RAISERROR('Baza de date se afla deja in versiunea data.', 16, 1);
		RETURN;
	END
	
	-- determinam daca trebuie sa trecem la o versiune superioara sau la una inferioara
	DECLARE @step INT = 
		CASE
			WHEN @current_vers < @new_vers THEN 1
			WHEN @current_vers > @new_vers THEN -1
		END
	
	DECLARE @next_proc VARCHAR(30);

	WHILE @current_vers <> @new_vers
	BEGIN
		-- actualizam versiunea curenta
		SET @current_vers = @current_vers + @step;
		-- extragem urmatoarea procedura de executat
		SET @next_proc = 
			(SELECT nume_proc FROM PROCEDURI_VERSIUNE WHERE index_proc = @current_vers*@step);
		-- executam procedura
		EXECUTE @next_proc;
		PRINT 'Am actualizat la versiunea ' + CAST(@current_vers AS VARCHAR) + '.';
	END

	-- actualizam versiunea curenta a bazei de date si ora actualizarii in tabel 
	UPDATE VERSIUNE_DB
	SET vers_curent = @current_vers;
	UPDATE VERSIUNE_DB
	SET data_actualizare = GETDATE();

	PRINT CHAR(10) + 'ACTUALIZAREA S-A REALIZAT CU SUCCES.';
END


--DROP PROCEDURE main
EXECUTE main 1
SELECT * FROM VERSIUNE_DB