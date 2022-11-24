use master
go

/*create database MAGAZIN_DE_JOCURI
go*/

use MAGAZIN_DE_JOCURI
go

create table DEZVOLTATORI (
	Did INT PRIMARY KEY IDENTITY,
	nume varchar(50) UNIQUE NOT NULL,
	data_aparitie date,
	nr_jocuri INT DEFAULT 1
)


create table RESTRICTII_VARSTA (
	Rvid INT PRIMARY KEY IDENTITY,
	rating_varsta varchar(30) UNIQUE NOT NULL
)


create table CATEGORII (
	Cid INT PRIMARY KEY IDENTITY,
	categorie varchar(40) UNIQUE NOT NULL
)


create table JOCURI (
	Jid INT PRIMARY KEY IDENTITY,
	nume varchar(50) NOT NULL,
	nr_jucatori varchar(50) DEFAULT 'singleplayer',
	status_online varchar(50) DEFAULT 'offline',
	data_aparitie date,
	Did INT FOREIGN KEY REFERENCES DEZVOLTATORI(Did),
	Cid INT FOREIGN KEY REFERENCES CATEGORII(Cid),
	Rvid INT FOREIGN KEY REFERENCES RESTRICTII_VARSTA(Rvid)
)


create table PLATFORME (
	Pid INT PRIMARY KEY IDENTITY,
	nume varchar(30) UNIQUE NOT NULL
)


create table JOCURI_PLATFORME (
	Jid INT FOREIGN KEY REFERENCES JOCURI(Jid),
	Pid INT FOREIGN KEY REFERENCES PLATFORME(Pid),
	data_lansare date,
	CONSTRAINT pk_JocuriPlatforme PRIMARY KEY (Jid, Pid)
)


create table CLIENTI (
	Clid INT PRIMARY KEY IDENTITY,
	CNP varchar(15) UNIQUE NOT NULL,
	nume varchar(20) NOT NULL,
	prenume varchar(50) NOT NULL,
	data_nastere date NOT NULL,
	sex varchar(20)
)


create table ANGAJATI (
	Aid INT PRIMARY KEY IDENTITY,
	CNP varchar(15) UNIQUE NOT NULL,
	nume varchar(20) NOT NULL,
	prenume varchar(50) NOT NULL,
	data_nastere date NOT NULL,
	post varchar(50) NOT NULL
)


create table TRANZACTII (
	Tid INT UNIQUE IDENTITY,
	Clid INT FOREIGN KEY REFERENCES CLIENTI(Clid),
	Aid INT FOREIGN KEY REFERENCES ANGAJATI(Aid),
	data_tranzactie smalldatetime
	CONSTRAINT pk_Tranzactii PRIMARY KEY (Clid, Aid, data_tranzactie)
)


create table PACHETE_JOCURI (
	Tid INT FOREIGN KEY REFERENCES TRANZACTII(Tid),
	Jid INT FOREIGN KEY REFERENCES JOCURI(Jid),
	CONSTRAINT pk_PacheteJocuri PRIMARY KEY (Tid, Jid)
)