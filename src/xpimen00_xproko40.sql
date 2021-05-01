-- Projekt do IDS 2010/21
-- Authors: Prokofiev Oleksandr(xprko40), Pimenov Danylo(xpimen00)
-- Zad?n? ?. 58. – Fitness Centrum.


-------------------------------- DROP ------------------------------------------

DROP TABLE Prihlaseny;
DROP TABLE Lekce;
DROP TABLE Trener;
DROP TABLE Uzivatel;
DROP TABLE Sal;
DROP TABLE Kurz;

DROP MATERIALIZED VIEW mat_pohled;
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

--------------------------------------------- TRIGGER ------------------------------------------------------
-- Vždy v ponděli od 8-9 sa koná úvodni lekce přidaného kurzu
CREATE TRIGGER Uvodni_lekce
    AFTER INSERT ON Kurz
    FOR EACH ROW
BEGIN
    INSERT INTO Lekce(Poradove_cislo, Mista, Den, Zahajeni, Ukonceni, Cena, Sal, Kurz)
    VALUES (0, 30, 'Pondeli', '8:00', '9:00', 0, 'Box', :NEW.Nazev);
END;
/

-- Po ukončení kurzu neni nutné vědet záznam o jeho lekcich
CREATE TRIGGER Konec_kurzu
    AFTER DELETE ON Kurz
    FOR EACH ROW
BEGIN
    DELETE FROM Lekce WHERE Lekce.Kurz = :OLD.Nazev;
END;
/

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
VALUES ('Crossfit', 'Pokro?il?/Hybrid', 4, 90, 20, 'Kurz pro pokro?il?ch, zam??en? na spodn? ?ast t?la.');

INSERT INTO Kurz(Nazev, Typ, Obtiznost, Trvani, Kapacita, Popis)
VALUES ('Body_form', 'Za?ate?n?k/?eny', 2, 45, 40, 'Z?kladn? kurz pro ?eny zam??en? na precvi?en? cel?ho tela.');

INSERT INTO Kurz(Nazev, Typ, Obtiznost, Trvani, Kapacita, Popis)
VALUES ('Pl?van?', 'St?edn?_pokro?il?/Mu?i', 3, 60, 30, 'Kurz pro st?edn? pokro?il?ch plavc?.');

-- Uzivatel
INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (8904253333, 'Peter', 'Bezboh?', '+421949503611', 'bezbohy@seznam.cz',  'Nekone?n?', 42, 'Brno', 12154);

INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (9804254444, 'Ign?c', 'Bezruk?', '+420901504411', 'bezruky@bez.ruk', 'Kone?n?', 24, 'Praha', 985201);

INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (9504294555, 'Violeta', 'Beznoh?', '+421967999976', 'beznoha@gmail.com', 'Za?ate?n?', 420, 'Bratislava', 62101);

INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (2504232844, 'Volodymyr', 'Zelensky', '+380442557333', 'mr.president@ukrnet.ua', 'Bankova', 11, 'Kyiv', 01001);

INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (7303245432, 'Charlie', 'Sheen', '+300458735298', 'sharlie@cheen.com', 'Palms Spring', 420, 'Miami', 100000);

INSERT INTO Uzivatel(Rodne_cislo, Jmeno, Prijmeni, Tel_cislo, Mail, Ulice, Popisne_cislo, Mesto, PSC)
VALUES (5509306665, 'Arnold', '?varceneger', '+100432768467', 'iron@arnold.com', 'Unknown', 300, 'Pezinok', 97893);

-- Trener
INSERT INTO Trener(Rodne_cislo, Zacatek, Konec)
VALUES ((SELECT Rodne_cislo FROM Uzivatel WHERE Uzivatel.Rodne_cislo=8904253333),'17:25', '19:00');

INSERT INTO Trener(Rodne_cislo, Zacatek, Konec)
VALUES ((SELECT Rodne_cislo FROM Uzivatel WHERE Uzivatel.Rodne_cislo=9804254444),'08:00', '20:00');

