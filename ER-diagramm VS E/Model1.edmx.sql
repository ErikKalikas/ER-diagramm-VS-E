
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 10/13/2026 09:30:32
-- Generated from EDMX file: C:\Users\opilane\source\repos\ER-diagramm VS E\ER-diagramm VS E\Model1.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [LasteaedE];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------


-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------


-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'TootajaSet'
CREATE TABLE [dbo].[TootajaSet] (
    [tootaja_id] int IDENTITY(1,1) NOT NULL,
    [eesnimi] nvarchar(max)  NOT NULL,
    [perenimi] nvarchar(max)  NOT NULL,
    [isikukood] nvarchar(max)  NOT NULL,
    [telefon] nvarchar(max)  NOT NULL,
    [e_post] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'TootamineSet'
CREATE TABLE [dbo].[TootamineSet] (
    [tootamine_id] int IDENTITY(1,1) NOT NULL,
    [tootaja_id] nvarchar(max)  NOT NULL,
    [ametikoht_id] nvarchar(max)  NOT NULL,
    [alguse_kp] nvarchar(max)  NOT NULL,
    [lopu_kp] nvarchar(max)  NOT NULL,
    [Tootaja_tootaja_id] int  NOT NULL
);
GO

-- Creating table 'Ametikoha_tyypSet'
CREATE TABLE [dbo].[Ametikoha_tyypSet] (
    [ametikoha_tyyp_id] int IDENTITY(1,1) NOT NULL,
    [nimetus] nvarchar(max)  NOT NULL,
    [Tootamine_tootamine_id] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [tootaja_id] in table 'TootajaSet'
ALTER TABLE [dbo].[TootajaSet]
ADD CONSTRAINT [PK_TootajaSet]
    PRIMARY KEY CLUSTERED ([tootaja_id] ASC);
GO

-- Creating primary key on [tootamine_id] in table 'TootamineSet'
ALTER TABLE [dbo].[TootamineSet]
ADD CONSTRAINT [PK_TootamineSet]
    PRIMARY KEY CLUSTERED ([tootamine_id] ASC);
GO

-- Creating primary key on [ametikoha_tyyp_id] in table 'Ametikoha_tyypSet'
ALTER TABLE [dbo].[Ametikoha_tyypSet]
ADD CONSTRAINT [PK_Ametikoha_tyypSet]
    PRIMARY KEY CLUSTERED ([ametikoha_tyyp_id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [Tootaja_tootaja_id] in table 'TootamineSet'
ALTER TABLE [dbo].[TootamineSet]
ADD CONSTRAINT [FK_TootajaTootamine]
    FOREIGN KEY ([Tootaja_tootaja_id])
    REFERENCES [dbo].[TootajaSet]
        ([tootaja_id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_TootajaTootamine'
CREATE INDEX [IX_FK_TootajaTootamine]
ON [dbo].[TootamineSet]
    ([Tootaja_tootaja_id]);
GO

-- Creating foreign key on [Tootamine_tootamine_id] in table 'Ametikoha_tyypSet'
ALTER TABLE [dbo].[Ametikoha_tyypSet]
ADD CONSTRAINT [FK_TootamineAmetikoha_tyyp]
    FOREIGN KEY ([Tootamine_tootamine_id])
    REFERENCES [dbo].[TootamineSet]
        ([tootamine_id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_TootamineAmetikoha_tyyp'
CREATE INDEX [IX_FK_TootamineAmetikoha_tyyp]
ON [dbo].[Ametikoha_tyypSet]
    ([Tootamine_tootamine_id]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------