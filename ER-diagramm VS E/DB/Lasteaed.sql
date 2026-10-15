/* =========================================================
   Lasteaed – andmebaasi loomine (SQL Server / LocalDB)
   1) tabelid koos piirangutega
   2) testandmed
   3) seoste ja piirangute kontroll
   ========================================================= */

IF DB_ID(N'Lasteaed') IS NULL
    CREATE DATABASE Lasteaed;
GO
USE Lasteaed;
GO

/* Kustutame vanad tabelid (õiges järjekorras), et skripti saaks uuesti käivitada */
IF OBJECT_ID('Menyy_roog')      IS NOT NULL DROP TABLE Menyy_roog;
IF OBJECT_ID('Menyy')           IS NOT NULL DROP TABLE Menyy;
IF OBJECT_ID('Toidu_valjastus') IS NOT NULL DROP TABLE Toidu_valjastus;
IF OBJECT_ID('Roog')            IS NOT NULL DROP TABLE Roog;
IF OBJECT_ID('Puudumine')       IS NOT NULL DROP TABLE Puudumine;
IF OBJECT_ID('Jarjekord')       IS NOT NULL DROP TABLE Jarjekord;
IF OBJECT_ID('Ruhmas_olek')     IS NOT NULL DROP TABLE Ruhmas_olek;
IF OBJECT_ID('Laps')            IS NOT NULL DROP TABLE Laps;
IF OBJECT_ID('Tootamine')       IS NOT NULL DROP TABLE Tootamine;
IF OBJECT_ID('Ametikoht')       IS NOT NULL DROP TABLE Ametikoht;
IF OBJECT_ID('Ruhm')            IS NOT NULL DROP TABLE Ruhm;
IF OBJECT_ID('Ruhma_tyyp')      IS NOT NULL DROP TABLE Ruhma_tyyp;
IF OBJECT_ID('Ametikoha_tyyp')  IS NOT NULL DROP TABLE Ametikoha_tyyp;
IF OBJECT_ID('Tootaja')         IS NOT NULL DROP TABLE Tootaja;
GO

/* ===================== 1. TABELID ===================== */

CREATE TABLE Tootaja (
    tootaja_id  INT IDENTITY(1,1) CONSTRAINT PK_Tootaja PRIMARY KEY,
    eesnimi     NVARCHAR(50)  NOT NULL,
    perenimi    NVARCHAR(50)  NOT NULL,
    isikukood   CHAR(11)      NOT NULL CONSTRAINT UQ_Tootaja_isikukood UNIQUE,
    telefon     VARCHAR(20)   NULL,
    e_post      VARCHAR(100)  NULL CONSTRAINT UQ_Tootaja_e_post UNIQUE,
    CONSTRAINT CK_Tootaja_isikukood CHECK (LEN(isikukood) = 11 AND isikukood NOT LIKE '%[^0-9]%'),
    CONSTRAINT CK_Tootaja_e_post    CHECK (e_post IS NULL OR e_post LIKE '%_@_%._%')
);

CREATE TABLE Ametikoha_tyyp (
    ametikoha_tyyp_id INT IDENTITY(1,1) CONSTRAINT PK_Ametikoha_tyyp PRIMARY KEY,
    nimetus NVARCHAR(50) NOT NULL CONSTRAINT UQ_Ametikoha_tyyp_nimetus UNIQUE,
    CONSTRAINT CK_Ametikoha_tyyp_nimetus
        CHECK (nimetus IN (N'vanemkasvataja', N'metoodik', N'kasvataja', N'õpetaja abi', N'kokk', N'söögitädi'))
);

CREATE TABLE Ruhma_tyyp (
    ruhma_tyyp_id INT IDENTITY(1,1) CONSTRAINT PK_Ruhma_tyyp PRIMARY KEY,
    nimetus NVARCHAR(30) NOT NULL CONSTRAINT UQ_Ruhma_tyyp_nimetus UNIQUE,
    CONSTRAINT CK_Ruhma_tyyp_nimetus CHECK (nimetus IN (N'sõim', N'aiarühm', N'liitrühm'))
);