INSERT INTO Trener(Rodne_cislo, Zacatek, Konec)
VALUES ((SELECT Rodne_cislo FROM Uzivatel WHERE Uzivatel.Rodne_cislo=9504294555),'12:00', '17:30');

-- Lekce
INSERT INTO Lekce(Poradove_cislo, Mista, Den, Zahajeni, Ukonceni, Cena, Sal, Kurz, Rodne_cislo)
VALUES (3, 20, 'Pond?l?', '17:30', '19:00', 17.50, 'Box','Crossfit', 8904253333);

INSERT INTO Lekce(Poradove_cislo, Mista, Den, Zahajeni, Ukonceni, Cena, Sal, Kurz, Rodne_cislo)
VALUES  (1, 2, 'St?eda', '12:45', '13:45', 23.99,'Bazen', 'Pl?van?', 9804254444);

INSERT INTO Lekce(Poradove_cislo, Mista, Den, Zahajeni, Ukonceni, Cena, Sal, Kurz, Rodne_cislo)
VALUES  (5, 8, 'Streda', '16:45', '17:30', 10, 'Spinning', 'Body_form', 9504294555);

-- Prihlaseny
INSERT INTO  Prihlaseny(Poradi_lekce, Nazev_kurzu, Rodne_cislo)
VALUES (1, 'Pl?van?', 2504232844);

INSERT INTO  Prihlaseny(Poradi_lekce, Nazev_kurzu, Rodne_cislo)
VALUES (5, 'Body_form', 7303245432);

INSERT INTO  Prihlaseny(Poradi_lekce, Nazev_kurzu, Rodne_cislo)
VALUES (1, 'Pl?van?', 5509306665);

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
SELECT Nazev, Typ, AVG(Obtiznost) AS Prumerna_obtiznost
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
    
    -- TRIGGER DEMO
DELETE FROM Kurz WHERE Nazev = 'Crossfit';
-------------------------------------------------- ?ast ?tvrta ---------------------------------------------------------

-- Procedury a funkce
CREATE OR REPLACE PROCEDURE najdi_uzivatele
AS
    prijmeni Uzivatel.Prijmeni%type;
    ulice Uzivatel.Ulice%type;
    cislo_domu Uzivatel.Popisne_cislo%type;
    mesto Uzivatel.Mesto%type;
    CURSOR cur is SELECT Prijmeni, Ulice, Popisne_cislo, Mesto FROM Uzivatel;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Informáce o pobytu uživatelu, kterých prijmeni je Beznohá.');
    IF cur %ISOPEN THEN
        CLOSE cur ;
    END IF;
    OPEN cur;

    LOOP
         FETCH cur INTO prijmeni, ulice, cislo_domu, mesto;
         EXIT WHEN cur%notfound;
         IF prijmeni = 'Beznohá' THEN
             DBMS_OUTPUT.put_line('Uzivatel '|| prijmeni ||'bydli ve meste '|| mesto ||'na ulici '|| ulice ||' '||cislo_domu);
         END IF;
    END LOOP;
    CLOSE cur;

END;
/

CREATE OR REPLACE PROCEDURE celkova_kapacita
AS
    CURSOR cur IS SELECT * FROM Sal;
    curs_var cur%ROWTYPE;
    celkova_kapacita NUMBER;
    percent NUMBER;
BEGIN
    IF cur %ISOPEN THEN
        CLOSE cur ;
    END IF;
    OPEN cur;

    celkova_kapacita := ziskej_celkovy_pocet();

    LOOP
        FETCH cur INTO curs_var;
        EXIT WHEN cur%NOTFOUND;
        IF curs_var.Kapacita < 60 THEN
            percent := vypocitej_percent_podilu(celkova_kapacita, curs_var.Kapacita);
            percent := ROUND(percent);
            DBMS_OUTPUT.put_line('Sal s kapacitou pod 60 člověk je ' ||curs_var.Nazev|| 's kapacitou ' ||curs_var.Kapacita);
            DBMS_OUTPUT.put_line('Sal tvorí ' ||percent|| '% z celkove kapacity.');
        END IF;
    END LOOP;
    DBMS_OUTPUT.put_line('Celková kapacita v salech je ' ||celkova_kapacita);

    CLOSE cur;
