-- Projekt do IDS 2010/21
-- Authors: Prokofiev Oleksandr(xprko40), Pimenov Danylo(xpimen00)
-- Zadání č. 58. – Fitness Centrum.


-------------------------------- DROP ------------------------------------------

DROP TABLE Prihlaseny;
DROP TABLE Lekce;
DROP TABLE Trener;
DROP TABLE Uzivatel;
DROP TABLE Sal;
DROP TABLE Kurz;

-------------------------------- CREATE ----------------------------------------

CREATE TABLE Kurz
(
    Nazev       CHAR(50) NOT NULL PRIMARY KEY,
    Typ         CHAR(50),
    Obtiznost   INT,
    Popis       CHAR(100),
    Trvani      INT,
    Kapacita    INT    
);

CREATE TABLE Sal
(
    Nazev       CHAR(50) NOT NULL PRIMARY KEY,
    Umisteni    CHAR(50),
    Kapacita    INT
);

CREATE TABLE Uzivatel
(
    Rodne_cislo     INT      NOT NULL PRIMARY KEY,
    Jmeno           CHAR(20) NOT NULL,
    Prijmeni        CHAR(20) NOT NULL,
    Tel_cislo       CHAR(18),
    Mail            CHAR(40),
    Ulice           CHAR(20) NOT NULL,
    Popisne_cislo   INT      NOT NULL,
    Mesto           CHAR(20) NOT NULL,
    PSC             INT
);

CREATE TABLE Trener
(
    Rodne_cislo     INT PRIMARY KEY NOT NULL,
    FOREIGN KEY     (Rodne_cislo) REFERENCES Uzivatel(Rodne_cislo),
    Zacatek        CHAR(5),
    Konec          CHAR(5)
);

CREATE TABLE Lekce
(
    Poradove_cislo     INT NOT NULL,
    Mista       INT,
    Den         CHAR(10),
    Zahajeni    CHAR(5),
    Ukonceni    CHAR(5),
    Cena        FLOAT,
    Sal         CHAR(50),
    Kurz        CHAR(50) NOT NULL ,
    Rodne_cislo INT,
    CONSTRAINT Poradi_kurz PRIMARY KEY(Poradove_cislo, Kurz),

    CONSTRAINT Sal_fk
        FOREIGN KEY (Sal) REFERENCES Sal(Nazev),

    CONSTRAINT Kurz_fk
        FOREIGN KEY (Kurz) REFERENCES Kurz(Nazev),

    CONSTRAINT  Rodne_cislo_fk
        FOREIGN KEY (Rodne_cislo) REFERENCES Trener(Rodne_cislo)
);

CREATE TABLE Prihlaseny
(
    Poradi_lekce INT,
    Nazev_kurzu CHAR(50),
    FOREIGN KEY     (Poradi_lekce, Nazev_kurzu) REFERENCES Lekce(Poradove_cislo, Kurz),
    Rodne_cislo INT,
    FOREIGN KEY     (Rodne_cislo) REFERENCES Uzivatel(Rodne_cislo)
);

--------------------------------------------- INSERT ------------------------------------------------------

-- Sal
INSERT INTO Sal(Nazev, Umisteni, Kapacita)
VALUES ('Box', 'A00', 30);

INSERT INTO Sal(Nazev, Umisteni, Kapacita)
VALUES ('Spinning', 'A01', 60);

INSERT INTO Sal(Nazev, Umisteni, Kapacita)
VALUES ('Bazen', 'B04', 40);

INSERT INTO Sal(Nazev, Umisteni, Kapacita)
VALUES ('Posilovna', 'C05', 100);

-- Kurz
INSERT INTO Kurz(Nazev, Typ, Obtiznost, Trvani, Kapacita, Popis)
VALUES ('Crossfit', 'Pokročilý/Hybrid', 4, 90, 20, 'Kurz pro pokročilých, zaměřený na spodní čast těla.');

INSERT INTO Kurz(Nazev, Typ, Obtiznost, Trvani, Kapacita, Popis)
VALUES ('Body_form', 'Začatečník/Ženy', 2, 45, 40, 'Základný kurz pro ženy zaměřený na precvičení celého tela.');

INSERT INTO Kurz(Nazev, Typ, Obtiznost, Trvani, Kapacita, Popis)
VALUES ('Plávaní', 'Středně_pokročilý/Muži', 3, 60, 30, 'Kurz pro středně pokročilých plavcí.');

-- Uzivatel
INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (8904253333, 'Peter', 'Bezbohý', '+421949503611', 'bezbohy@seznam.cz',  'Nekonečná', 42, 'Brno', 12154);

INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (9804254444, 'Ignác', 'Bezruký', '+420901504411', 'bezruky@bez.ruk', 'Konečná', 24, 'Praha', 985201);

INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (9504294555, 'Violeta', 'Beznohá', '+421967999976', 'beznoha@gmail.com', 'Začatečná', 420, 'Bratislava', 62101);

INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (2504232844, 'Volodymyr', 'Zelensky', '+380442557333', 'mr.president@ukrnet.ua', 'Bankova', 11, 'Kyiv', 01001);

INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (7303245432, 'Charlie', 'Sheen', '+300458735298', 'sharlie@cheen.com', 'Palms Spring', 420, 'Miami', 100000);

INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (5509306665, 'Arnold', 'Švarceneger', '+100432768467', 'iron@arnold.com', 'Unknown', 300, 'Pezinok', 97893);

-- Trener
INSERT INTO Trener(Rodne_cislo, Zacatek, Konec)
VALUES ((SELECT Rodne_cislo FROM Uzivatel WHERE Uzivatel.Rodne_cislo=8904253333),'17:25', '19:00');

INSERT INTO Trener(Rodne_cislo, Zacatek, Konec)
VALUES ((SELECT Rodne_cislo FROM Uzivatel WHERE Uzivatel.Rodne_cislo=9804254444),'08:00', '20:00');

INSERT INTO Trener(Rodne_cislo, Zacatek, Konec)
VALUES ((SELECT Rodne_cislo FROM Uzivatel WHERE Uzivatel.Rodne_cislo=9504294555),'12:00', '17:30');

-- Lekce
INSERT INTO Lekce(Poradove_cislo, Mista, Den, Zahajeni, Ukonceni, Cena, Sal, Kurz, Rodne_cislo)
VALUES (3, 20, 'Pondělí', '17:30', '19:00', 17.50, 'Box','Crossfit', 8904253333);

INSERT INTO Lekce(Poradove_cislo, Mista, Den, Zahajeni, Ukonceni, Cena, Sal, Kurz, Rodne_cislo)
VALUES  (1, 2, 'Středa', '12:45', '13:45', 23.99,'Bazen', 'Plávaní', 9804254444);

INSERT INTO Lekce(Poradove_cislo, Mista, Den, Zahajeni, Ukonceni, Cena, Sal, Kurz, Rodne_cislo)
VALUES  (5, 8, 'Streda', '16:45', '17:30', 10, 'Spinning', 'Body_form', 9504294555);

-- Prihlaseny
INSERT INTO  Prihlaseny(Poradi_lekce, Nazev_kurzu, Rodne_cislo)
VALUES (1, 'Plávaní', 2504232844);

INSERT INTO  Prihlaseny(Poradi_lekce, Nazev_kurzu, Rodne_cislo)
VALUES (5, 'Body_form', 7303245432);

INSERT INTO  Prihlaseny(Poradi_lekce, Nazev_kurzu, Rodne_cislo)
VALUES (1, 'Plávaní', 5509306665);

--------------------------------------------- SELECT ------------------------------------------------------

-- Informace o lekce kterou vede určitý tréner
SELECT Kurz, Sal, Poradove_cislo, Cena 
FROM Lekce NATURAL JOIN Trener
WHERE Rodne_cislo = 8904253333
OR Rodne_cislo = 9504294555
OR Rodne_cislo = 9804254444;

-- Informace o kurzu, která třetí lekce se odehráva v pondělí a stojí vic než 15 eur
SELECT Nazev, Kapacita
FROM Sal
    NATURAL JOIN Lekce
    NATURAL JOIN Prihlaseny
WHERE Cena > 15
AND Poradi_lekce = 3
AND Den = 'Pondělí';

-- Informace o trenérovi, který vede lekce Body_form s kapacitou místnosti maximálně 50
SELECT DISTINCT Jmeno, Prijmeni, Tel_cislo, Mesto
FROM Uzivatel
    NATURAL JOIN Trener
    NATURAL JOIN Sal
    NATURAL JOIN Lekce
WHERE Rodne_cislo = 9504294555 
    AND Kurz = 'Body_form' 
    AND Kapacita < 50;

-- Vyhleda názvy kurzu, ktoré trvají dele 45 minut
SELECT Nazev, MAX(Trvani) AS Nejdelsi_kurz
FROM Kurz
HAVING MAX(Trvani) > 45
GROUP BY Nazev;

-- Vyhleda názvy a typ kurzu, ktorý má průměrnou obtiznost menší než 3
SELECT Nazev, Typ, AVG(Obtiznost) AS Prumerná_obtiznost
FROM Kurz
HAVING AVG(Obtiznost) < 3
GROUP BY Nazev, Typ;

-- Informace o uživatelích která jsou prihlášené na lekce
SELECT Jmeno, Prijmeni
FROM Uzivatel
WHERE EXISTS 
    (   SELECT Lekce.Rodne_cislo
        FROM Lekce
        WHERE Uzivatel.Rodne_cislo = Rodne_cislo
    );

-- Informace o místnosti ve které se odehráva lekce
SELECT Nazev, Umisteni, Kapacita
FROM Sal
WHERE EXISTS
    (   SELECT Lekce.Sal
        FROM Lekce
        WHERE Sal.Nazev = Sal
    );

-- Popis kurzu, která lekce začina 12:45 a ní trenér zacina 17:25
SELECT Popis
FROM Kurz
WHERE Nazev IN
    (
        SELECT Lekce.Kurz
        FROM Lekce
            INNER JOIN Trener
            ON Lekce.Rodne_cislo = Trener.Rodne_cislo
        WHERE Trener.Zacatek = '17:25'
            AND Lekce.Zahajeni = '12:45'
    );
