/*
	INTEROGARI
*/
USE MAGAZIN_DE_JOCURI
GO


/*
	Afiseaza categoriile ce contin cel putin 2 jocuri aparute dupa 2018
*/
SELECT categorie, COUNT(categorie) AS nr_jocuri
FROM CATEGORII C
	INNER JOIN JOCURI J
	ON C.Cid = J.Cid
WHERE J.data_aparitie > '2018-01-01'
GROUP BY categorie
HAVING COUNT(categorie) > 1
--///////////////////////////////////////////////////////////////////////////////////////////////



/*
	Afiseaza angajatii si numarul de clienti distincti serviti de fiecare angajat 
	in ordine descrescatoare a acestuia
*/
SELECT A.Aid, A.nume, A.prenume, COUNT(DISTINCT C.Clid) AS nr_clienti_serviti
FROM ANGAJATI A
	INNER JOIN TRANZACTII T
	ON A.Aid = T.Aid
	INNER JOIN CLIENTI C
	ON C.Clid = T.Clid
GROUP BY A.Aid, A.nume, A.prenume
ORDER BY COUNT(DISTINCT C.Clid) DESC
--///////////////////////////////////////////////////////////////////////////////////////////////



/*
	Afiseaza jocurile care se regasesc pe mai mult de 3 console
*/
SELECT J.Jid, J.nume, COUNT(J.Jid) AS nr_console
FROM JOCURI J
	INNER JOIN JOCURI_PLATFORME JP
	ON J.Jid = JP.Jid
	INNER JOIN PLATFORME P
	ON JP.Pid = P.Pid
WHERE P.nume NOT IN ('Windows', 'MacOS', 'Mobile')
GROUP BY J.Jid, J.nume
HAVING COUNT(J.Jid) > 3
--///////////////////////////////////////////////////////////////////////////////////////////////



/*
	Afiseaza dezvoltatorii de jocuri multiplayer din 
	categoriile Aventura sau Survival
*/
SELECT DISTINCT D.Did, D.nume, D.data_aparitie
FROM DEZVOLTATORI D
	INNER JOIN JOCURI J
	ON D.Did = J.Did
	INNER JOIN CATEGORII C
	ON J.Cid = C.Cid
WHERE (C.categorie = 'Aventura' OR C.categorie = 'Survival')
	AND (J.nr_jucatori LIKE '%multiplayer%')
--///////////////////////////////////////////////////////////////////////////////////////////////



/*
	Afiseaza CNP-ul si numele clientilor care au cumparat mai mult de 
	patru jocuri in perioada 22-07-2022 <-> 28-10-2022 
*/
SELECT CNP, nume, COUNT(Pj.Jid) AS jocuri_cumparate
FROM CLIENTI C
	INNER JOIN TRANZACTII T
	ON C.Clid = T.Clid
	INNER JOIN PACHETE_JOCURI PJ
	ON T.Tid = Pj.Tid
WHERE T.data_tranzactie BETWEEN '2022-07-22 00:00:00' AND '2022-10-28 23:59:59'
GROUP BY CNP, nume
HAVING COUNT(Pj.Jid) > 4
--///////////////////////////////////////////////////////////////////////////////////////////////



/*
	Afiseaza numarul jocurilor distincte cumparate in aceeasi zi
*/
SELECT COUNT(DISTINCT J.nume) AS NR_JOCURI
FROM JOCURI J
	INNER JOIN PACHETE_JOCURI PJ
	ON J.Jid = PJ.Jid
	INNER JOIN TRANZACTII T
	ON PJ.Tid = T.Tid
WHERE T.data_tranzactie BETWEEN '2022-08-22 00:00:00' AND '2022-08-22 23:59:59'
--///////////////////////////////////////////////////////////////////////////////////////////////



/*
	Afiseaza companiile de dezvoltatori infiintate inainte de 1997 ce au jocuri
	din categoria FPS ordonate dupa data infiintarii
*/
SELECT D.Did, D.nume, D.data_aparitie
FROM DEZVOLTATORI D
	INNER JOIN JOCURI J
	ON D.Did = J.Did
	INNER JOIN CATEGORII C
	ON J.Cid = C.Cid
WHERE C.categorie = 'FPS' AND D.data_aparitie < '1997-01-01'
ORDER BY D.data_aparitie
--///////////////////////////////////////////////////////////////////////////////////////////////



/*
	Afiseaza data tranzactiilor ce contin jocuri a caror nume incepe cu litera C
*/
SELECT T.data_tranzactie
FROM TRANZACTII T
	INNER JOIN PACHETE_JOCURI PJ
	ON T.Tid = PJ.Tid
	INNER JOIN JOCURI J
	ON PJ.Jid = J.Jid
WHERE J.nume LIKE 'C%'
--///////////////////////////////////////////////////////////////////////////////////////////////



/*
	Afiseaza jocurile cumparate cel putin o 
	data impreuna cu restrictia de varsta pentru fiecare
*/
SELECT J.nume, COUNT(*) AS nr_cumparari, R.rating_varsta
FROM JOCURI J
	LEFT OUTER JOIN RESTRICTII_VARSTA R
	ON J.Rvid = R.Rvid
	INNER JOIN PACHETE_JOCURI PJ
	ON J.Jid = PJ.Jid
GROUP BY J.Jid, J.nume, R.rating_varsta
--///////////////////////////////////////////////////////////////////////////////////////////////



/*
	Afiseaza numarul de jocuri cumparate de fiecare client in ordine
	descrescatoare a numarului de jocuri
*/
SELECT C.Clid, C.CNP, C.nume, C.prenume, COUNT(PJ.Jid) AS nr_jocuri_cumparate
FROM CLIENTI C
	LEFT OUTER JOIN TRANZACTII T
	ON C.Clid = T.Clid
	LEFT OUTER JOIN PACHETE_JOCURI PJ
	ON T.Tid = PJ.Tid
GROUP BY C.Clid, C.CNP, C.nume, C.prenume
ORDER BY COUNT(PJ.Jid) DESC
--///////////////////////////////////////////////////////////////////////////////////////////////