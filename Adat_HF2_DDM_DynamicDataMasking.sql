/*1. Táblát hozok létre a megfelelő paraméterekkel DDM-et használva
    - Login-ra partial maszkolás megy (szöveg (varchar(100)))
    - Email-re email-es maszkolás  (szöveg (varchar(100)))
    - Nev-re alap, default maszkolás  (szöveg (varchar(100)))
    - Szulev-re pedig 1960 és 2006 közötti random szám generálódik, ez lesz a maszkolása (szám (INT))
    - Nem-et azt úgy döntöttem, hogy nem maszkolom el*/

CREATE TABLE ugyfelhazi
(
    ID INT IDENTITY PRIMARY KEY,
    LOGIN varchar(100) MASKED WITH (FUNCTION = 'partial(1, "XXX", 1)'),
    EMAIL varchar(100) MASKED WITH (FUNCTION = 'email()'),
    NEV varchar(100) MASKED WITH (FUNCTION = 'default()'),
    SZULEV INT MASKED WITH (FUNCTION = 'random(1960,2006)'),
    NEM varchar(10)
)

/*2. A Webshop adatbázis Ugyfel táblájából adatokat illesztek be (első 5 rekordot)*/

INSERT INTO ugyfelhazi
(LOGIN, EMAIL, NEV, SZULEV, NEM)
VALUES
('adam1','ádám.kiss@mail.hu','Kiss Ádám',1991,'F'),
('adam3','adam3@gmail.com','Barkóci Ádám',1970,'F'),
('adam4','ádám.bieniek@mail.hu','Bieniek Ádám',1976,'F'),
('agnes','agnes@gmail.com','Lengyel Ágnes',1979,'N'),
('agnes3','agnes3@gmail.com','Hartyánszky Ágnes',1967,'N')

/*3. Új felhaszálót hozok létre (Maszkos), 
    aki egyes adatokat (login, email, nev, szulev) csak maszkolva láthatja,
    illetve csak a SELECT-et adtuk neki, így módosítani nem tud, csak lekérdezni.

    FONTOS(!): csak a megjelenítés van maszkolva, így ugye pár lekérdezés, 
        művelet elvégzésével (ha több is engedélyezve lenne) az adatokon, helyes megállapításokat 
        tehet (az elviekben lekorlátozott hozzáférésű felhasználó), 
        mivel a műveletek az eredeti adatsoron futnak le 
        és ahogy írtam csak a megjelenítés kerül maszkolásra.*/

CREATE USER Maszkos WITHOUT Login;
GRANT SELECT ON ugyfelhazi TO Maszkos

/*4. Korlátozott hozzáférésű felhasználó lekérdezései*/

EXECUTE AS User= 'Maszkos';
SELECT * FROM ugyfelhazi

/*Végül a REVERT-el "visszajutunk" az eredeti felhasználóhoz*/
REVERT