END;
/

CREATE OR REPLACE FUNCTION vypocitej_percent_podilu(celkovy_pocet IN NUMBER, jeden_sal IN number)
RETURN NUMBER
AS
    vysledek NUMBER;
BEGIN
    vysledek := (jeden_sal * 100) / celkovy_pocet;
    RETURN vysledek;

    EXCEPTION WHEN zero_divide THEN
        RETURN 0;
END;
/

CREATE OR REPLACE FUNCTION ziskej_celkovy_pocet
RETURN NUMBER
AS
    CURSOR cur IS SELECT Kapacita FROM Sal;
    celkovy_pocet NUMBER;
    iter Sal.Kapacita%TYPE;
BEGIN
    IF cur %ISOPEN THEN
        CLOSE cur ;
    END IF;
    OPEN cur;

    celkovy_pocet := 0;

    LOOP
        FETCH cur INTO iter;
        EXIT WHEN cur%NOTFOUND;
        celkovy_pocet := celkovy_pocet + iter;
    END LOOP;

    CLOSE cur;

    RETURN celkovy_pocet;
END;
/


CALL najdi_uzivatele();
CALL celkova_kapacita();


-- Explain plan

EXPLAIN PLAN FOR
SELECT
    Nazev, Typ, AVG(Obtiznost) AS prumerna_obtiznost
FROM
    Kurz
HAVING AVG(Obtiznost) < 3

GROUP BY Nazev, Typ;

SELECT * FROM TABLE(dbms_xplan.display);


EXPLAIN PLAN FOR
SELECT
    Rodne_cislo, Poradove_cislo, Kurz, Den, AVG(Cena) AS prumerna_cena_lekce
FROM
    Lekce
    NATURAL JOIN Prihlaseny
HAVING AVG(Cena) < 10

GROUP BY
    Rodne_cislo, Poradove_cislo, Kurz, Den;

SELECT * FROM TABLE(dbms_xplan.display);

-- Explain plan s pouzitim indexu

CREATE INDEX idx ON Prihlaseny(Rodne_cislo);

EXPLAIN PLAN FOR
SELECT
    Rodne_cislo, Poradove_cislo, Kurz, Den, AVG(Cena) AS prumerna_cena_lekce
FROM
    Lekce
    NATURAL JOIN Prihlaseny
HAVING AVG(Cena) < 10

GROUP BY
    Rodne_cislo, Poradove_cislo, Kurz, Den;

SELECT * FROM TABLE(dbms_xplan.display);

DROP INDEX idx;

-- Prideleni prav

GRANT ALL ON Uzivatel TO XPROKO40;
GRANT ALL ON Kurz TO XPROKO40;
GRANT ALL ON Lekce TO XPROKO40;
GRANT ALL ON Sal TO XPROKO40;
GRANT ALL ON Trener TO XPROKO40;
GRANT ALL ON Prihlaseny TO XPROKO40;

GRANT EXECUTE ON najdi_uzivatele TO XPROKO40;
GRANT EXECUTE ON celkova_kapacita TO XPROKO40;
GRANT EXECUTE ON ziskej_celkovy_pocet TO XPROKO40;
GRANT EXECUTE ON vypocitej_percent_podilu TO XPROKO40;


-- Vytvoreni materializovaneho pohledu

CREATE MATERIALIZED VIEW mat_pohled

NOLOGGING
CACHE
BUILD IMMEDIATE
REFRESH ON COMMIT

AS
    SELECT Jmeno, Prijmeni FROM Uzivatel o JOIN Trener t ON o.Rodne_cislo = t.Rodne_cislo;

GRANT ALL ON mat_pohled TO XPROKO40;
/******************** End od file ********************/