CREATE TABLE Ruhm (
    ruhm_id       INT IDENTITY(1,1) CONSTRAINT PK_Ruhm PRIMARY KEY,
    ruhma_tyyp_id INT NOT NULL
        CONSTRAINT FK_Ruhm_Ruhma_tyyp REFERENCES Ruhma_tyyp(ruhma_tyyp_id),
    nimetus       NVARCHAR(50) NOT NULL CONSTRAINT UQ_Ruhm_nimetus UNIQUE,
    kohtade_arv   INT NOT NULL,
    CONSTRAINT CK_Ruhm_kohtade_arv CHECK (kohtade_arv BETWEEN 1 AND 30)
);

CREATE TABLE Ametikoht (
    ametikoht_id      INT IDENTITY(1,1) CONSTRAINT PK_Ametikoht PRIMARY KEY,
    ruhm_id           INT NULL
        CONSTRAINT FK_Ametikoht_Ruhm REFERENCES Ruhm(ruhm_id),          -- NULL = köök
    ametikoha_tyyp_id INT NOT NULL
        CONSTRAINT FK_Ametikoht_Ametikoha_tyyp REFERENCES Ametikoha_tyyp(ametikoha_tyyp_id),
    on_kooki_koht     BIT NOT NULL CONSTRAINT DF_Ametikoht_kook DEFAULT 0,
    CONSTRAINT CK_Ametikoht_kook CHECK (
        (on_kooki_koht = 1 AND ruhm_id IS NULL) OR
        (on_kooki_koht = 0 AND ruhm_id IS NOT NULL))
);

CREATE TABLE Tootamine (
    tootamine_id INT IDENTITY(1,1) CONSTRAINT PK_Tootamine PRIMARY KEY,
    tootaja_id   INT NOT NULL CONSTRAINT FK_Tootamine_Tootaja   REFERENCES Tootaja(tootaja_id),
    ametikoht_id INT NOT NULL CONSTRAINT FK_Tootamine_Ametikoht REFERENCES Ametikoht(ametikoht_id),
    alguse_kp    DATE NOT NULL,
    lopu_kp      DATE NULL,
    CONSTRAINT CK_Tootamine_kp CHECK (lopu_kp IS NULL OR lopu_kp >= alguse_kp)
);

CREATE TABLE Laps (
    laps_id   INT IDENTITY(1,1) CONSTRAINT PK_Laps PRIMARY KEY,
    eesnimi   NVARCHAR(50) NOT NULL,
    perenimi  NVARCHAR(50) NOT NULL,
    isikukood CHAR(11)     NOT NULL CONSTRAINT UQ_Laps_isikukood UNIQUE,
    synniaeg  DATE         NOT NULL,
    CONSTRAINT CK_Laps_isikukood CHECK (LEN(isikukood) = 11 AND isikukood NOT LIKE '%[^0-9]%'),
    CONSTRAINT CK_Laps_synniaeg  CHECK (synniaeg <= CAST(GETDATE() AS DATE))
);

CREATE TABLE Ruhmas_olek (
    ruhmas_olek_id INT IDENTITY(1,1) CONSTRAINT PK_Ruhmas_olek PRIMARY KEY,
    laps_id   INT NOT NULL CONSTRAINT FK_Ruhmas_olek_Laps REFERENCES Laps(laps_id),
    ruhm_id   INT NOT NULL CONSTRAINT FK_Ruhmas_olek_Ruhm REFERENCES Ruhm(ruhm_id),
    alguse_kp DATE NOT NULL,
    lopu_kp   DATE NULL,
    CONSTRAINT CK_Ruhmas_olek_kp CHECK (lopu_kp IS NULL OR lopu_kp >= alguse_kp)
);

CREATE TABLE Jarjekord (
    jarjekord_id     INT IDENTITY(1,1) CONSTRAINT PK_Jarjekord PRIMARY KEY,
    laps_id          INT NOT NULL CONSTRAINT FK_Jarjekord_Laps REFERENCES Laps(laps_id),
    soovitud_ruhm_id INT NULL     CONSTRAINT FK_Jarjekord_Ruhm REFERENCES Ruhm(ruhm_id),
    lisamise_kp      DATE NOT NULL CONSTRAINT DF_Jarjekord_lisamise_kp DEFAULT CAST(GETDATE() AS DATE),
    staatus          NVARCHAR(20) NOT NULL CONSTRAINT DF_Jarjekord_staatus DEFAULT N'ootel',
    CONSTRAINT CK_Jarjekord_staatus
        CHECK (staatus IN (N'ootel', N'pakutud', N'vastu võetud', N'tühistatud'))
);

