GO
USE MAGAZIN_DE_JOCURI
GO

SELECT * FROM JOCURI

--- TRANZACTIA 1 ---


----------------- DIRTY READS -----------------

BEGIN TRAN
UPDATE JOCURI SET nume = 'JocDirtyReads' WHERE Jid = 1082
WAITFOR DELAY '00:00:05'
ROLLBACK TRAN


------------- NON-REPEATABLE READS ------------

UPDATE JOCURI SET nume = 'JocNou' WHERE nume = 'JocNowNRR__AFTER'

BEGIN TRAN
WAITFOR DELAY '00:00:05'
UPDATE JOCURI SET nume = 'JocNowNRR__AFTER' WHERE Jid = 1082
COMMIT TRAN


---------------- PHANTOM READS ----------------

DELETE FROM JOCURI WHERE nume = 'JocNouPhantom'

BEGIN TRAN
WAITFOR DELAY '00:00:05'
INSERT INTO JOCURI VALUES ('JocNouPhantom', 'multiplayer', 'online', '2023-05-21', 1, 1, 1) 
COMMIT TRAN


------------------ DEADLOCK -------------------

GO
CREATE OR ALTER PROCEDURE deadlock_tran1
AS
BEGIN
	--SET DEADLOCK_PRIORITY HIGH						-- solutie deadlock
	BEGIN TRAN
	-- blocare tabela PLATFORME
	UPDATE PLATFORME SET nume = 'Deadlock TRAN 1' where Pid = 21
	WAITFOR DELAY '00:00:05'
	-- incercare blocare tabelei JOCURI
	UPDATE JOCURI SET nume = 'Deadlock TRAN 1' where Jid = 1095
	COMMIT TRAN
END
GO

EXEC deadlock_tran1
SELECT * FROM JOCURI
SELECT * FROM PLATFORME