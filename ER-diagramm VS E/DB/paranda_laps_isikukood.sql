/* Parandus olemasolevale andmebaasile Lasteaed:
   eemaldame tabelist Laps veeru isikukood (koos selle piirangutega).
   Lapse kohta jääb alles sünniaeg. */
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
USE Lasteaed;
GO
IF OBJECT_ID('CK_Laps_isikukood', 'C') IS NOT NULL
    ALTER TABLE Laps DROP CONSTRAINT CK_Laps_isikukood;
IF OBJECT_ID('UQ_Laps_isikukood', 'UQ') IS NOT NULL
    ALTER TABLE Laps DROP CONSTRAINT UQ_Laps_isikukood;
IF COL_LENGTH('Laps', 'isikukood') IS NOT NULL
    ALTER TABLE Laps DROP COLUMN isikukood;
GO