CREATE TABLE Puudumine (
    puudumine_id INT IDENTITY(1,1) CONSTRAINT PK_Puudumine PRIMARY KEY,
    laps_id   INT NOT NULL CONSTRAINT FK_Puudumine_Laps REFERENCES Laps(laps_id),
    alguse_kp DATE NOT NULL,
    lopu_kp   DATE NOT NULL,
    pohjus    NVARCHAR(20) NOT NULL,
    CONSTRAINT CK_Puudumine_kp     CHECK (lopu_kp >= alguse_kp),
    CONSTRAINT CK_Puudumine_pohjus CHECK (pohjus IN (N'haigus', N'puhkus', N'muu'))
);

CREATE TABLE Roog (
    roog_id   INT IDENTITY(1,1) CONSTRAINT PK_Roog PRIMARY KEY,
    nimetus   NVARCHAR(100) NOT NULL CONSTRAINT UQ_Roog_nimetus UNIQUE,
    kirjeldus NVARCHAR(255) NULL
);

CREATE TABLE Toidu_valjastus (
    valjastus_id    INT IDENTITY(1,1) CONSTRAINT PK_Toidu_valjastus PRIMARY KEY,
    ruhm_id         INT NOT NULL CONSTRAINT FK_Toidu_valjastus_Ruhm REFERENCES Ruhm(ruhm_id),
    roog_id         INT NOT NULL CONSTRAINT FK_Toidu_valjastus_Roog REFERENCES Roog(roog_id),
    kuupaev         DATE NOT NULL,
    portsjonite_arv INT  NOT NULL,
    CONSTRAINT CK_Toidu_valjastus_portsjonid CHECK (portsjonite_arv > 0),
    CONSTRAINT UQ_Toidu_valjastus UNIQUE (ruhm_id, roog_id, kuupaev)
);

CREATE TABLE Menyy (
    menyy_id INT IDENTITY(1,1) CONSTRAINT PK_Menyy PRIMARY KEY,
    kuupaev  DATE NOT NULL CONSTRAINT UQ_Menyy_kuupaev UNIQUE
);

CREATE TABLE Menyy_roog (
    menyy_id  INT NOT NULL CONSTRAINT FK_Menyy_roog_Menyy REFERENCES Menyy(menyy_id),
    roog_id   INT NOT NULL CONSTRAINT FK_Menyy_roog_Roog  REFERENCES Roog(roog_id),
    toidukord NVARCHAR(20) NOT NULL,
    CONSTRAINT PK_Menyy_roog PRIMARY KEY (menyy_id, roog_id),
    CONSTRAINT CK_Menyy_roog_toidukord CHECK (toidukord IN (N'hommikusöök', N'lõuna', N'oode'))
);
GO

/* ===================== 2. ANDMED ===================== */

INSERT INTO Ruhma_tyyp (nimetus) VALUES (N'sõim'), (N'aiarühm'), (N'liitrühm');

INSERT INTO Ametikoha_tyyp (nimetus) VALUES
 (N'vanemkasvataja'), (N'metoodik'), (N'kasvataja'), (N'õpetaja abi'), (N'kokk'), (N'söögitädi');

INSERT INTO Ruhm (ruhma_tyyp_id, nimetus, kohtade_arv) VALUES
 (1, N'Mõmmikud', 14),
 (2, N'Päikesekiired', 20),
 (2, N'Liblikad', 20),
 (3, N'Siilid', 18);

INSERT INTO Tootaja (eesnimi, perenimi, isikukood, telefon, e_post) VALUES
 (N'Mari',  N'Tamm',   '47501010011', '5551234', 'mari.tamm@lasteaed.ee'),
 (N'Kati',  N'Kask',   '48203150022', '5552345', 'kati.kask@lasteaed.ee'),
 (N'Liis',  N'Saar',   '49007070033', '5553456', 'liis.saar@lasteaed.ee'),
 (N'Anne',  N'Mägi',   '46811110044', '5554567', 'anne.magi@lasteaed.ee'),
 (N'Peeter',N'Kuusk',  '37905050055', '5555678', 'peeter.kuusk@lasteaed.ee'),
 (N'Tiina', N'Lepp',   '47409090066', NULL,      NULL);

