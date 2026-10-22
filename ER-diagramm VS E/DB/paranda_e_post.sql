/* Parandus olemasolevale andmebaasile Lasteaed:
   UNIQUE piirang lubas ainult ÜHE töötaja ilma e-postita (NULL).
   Asendame selle filtreeritud unikaalse indeksiga: e-post peab olema unikaalne,
   aga tühjaks võib selle jätta mitmel töötajal. */
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;  -- vajalik filtreeritud indeksi jaoks
GO
USE Lasteaed;
GO
IF OBJECT_ID('UQ_Tootaja_e_post', 'UQ') IS NOT NULL
    ALTER TABLE Tootaja DROP CONSTRAINT UQ_Tootaja_e_post;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_Tootaja_e_post' AND object_id = OBJECT_ID('Tootaja'))
    CREATE UNIQUE INDEX UQ_Tootaja_e_post ON Tootaja(e_post) WHERE e_post IS NOT NULL;
GO