INSERT INTO Ametikoht (ruhm_id, ametikoha_tyyp_id, on_kooki_koht) VALUES
 (1,    3, 0),  -- 1: Mõmmikute kasvataja
 (2,    3, 0),  -- 2: Päikesekiirte kasvataja
 (3,    1, 0),  -- 3: Liblikate vanemkasvataja
 (4,    4, 0),  -- 4: Siilide õpetaja abi
 (NULL, 5, 1),  -- 5: köök – kokk
 (NULL, 6, 1);  -- 6: köök – söögitädi

INSERT INTO Tootamine (tootaja_id, ametikoht_id, alguse_kp, lopu_kp) VALUES
 (1, 1, '2020-09-01', NULL),
 (2, 2, '2021-08-15', NULL),
 (3, 3, '2019-09-01', NULL),
 (4, 4, '2022-01-10', '2025-06-30'),
 (5, 5, '2018-03-01', NULL),
 (6, 6, '2023-09-01', NULL);

INSERT INTO Laps (eesnimi, perenimi, isikukood, synniaeg) VALUES
 (N'Mia',    N'Tamm',   '62403120011', '2024-03-12'),
 (N'Oliver', N'Kask',   '52307050022', '2023-07-05'),
 (N'Sofia',  N'Saar',   '62101190033', '2021-01-19'),
 (N'Robin',  N'Ilves',  '52010300044', '2020-10-30'),
 (N'Emma',   N'Rebane', '62205250055', '2022-05-25'),
 (N'Lukas',  N'Põder',  '52112120066', '2021-12-12'),
 (N'Hanna',  N'Karu',   '62502140077', '2025-02-14');

INSERT INTO Ruhmas_olek (laps_id, ruhm_id, alguse_kp, lopu_kp) VALUES
 (1, 1, '2025-09-01', NULL),
 (2, 1, '2025-09-01', '2026-08-31'),
 (2, 2, '2026-09-01', NULL),
 (3, 3, '2024-09-01', NULL),
 (4, 4, '2023-09-01', NULL),
 (5, 2, '2025-09-01', NULL),
 (6, 3, '2024-09-01', NULL);

INSERT INTO Jarjekord (laps_id, soovitud_ruhm_id, lisamise_kp, staatus) VALUES
 (7, 1,    '2026-03-01', N'ootel'),
 (1, 1,    '2025-02-10', N'vastu võetud'),
 (5, NULL, '2025-01-05', N'vastu võetud');

INSERT INTO Puudumine (laps_id, alguse_kp, lopu_kp, pohjus) VALUES
 (1, '2026-10-05', '2026-10-09', N'haigus'),
 (3, '2026-07-01', '2026-07-31', N'puhkus'),
 (4, '2026-10-12', '2026-10-12', N'muu');

INSERT INTO Roog (nimetus, kirjeldus) VALUES
 (N'Kaerahelbepuder', N'Piimaga, moosiga'),
 (N'Kanasupp',        N'Köögiviljade ja nuudlitega'),
 (N'Kartulipuder hakklihakastmega', NULL),
 (N'Kohupiimavorm',   N'Marjakastmega'),
 (N'Õunakook',        NULL);

INSERT INTO Menyy (kuupaev) VALUES ('2026-10-12'), ('2026-10-13');

INSERT INTO Menyy_roog (menyy_id, roog_id, toidukord) VALUES
 (1, 1, N'hommikusöök'), (1, 2, N'lõuna'), (1, 5, N'oode'),
 (2, 1, N'hommikusöök'), (2, 3, N'lõuna'), (2, 4, N'oode');

INSERT INTO Toidu_valjastus (ruhm_id, roog_id, kuupaev, portsjonite_arv) VALUES
 (1, 1, '2026-10-12', 12), (2, 1, '2026-10-12', 19), (3, 2, '2026-10-12', 18),
 (4, 2, '2026-10-12', 16), (1, 3, '2026-10-13', 11), (2, 3, '2026-10-13', 20);
GO

/* ===================== 3. KONTROLL ===================== */

-- 3.1 Seosed: lapsed koos praeguse rühma ja rühma tüübiga
SELECT l.eesnimi, l.perenimi, r.nimetus AS ruhm, rt.nimetus AS ruhma_tyyp, ro.alguse_kp
FROM Laps l
JOIN Ruhmas_olek ro ON ro.laps_id = l.laps_id AND ro.lopu_kp IS NULL
JOIN Ruhm r         ON r.ruhm_id = ro.ruhm_id
JOIN Ruhma_tyyp rt  ON rt.ruhma_tyyp_id = r.ruhma_tyyp_id;

-- 3.2 Töötajad, ametikoht ja rühm (köögitöötajatel rühm puudub)
SELECT t.eesnimi, t.perenimi, at.nimetus AS amet,
       ISNULL(r.nimetus, N'köök') AS koht, tm.alguse_kp, tm.lopu_kp
FROM Tootaja t
JOIN Tootamine tm      ON tm.tootaja_id = t.tootaja_id
JOIN Ametikoht a       ON a.ametikoht_id = tm.ametikoht_id
JOIN Ametikoha_tyyp at ON at.ametikoha_tyyp_id = a.ametikoha_tyyp_id
LEFT JOIN Ruhm r       ON r.ruhm_id = a.ruhm_id;

-- 3.3 Päeva menüü
SELECT m.kuupaev, mr.toidukord, rg.nimetus
FROM Menyy m
JOIN Menyy_roog mr ON mr.menyy_id = m.menyy_id
JOIN Roog rg       ON rg.roog_id = mr.roog_id
ORDER BY m.kuupaev, mr.toidukord;

-- 3.4 Väljastatud portsjonid rühmade kaupa
SELECT r.nimetus AS ruhm, SUM(tv.portsjonite_arv) AS portsjoneid
FROM Toidu_valjastus tv JOIN Ruhm r ON r.ruhm_id = tv.ruhm_id
GROUP BY r.nimetus;

-- 3.5 Piirangute test: iga lause PEAB ebaõnnestuma
DECLARE @tests TABLE (nr INT IDENTITY, kirjeldus NVARCHAR(200), tulemus NVARCHAR(300));

BEGIN TRY INSERT INTO Laps (eesnimi, perenimi, isikukood, synniaeg) VALUES (NULL, N'Test', '61111111111', '2022-01-01');
      INSERT INTO @tests VALUES (N'NOT NULL – Laps.eesnimi', N'VIGA: lubati!'); END TRY
BEGIN CATCH INSERT INTO @tests VALUES (N'NOT NULL – Laps.eesnimi', N'OK: ' + ERROR_MESSAGE()); END CATCH;

BEGIN TRY INSERT INTO Laps (eesnimi, perenimi, isikukood, synniaeg) VALUES (N'Topelt', N'Test', '62403120011', '2022-01-01');
      INSERT INTO @tests VALUES (N'UNIQUE – Laps.isikukood', N'VIGA: lubati!'); END TRY
BEGIN CATCH INSERT INTO @tests VALUES (N'UNIQUE – Laps.isikukood', N'OK: ' + ERROR_MESSAGE()); END CATCH;

BEGIN TRY INSERT INTO Puudumine (laps_id, alguse_kp, lopu_kp, pohjus) VALUES (1, '2026-10-01', '2026-10-02', N'igav');
      INSERT INTO @tests VALUES (N'CHECK – Puudumine.pohjus', N'VIGA: lubati!'); END TRY
BEGIN CATCH INSERT INTO @tests VALUES (N'CHECK – Puudumine.pohjus', N'OK: ' + ERROR_MESSAGE()); END CATCH;

BEGIN TRY INSERT INTO Puudumine (laps_id, alguse_kp, lopu_kp, pohjus) VALUES (1, '2026-10-10', '2026-10-01', N'haigus');
      INSERT INTO @tests VALUES (N'CHECK – lopu_kp >= alguse_kp', N'VIGA: lubati!'); END TRY
BEGIN CATCH INSERT INTO @tests VALUES (N'CHECK – lopu_kp >= alguse_kp', N'OK: ' + ERROR_MESSAGE()); END CATCH;

BEGIN TRY INSERT INTO Ruhm (ruhma_tyyp_id, nimetus, kohtade_arv) VALUES (1, N'Liiga suur', 50);
      INSERT INTO @tests VALUES (N'CHECK – Ruhm.kohtade_arv', N'VIGA: lubati!'); END TRY
BEGIN CATCH INSERT INTO @tests VALUES (N'CHECK – Ruhm.kohtade_arv', N'OK: ' + ERROR_MESSAGE()); END CATCH;

BEGIN TRY INSERT INTO Jarjekord (laps_id, staatus) VALUES (7, N'kadunud');
      INSERT INTO @tests VALUES (N'CHECK – Jarjekord.staatus', N'VIGA: lubati!'); END TRY
BEGIN CATCH INSERT INTO @tests VALUES (N'CHECK – Jarjekord.staatus', N'OK: ' + ERROR_MESSAGE()); END CATCH;

BEGIN TRY INSERT INTO Ametikoht (ruhm_id, ametikoha_tyyp_id, on_kooki_koht) VALUES (1, 5, 1);
      INSERT INTO @tests VALUES (N'CHECK – köögikohal ei tohi olla rühma', N'VIGA: lubati!'); END TRY
BEGIN CATCH INSERT INTO @tests VALUES (N'CHECK – köögikohal ei tohi olla rühma', N'OK: ' + ERROR_MESSAGE()); END CATCH;

BEGIN TRY INSERT INTO Ruhmas_olek (laps_id, ruhm_id, alguse_kp) VALUES (999, 1, '2026-01-01');
      INSERT INTO @tests VALUES (N'FOREIGN KEY – olematu laps', N'VIGA: lubati!'); END TRY
BEGIN CATCH INSERT INTO @tests VALUES (N'FOREIGN KEY – olematu laps', N'OK: ' + ERROR_MESSAGE()); END CATCH;

BEGIN TRY DELETE FROM Ruhm WHERE ruhm_id = 1;
      INSERT INTO @tests VALUES (N'FOREIGN KEY – kasutuses rühma kustutamine', N'VIGA: lubati!'); END TRY
BEGIN CATCH INSERT INTO @tests VALUES (N'FOREIGN KEY – kasutuses rühma kustutamine', N'OK: ' + ERROR_MESSAGE()); END CATCH;

BEGIN TRY INSERT INTO Menyy_roog (menyy_id, roog_id, toidukord) VALUES (1, 1, N'lõuna');
      INSERT INTO @tests VALUES (N'PRIMARY KEY – Menyy_roog topeltrida', N'VIGA: lubati!'); END TRY
BEGIN CATCH INSERT INTO @tests VALUES (N'PRIMARY KEY – Menyy_roog topeltrida', N'OK: ' + ERROR_MESSAGE()); END CATCH;

SELECT * FROM @tests;

-- 3.6 Ridade arv igas tabelis
SELECT 'Tootaja' AS tabel, COUNT(*) AS ridu FROM Tootaja UNION ALL
SELECT 'Tootamine', COUNT(*) FROM Tootamine UNION ALL
SELECT 'Ametikoht', COUNT(*) FROM Ametikoht UNION ALL
SELECT 'Ametikoha_tyyp', COUNT(*) FROM Ametikoha_tyyp UNION ALL
SELECT 'Ruhm', COUNT(*) FROM Ruhm UNION ALL
SELECT 'Ruhma_tyyp', COUNT(*) FROM Ruhma_tyyp UNION ALL
SELECT 'Laps', COUNT(*) FROM Laps UNION ALL
SELECT 'Ruhmas_olek', COUNT(*) FROM Ruhmas_olek UNION ALL
SELECT 'Jarjekord', COUNT(*) FROM Jarjekord UNION ALL
SELECT 'Puudumine', COUNT(*) FROM Puudumine UNION ALL
SELECT 'Roog', COUNT(*) FROM Roog UNION ALL
SELECT 'Toidu_valjastus', COUNT(*) FROM Toidu_valjastus UNION ALL
SELECT 'Menyy', COUNT(*) FROM Menyy UNION ALL
SELECT 'Menyy_roog', COUNT(*) FROM Menyy_roog;
GO
