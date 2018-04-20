-- CreaDb.SQL
-- Date: March 2018
-- Author: X. Carrel
-- Goal: Creates the Scrasp DB
--       If the DB already exists, it is destroyed and recreated
--       The data directory C:\DATA\MSSQL is created if it doesn't exist

USE master
GO

-- First delete the database if it exists
IF (EXISTS (SELECT name FROM sysdatabases WHERE name = 'Scrasp'))
BEGIN
	USE master
	ALTER DATABASE Scrasp SET SINGLE_USER WITH ROLLBACK IMMEDIATE; -- Disconnect users the hard way (we cannot drop the db if someone's connected)
	DROP DATABASE Scrasp -- Destroy it
END
GO

-- Second ensure we have the proper directory structure
SET NOCOUNT ON

CREATE TABLE #ResultSet (Directory varchar(200)) -- Temporary table (name starts with #) -> will be automatically destroyed at the end of the session

INSERT INTO #ResultSet EXEC master.sys.xp_subdirs 'c:\' -- Stored procedure that lists subdirectories

IF NOT EXISTS (Select * FROM #ResultSet where Directory = 'DATA')
	EXEC master.sys.xp_create_subdir 'C:\DATA\' -- create DATA

DELETE FROM #ResultSet -- start over for MSSQL subdir
INSERT INTO #ResultSet EXEC master.sys.xp_subdirs 'c:\DATA'

SET NOCOUNT OFF

IF NOT EXISTS (Select * FROM #ResultSet where Directory = 'MSSQL')
	EXEC master.sys.xp_create_subdir 'C:\DATA\MSSQL'

DROP TABLE #ResultSet -- Explicitely delete it because the script may be executed multiple times during the same session
GO

-- Everything is ready, we can create the db
CREATE DATABASE Scrasp ON  PRIMARY 
( NAME = 'Scrasp_data', FILENAME = 'C:\DATA\MSSQL\Scrasp.mdf' , SIZE = 20480KB , MAXSIZE = 51200KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = 'Scrasp_log', FILENAME = 'C:\DATA\MSSQL\Scrasp.ldf' , SIZE = 10240KB , MAXSIZE = 20480KB , FILEGROWTH = 1024KB )

GO

USE Scrasp
GO

CREATE TABLE __MigrationHistory(
	MigrationId nvarchar(150) NOT NULL PRIMARY KEY,
	ContextKey nvarchar(300) NOT NULL,
	Model varbinary(max) NOT NULL,
	ProductVersion nvarchar(32) NOT NULL
)
GO

CREATE TABLE AspNetRoles(
	Id nvarchar(128) NOT NULL PRIMARY KEY,
	Name nvarchar(256) NOT NULL
)
GO

CREATE TABLE AspNetUserClaims(
	Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UserId nvarchar(128) NOT NULL,
	ClaimType nvarchar(max) NULL,
	ClaimValue nvarchar(max) NULL
)
GO

CREATE TABLE AspNetUserLogins(
	LoginProvider nvarchar(128) NOT NULL,
	ProviderKey nvarchar(128) NOT NULL,
	UserId nvarchar(128) NOT NULL
)
GO

CREATE TABLE AspNetUserRoles(
	UserId nvarchar(128) NOT NULL,
	RoleId nvarchar(128) NOT NULL,
	CONSTRAINT PK_AspNetUserRoles PRIMARY KEY CLUSTERED 
	(
		UserId ASC,
		RoleId ASC
	)
)
GO

CREATE TABLE AspNetUsers(
	Id nvarchar(128) NOT NULL PRIMARY KEY,
	Email nvarchar(256) NULL,
	EmailConfirmed bit NOT NULL,
	PasswordHash nvarchar(max) NULL,
	SecurityStamp nvarchar(max) NULL,
	PhoneNumber nvarchar(max) NULL,
	PhoneNumberConfirmed bit NOT NULL,
	TwoFactorEnabled bit NOT NULL,
	LockoutEndDateUtc datetime NULL,
	LockoutEnabled bit NOT NULL,
	AccessFailedCount int NOT NULL,
	UserName nvarchar(256) NOT NULL
)
GO

CREATE TABLE Jobs(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	jobDescription text NULL,
	startDate date NULL,
	endDate date NULL,
	JobStates_id int NOT NULL,
	Stories_id int NULL,
	ScraspUsers_id int NULL
)
GO

CREATE TABLE JobStates(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	stateName varchar(15) NULL
)
GO

CREATE TABLE Projects(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	title varchar(35) NOT NULL,
	projectDescription text NULL,
	refRepo varchar(100) NULL,
	startDate date NULL,
	endDate date NULL
)
GO

CREATE TABLE ScraspRoles(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	roleName varchar(15) NULL
)
GO

CREATE TABLE ScraspUsers(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	AspNetUsers_id nvarchar(128) NOT NULL,
	username varchar(35) NOT NULL,
	ScraspRoles_id int NOT NULL
)
GO

CREATE TABLE Sprints(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	number int NULL,
	sprintDescription text NULL,
	startDate date NULL,
	endDate date NULL
)
GO

CREATE TABLE Stories(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	shortName varchar(50) NULL,
	actor varchar(35) NOT NULL,
	storyDescription text NULL,
	StoryTypes_id int NOT NULL,
	StoryStates_id int NOT NULL,
	Sprints_id int NULL,
	Projects_id int NOT NULL,
	points int NULL
)
GO

CREATE TABLE StoryStates(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	stateName varchar(15) NULL
)
GO

CREATE TABLE StoryTypes(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	typeName varchar(15) NULL
)
GO

CREATE TABLE Teams(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Projects_id int NOT NULL,
	ScraspUsers_id int NOT NULL
)
GO

-- Data
INSERT AspNetUsers (Id, Email, EmailConfirmed, PasswordHash, SecurityStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEndDateUtc, LockoutEnabled, AccessFailedCount, UserName) VALUES (N'3b61deb3-2220-45d9-896d-1c04d41a33bc', N'jack@us.gov', 0, N'ACcpS9k7bv7NtwmJdoVAvnzXXSoc1e7KI4ARu+nIfpsu+VaPP37speCc9y5FUJPHHw==', N'0af37c13-db3b-415c-901c-27c0fc2d1f19', NULL, 0, 0, NULL, 1, 0, N'jack@us.gov')
INSERT AspNetUsers (Id, Email, EmailConfirmed, PasswordHash, SecurityStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEndDateUtc, LockoutEnabled, AccessFailedCount, UserName) VALUES (N'74e37cf8-6adb-4bd6-9fc9-ebab2ee2329e', N'william@us.gov', 0, N'AP/I7R6pQuupLgg5pxexYJOrsMzNPozrwRa2C33es8EyCN0q7jTj9iC8RCxo7GzMCQ==', N'54238b94-ecf0-4ef8-9146-b04172bce207', NULL, 0, 0, NULL, 1, 0, N'william@us.gov')
INSERT AspNetUsers (Id, Email, EmailConfirmed, PasswordHash, SecurityStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEndDateUtc, LockoutEnabled, AccessFailedCount, UserName) VALUES (N'992accc7-1782-4479-a6c9-769b535f54f3', N'joe@us.gov', 0, N'ANsWoqHHJiP9Cl6iN/Z9il8kF7aKgxhu3qayndYGzj7VVwVZsCbeTU+wqugYpoACjQ==', N'fee26031-970c-4bb3-b518-eafa95fa5b2d', NULL, 0, 0, NULL, 1, 0, N'joe@us.gov')
INSERT AspNetUsers (Id, Email, EmailConfirmed, PasswordHash, SecurityStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEndDateUtc, LockoutEnabled, AccessFailedCount, UserName) VALUES (N'ee7910f2-351b-4d30-abb1-1850d5c5831c', N'Averell@us.gov', 0, N'AIdiguWQI19fK3pRsT1qlDmIEAaWOl6jft+HCgSLBmW+9tHeGRj9aH4L2SBbdWoEDA==', N'b64871b7-c785-4c46-a54a-5cd9810d7e78', NULL, 0, 0, NULL, 1, 0, N'Averell@us.gov')
GO

SET IDENTITY_INSERT ScraspRoles ON 
INSERT ScraspRoles (id, roleName) VALUES (1, N'Non défini')
INSERT ScraspRoles (id, roleName) VALUES (2, N'Développement')
INSERT ScraspRoles (id, roleName) VALUES (3, N'Management')
INSERT ScraspRoles (id, roleName) VALUES (4, N'Infrastructure')
SET IDENTITY_INSERT ScraspRoles OFF
GO

SET IDENTITY_INSERT ScraspUsers ON 
INSERT ScraspUsers (id, AspNetUsers_id, username, ScraspRoles_id) VALUES (1, N'992accc7-1782-4479-a6c9-769b535f54f3', N'joe', 1)
INSERT ScraspUsers (id, AspNetUsers_id, username, ScraspRoles_id) VALUES (2, N'3b61deb3-2220-45d9-896d-1c04d41a33bc', N'jack', 1)
INSERT ScraspUsers (id, AspNetUsers_id, username, ScraspRoles_id) VALUES (3, N'74e37cf8-6adb-4bd6-9fc9-ebab2ee2329e', N'william', 1)
INSERT ScraspUsers (id, AspNetUsers_id, username, ScraspRoles_id) VALUES (4, N'ee7910f2-351b-4d30-abb1-1850d5c5831c', N'Averell', 1)
SET IDENTITY_INSERT ScraspUsers OFF
GO

SET IDENTITY_INSERT Projects ON 
INSERT Projects (id, title, projectDescription, refRepo) VALUES (1, N'Alpha', N'Premier projet', N'https://github.com/gituser/Alpha.git')
INSERT Projects (id, title, projectDescription, refRepo) VALUES (2, N'Beta', N'Deuxième projet', NULL)
INSERT Projects (id, title, projectDescription, refRepo) VALUES (3, N'Gamma', N'Troisième projet', NULL)
SET IDENTITY_INSERT Projects OFF
GO

SET IDENTITY_INSERT JobStates ON 
INSERT JobStates (id, stateName) VALUES (1, N'Nouveau')
INSERT JobStates (id, stateName) VALUES (2, N'Assigné')
INSERT JobStates (id, stateName) VALUES (3, N'En cours')
INSERT JobStates (id, stateName) VALUES (4, N'Terminé')
INSERT JobStates (id, stateName) VALUES (5, N'En suspens')
SET IDENTITY_INSERT JobStates OFF
GO

SET IDENTITY_INSERT Sprints ON 
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (1, 1, N'Sprint 1', NULL, NULL)
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (2, 2, N'Sprint 2', NULL, NULL)
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (3, 3, N'Sprint 3', NULL, NULL)
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (4, 4, N'Sprint 4', NULL, NULL)
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (5, 5, N'Sprint 5', NULL, NULL)
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (6, 6, N'Sprint 6', NULL, NULL)
SET IDENTITY_INSERT Sprints OFF
GO

SET IDENTITY_INSERT StoryTypes ON 
INSERT StoryTypes (id, typeName) VALUES (1, N'User')
INSERT StoryTypes (id, typeName) VALUES (2, N'Technical')
SET IDENTITY_INSERT StoryTypes OFF
GO

SET IDENTITY_INSERT StoryStates ON 
INSERT StoryStates (id, stateName) VALUES (1, N'Nouvelle')
INSERT StoryStates (id, stateName) VALUES (2, N'Discussion')
INSERT StoryStates (id, stateName) VALUES (3, N'Validée')
INSERT StoryStates (id, stateName) VALUES (4, N'Rejetée')
SET IDENTITY_INSERT StoryStates OFF
GO

SET IDENTITY_INSERT Stories ON 
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (2, N'Login', N'user', N'me connecter', 1, 4, NULL, 2, 3)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (4, N'Logout', N'user', N'me déconnecter', 1, 4, NULL, 2, 2)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (6, N'Annulation d''abonnement', N'user', N'supprimer mon abonnement', 1, 3, NULL, 2, 5)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (7, N'Backup', N'admin', N'faire un backup', 2, 2, NULL, 2, 7)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (8, N'Achats', N'user', N'faire un achat sur le site', 1, 3, NULL, 1, 5)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (9, N'Vente', N'user', N'mettre en vente', 1, 4, NULL, 1, 4)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (10, N'Location', N'user', N'louer un espace', 1, 4, NULL, 1, 4)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (11, N'Restore', N'admin', N'recharger la db', 2, 3, NULL, 1, 3)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (12, N'Email', N'user', N'envoyer email ', 1, 1, NULL, 3, 3)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (13, N'SMS', N'user', N'envoyer sms', 1, 2, NULL, 3, 4)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (14, N'whatsapp', N'user', N'envoyer whatsapp', 1, 2, NULL, 3, 4)
SET IDENTITY_INSERT Stories OFF
GO

SET IDENTITY_INSERT Jobs ON 
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (1, N'Coder Classe A', NULL, NULL, 1, 2, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (2, N'Coder Classe B', NULL, NULL, 2, 4, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (3, N'Coder Classe C', NULL, NULL, 3, 6, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (4, N'Coder Classe D', NULL, NULL, 2, 8, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (5, N'Coder Classe E', NULL, NULL, 3, 10, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (6, N'Tester Classe A', NULL, NULL, 4, 12, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (7, N'Tester Classe B', NULL, NULL, 3, 14, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (8, N'Tester Classe C', NULL, NULL, 4, 2, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (9, N'Tester Classe D', NULL, NULL, 1, 6, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (10, N'Documenter module XYZ', NULL, NULL, 2, 7, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (11, N'Documenter module HAG', NULL, NULL, 5, 8, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (12, N'Documenter module LAK', NULL, NULL, 1, 9, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (13, N'Installer Machine X', NULL, NULL, 2, NULL, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (14, N'Installer Machine Y', NULL, NULL, 5, 10, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (15, N'Installer Machine Z', NULL, NULL, 3, NULL, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (16, N'Installer Machine T', NULL, NULL, 4, 9, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (17, N'Organiser réunion Berlin', NULL, NULL, 1, NULL, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (18, N'Organiser réunion Madrid', NULL, NULL, 3, 12, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (19, N'Organiser réunion Milan', NULL, NULL, 3, NULL, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (20, N'Organiser réunion Bern', NULL, NULL, 2, 7, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (21, N'Organiser réunion Bullet', NULL, NULL, 3, NULL, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (22, N'Debugger dll Pink', NULL, NULL, 2, 14, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (23, N'Debugger dll Red', NULL, NULL, 5, 2, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (24, N'Debugger dll blue', NULL, NULL, 3, 4, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (25, N'Debugger dll black', NULL, NULL, 2, 6, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (26, N'Balayer', NULL, NULL, 1, 2, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (27, N'Coder Classe Bqwe', NULL, NULL, 3, 6, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (28, N'Coder Classe Cw', NULL, NULL, 2, 6, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (29, N'Coder Classe Dqqw', NULL, NULL, 1, 13, 3)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (30, N'Coder Classe Ee', NULL, NULL, 3, 10, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (31, N'Tester Classe dea', NULL, NULL, 2, 14, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (32, N'Tester Classe Lokm', NULL, NULL, 1, 6, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (33, N'Tester Classe 66', NULL, NULL, 2, 11, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (34, N'Tester Classe Dsa', NULL, NULL, 3, 11, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (35, N'Documenter module SS', NULL, NULL, 4, 11, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (36, N'Documenter module HFS', NULL, NULL, 5, 2, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (37, N'Documenter module HEE', NULL, NULL, 5, 2, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (38, N'Installer Machine J', NULL, NULL, 3, 8, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (39, N'Installer Machine O', NULL, NULL, 1, 10, 3)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (40, N'Installer Machine ZIU', NULL, NULL, 1, NULL, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (41, N'Organiser réunion Prague', NULL, NULL, 2, 2, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (42, N'Organiser réunion Turin', NULL, NULL, 3, NULL, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (43, N'Organiser réunion Schaffouse', NULL, NULL, 4, 9, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (44, N'Organiser réunion Mies', NULL, NULL, 3, NULL, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (45, N'Debugger dll Green', NULL, NULL, 4, 7, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (46, N'Debugger dll sas', NULL, NULL, 5, 13, 3)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (47, N'Debugger dll asa', NULL, NULL, 4, 13, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (48, N'Debugger dll hhhg', NULL, NULL, 3, 6, NULL)
SET IDENTITY_INSERT Jobs OFF
GO

INSERT __MigrationHistory (MigrationId, ContextKey, Model, ProductVersion) VALUES (N'201802141722056_InitialCreate', N'Scrasp.Models.ApplicationDbContext', 0x1F8B0800000000000400DD5C5B6FE3B6127E3FC0F90F829E7A0E522B97B38B6D60EF2275929EA09B0BD6D9A26F0B5AA21D61254A95A83441D15FD687FEA4FE850E254A166FBAD88AED140B2C2272F8CD70382487C3A1FFFAE3CFF187A730B01E7192FA1199D847A343DBC2C48D3C9F2C27764617DFBEB33FBCFFF7BFC6175EF864FD54D29D303A6849D289FD40697CEA38A9FB8043948E42DF4DA2345AD0911B850EF222E7F8F0F03BE7E8C8C100610396658D3F6584FA21CE3FE0731A1117C73443C175E4E120E5E55033CB51AD1B14E234462E9ED8333741693C2A086DEB2CF0110831C3C1C2B61021114514443CFD9CE2194D22B29CC5508082FBE71803DD020529E6A29FAEC8BBF6E2F098F5C259352CA1DC2CA551D813F0E884ABC5919BAFA55CBB521B28EE02144C9F59AF73E54DEC2B0FE7459FA2001420333C9D0609239ED8D7158BB334BEC17454361C15909709C0FD1A255F4775C403AB73BB83CA8C8E4787ECDF8135CD029A257842704613141C5877D93CF0DD1FF1F37DF41593C9C9D17C71F2EECD5BE49DBCFD1F3E7953EF29F415E8840228BA4BA21827201B5E54FDB72D476CE7C80DAB66B5368556C0966046D8D6357AFA88C9923EC05C397E675B97FE13F6CA126E5C9F890F13081AD12483CF9B2C08D03CC055BDD3C893FDDFC0F5F8CDDB41B8DEA0477F990FBDC41F264E02F3EA130EF2DAF4C18F8BE9258CF7174E76994421FB16EDABA8FD328BB2C4659D898C24F72859622A4A377656C6DBC9A419D4F0665DA2EEBF69334955F3D692B20EAD33134A16DB9E0DA5BC2FCBB7B3C59DC5310C5E6E5A4C234D0627EC5323A9E1815554AF0CE6A8ABC110E8C83F79FDBB08911F0CB00076E0026EC7C24F425CF5F2FB08CC0D91DE32DFA13485F9EFFD1FA50F0DA2C39F03883EC36E968059CE280AE317E776F710117C93857366EDDBE335D8D0DCFF1A5D229746C90561AD36C6FB18B95FA38C5E10EF1C51FC99BA2520FBBCF7C3EE00838873E6BA384D2FC198B1378DC0AB2E01AF083D39EE0DC7D6A65D3B20D300F9A1DE039156D12F25E9CA0BD153289E88814CE78D3489FA315AFAA49BA825A959D482A255544ED6575406D64D524E691634276895B3A01ACCBFCB476878072F87DD7F0F6FB3CDDBB416D4D438831512FF80094E6019F3EE10A53821AB11E8B26EECC259C8878F317DF1BD29E7F4130AB2A159AD351BF24560F8D990C3EEFF6CC8C584E247DF635E4987634F490CF09DE8F527AAF6392749B6EDE9207473DBCCB7B30698A6CB599A46AE9FCF024DC08B872B44F9C187B3DA6317456FE4F807740C0CDD675B1E9440DF6CD9A86EC9390E30C5D6995B0404A7287591A7AA113AE4F510ACDC513582ADE220A270FF557882A5E3843542EC1094C24CF50955A7854F5C3F4641AB96A4961DB730D6F78A875C738E634C18C3564D7461AE0F7B30012A3ED2A0B46968ECD42CAED9100D5EAB69CCDB5CD8D5B82BD188ADD8648BEF6CB04BEEBFBD8861366B6C0BC6D9AC922E02184378BB30507E56E96A00F2C165DF0C543A31190C94BB545B315051633B30505125AFCE408B236AD7F197CEABFB669EE24179FBDB7AA3BA76609B823EF6CC340BDF13DA50688113D53CCFE7AC123F51CDE10CE4E4E7B394BBBAB28930F019A662C866E5EF6AFD50A7194436A226C095A1B580F2CB3F054899503D842B63798DD2712FA2076C19776B84E56BBF045BB30115BB7E095A23345F95CAC6D9E9F451F5ACB206C5C83B1D166A381A8390172FB1E31D94628ACBAA8AE9E20BF7F1866B1DE383D1A0A016CFD5A0A4B233836BA934CD762DE91CB23E2ED9465A92DC278396CACE0CAE256EA3ED4AD238053DDC828D54246EE1034DB632D251ED3655DDD829D2A278C1D831E44F8DAF511CFB6459CBA7E225D6AC48A69A7E3BEB9F6A1416188E9B6A328E2A692B4E344AD0124BB5C01A24BDF493949E238AE688C579A65EA89069F756C3F25FB2AC6F9FEA2096FB4049CDFEE637ABC295BDB0CDAA7E086F7E099D0B99339347D03543AF6F6EB1D43614A04413B49F46411612B36F656E5D5CDDD5DB17252AC2D891E4577C2745518A872B6ABDD398A8F361F3F1A9BC96F5C7C80C61D274E973D6756DF243CD286558AA8E620A55ED6CCC4CEE4BD771929DC2FEC3D48AF032B38967A2D40178514F8C5A32830256ABEB8E2AE69BD431C59AEE885252491D52AAEA21653D754410B25EB1169E41A37A8AEE1CD464913ABA5ADB1D5993365287D654AF81AD9159AEEB8EAAC92CA9036BAABB63AFD24CE4F5738FF72BE351659D0DAB38C86EB66319305E66311C66C3ABDDD7D7816AC53DB1F88DBC02C6CBF7D2908CA7B9750CA9085D6C6648060CF37A235C728BCB4DE3CDBC1953B8B91696F4A69B7B335E3F737D51A350CE713249C5BD3ACF49E7B6313F43B53F8E510E5505896D956A04537A4E290E478C6034FB2598063E668B7749708D88BFC0292DB235ECE3C3A363E991CDFE3C7871D2D40B346750D3AB1771CCB69078451E51E23EA0444D83D8E051C80A5489305F110F3F4DECDFF256A779B082FD95171F5857E967E2FF9241C57D9261EB7735AD739824F9E653D59E3E69E8AED5AB9FBF144D0FACDB0466CCA97528E9729D11161F3AF492A668BA81346B3F7F78BD134A7865A0459526C4FA8F0AE63E1DE4414129E537217AFA4F5FD1B48F063642D43C0C180A6F10159A12FFD7C13226FD7BF049F3A4FF7E9DD53F02584734E303009FF40793D3FFBB2F4365CB1D6E359AE3D03696A45CCFADE9D31BE552EE7A6F52B2AC379AE86A26750FB80DB2A5D7B08C5796683CD8EEA8C9231E0C7B97A6FDE2C9C3FB922FBCCAE4D86D9AF03633831BEE81FE5109C17B90C2A649C9D97DDAEFB66DCD14C2DDF3DCC97EC9BD7B666C3C516BF729BCDB3636539877CF8DAD57A2EE9ED9DAAEF6CF1D5B5AE72D74E769B76A0691E12A46170B6E4BAB2D02E770C29F476004854759BC86D4E77135E5A0B6305C9198999A13C864C6CAC451F82A14CD6CFBF5956FF88D9DE534CD6C0D69974DBCF9FADFC89BD334F3362433EE2221589B4EA84BD26E59C79AB29E5E5302B0D093967CF3369FB5F15EFD35E5FB0EA21461F618EE885F4F7AEF202A1972EAF448E755AF7B61EFACFD6222ECDFA9BF5C41B0DF4F24D81576CD8AE68A2CA272F396242A49A408CD35A6C8832DF52CA1FE02B914AA598C397FCE9DC7EDD84DC71C7B57E436A37146A1CB389C0742C08B39014DFCF39C6551E6F16D9CFF32C9105D00317D169BBF25DF677EE055725F6A62420608E65DF0882E1B4BCA22BBCBE70AE926221D81B8FA2AA7E81E87710060E92D99A147BC8E6C607E1FF112B9CFAB08A009A47D2044B58FCF7DB44C5098728C557BF8041BF6C2A7F77F03DD7FB51238540000, N'6.1.3-40302')
GO

/****** Object:  Index RoleNameIndex    Script Date: 05/03/2018 13:12:01 ******/
CREATE UNIQUE NONCLUSTERED INDEX RoleNameIndex ON AspNetRoles
(
	Name ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index IX_UserId    Script Date: 05/03/2018 13:12:01 ******/
CREATE NONCLUSTERED INDEX IX_UserId ON AspNetUserClaims
( 
	UserId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index IX_UserId    Script Date: 05/03/2018 13:12:01 ******/
CREATE NONCLUSTERED INDEX IX_UserId ON AspNetUserLogins
(
	UserId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index IX_RoleId    Script Date: 05/03/2018 13:12:01 ******/
CREATE NONCLUSTERED INDEX IX_RoleId ON AspNetUserRoles
(
	RoleId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index IX_UserId    Script Date: 05/03/2018 13:12:01 ******/
CREATE NONCLUSTERED INDEX IX_UserId ON AspNetUserRoles
(
	UserId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index UserNameIndex    Script Date: 05/03/2018 13:12:01 ******/
CREATE UNIQUE NONCLUSTERED INDEX UserNameIndex ON AspNetUsers
(
	UserName ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
ALTER TABLE AspNetUserClaims  WITH CHECK ADD  CONSTRAINT FK_AspNetUserClaims_AspNetUsers_UserId FOREIGN KEY(UserId)
REFERENCES AspNetUsers (Id)
ON DELETE CASCADE
GO
ALTER TABLE AspNetUserClaims CHECK CONSTRAINT FK_AspNetUserClaims_AspNetUsers_UserId
GO
ALTER TABLE AspNetUserLogins  WITH CHECK ADD  CONSTRAINT FK_AspNetUserLogins_AspNetUsers_UserId FOREIGN KEY(UserId)
REFERENCES AspNetUsers (Id)
ON DELETE CASCADE
GO
ALTER TABLE AspNetUserLogins CHECK CONSTRAINT FK_AspNetUserLogins_AspNetUsers_UserId
GO
ALTER TABLE AspNetUserRoles  WITH CHECK ADD  CONSTRAINT FK_AspNetUserRoles_AspNetRoles_RoleId FOREIGN KEY(RoleId)
REFERENCES AspNetRoles (Id)
ON DELETE CASCADE
GO
ALTER TABLE AspNetUserRoles CHECK CONSTRAINT FK_AspNetUserRoles_AspNetRoles_RoleId
GO
ALTER TABLE AspNetUserRoles  WITH CHECK ADD  CONSTRAINT FK_AspNetUserRoles_AspNetUsers_UserId FOREIGN KEY(UserId)
REFERENCES AspNetUsers (Id)
ON DELETE CASCADE
GO
ALTER TABLE AspNetUserRoles CHECK CONSTRAINT FK_AspNetUserRoles_AspNetUsers_UserId
GO
ALTER TABLE Jobs  WITH CHECK ADD  CONSTRAINT FK__Jobs__JobStates___3587F3E0 FOREIGN KEY(JobStates_id)
REFERENCES JobStates (id)
GO
ALTER TABLE Jobs CHECK CONSTRAINT FK__Jobs__JobStates___3587F3E0
GO
ALTER TABLE Jobs  WITH CHECK ADD  CONSTRAINT FK__Jobs__ScraspUser__37703C52 FOREIGN KEY(ScraspUsers_id)
REFERENCES ScraspUsers (id)
GO
ALTER TABLE Jobs CHECK CONSTRAINT FK__Jobs__ScraspUser__37703C52
GO
ALTER TABLE Jobs  WITH CHECK ADD  CONSTRAINT FK__Jobs__Stories_id__367C1819 FOREIGN KEY(Stories_id)
REFERENCES Stories (id)
GO
ALTER TABLE Jobs CHECK CONSTRAINT FK__Jobs__Stories_id__367C1819
GO
ALTER TABLE ScraspUsers  WITH CHECK ADD FOREIGN KEY(AspNetUsers_id)
REFERENCES AspNetUsers (Id)
GO
ALTER TABLE ScraspUsers  WITH CHECK ADD FOREIGN KEY(ScraspRoles_id)
REFERENCES ScraspRoles (id)
GO
ALTER TABLE Stories  WITH CHECK ADD  CONSTRAINT FK__Stories__Project__30C33EC3 FOREIGN KEY(Projects_id)
REFERENCES Projects (id)
GO
ALTER TABLE Stories CHECK CONSTRAINT FK__Stories__Project__30C33EC3
GO
ALTER TABLE Stories  WITH CHECK ADD  CONSTRAINT FK__Stories__Sprints__2FCF1A8A FOREIGN KEY(Sprints_id)
REFERENCES Sprints (id)
GO
ALTER TABLE Stories CHECK CONSTRAINT FK__Stories__Sprints__2FCF1A8A
GO
ALTER TABLE Stories  WITH CHECK ADD  CONSTRAINT FK__Stories__StorySt__2EDAF651 FOREIGN KEY(StoryStates_id)
REFERENCES StoryStates (id)
GO
ALTER TABLE Stories CHECK CONSTRAINT FK__Stories__StorySt__2EDAF651
GO
ALTER TABLE Stories  WITH CHECK ADD  CONSTRAINT FK__Stories__StoryTy__2DE6D218 FOREIGN KEY(StoryTypes_id)
REFERENCES StoryTypes (id)
GO
ALTER TABLE Stories CHECK CONSTRAINT FK__Stories__StoryTy__2DE6D218
GO
ALTER TABLE Teams  WITH CHECK ADD FOREIGN KEY(Projects_id)
REFERENCES Projects (id)
GO
ALTER TABLE Teams  WITH CHECK ADD FOREIGN KEY(ScraspUsers_id)
REFERENCES ScraspUsers (id)
GO

CREATE TRIGGER AutoCreateScraspUser ON AspNetUsers
AFTER INSERT
AS
BEGIN
	DECLARE new_entries CURSOR FOR
		SELECT Id, Email
		FROM inserted
	OPEN new_entries

	DECLARE @vId AS NVARCHAR(128)
	DECLARE @vEmail AS NVARCHAR(256)
	FETCH NEXT FROM new_entries INTO @vId, @vEmail
	WHILE @@FETCH_STATUS=0
	BEGIN
		INSERT INTO ScraspUsers(AspNetUsers_id, ScraspRoles_id, username) VALUES (@vId, 1, SUBSTRING(@vEmail,1,CHARINDEX('@',@vEmail)-1))
		FETCH NEXT FROM new_entries INTO @vId, @vEmail
	END

	CLOSE new_entries
	DEALLOCATE new_entries
END
GO

USE master
GO
ALTER DATABASE Scrasp SET  READ_WRITE 
GO

SET NOCOUNT ON

INSERT AspNetUsers (Id, Email, EmailConfirmed, PasswordHash, SecurityStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEndDateUtc, LockoutEnabled, AccessFailedCount, UserName) VALUES (N'3b61deb3-2220-45d9-896d-1c04d41a33bc', N'jack@us.gov', 0, N'ACcpS9k7bv7NtwmJdoVAvnzXXSoc1e7KI4ARu+nIfpsu+VaPP37speCc9y5FUJPHHw==', N'0af37c13-db3b-415c-901c-27c0fc2d1f19', NULL, 0, 0, NULL, 1, 0, N'jack@us.gov')
INSERT AspNetUsers (Id, Email, EmailConfirmed, PasswordHash, SecurityStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEndDateUtc, LockoutEnabled, AccessFailedCount, UserName) VALUES (N'74e37cf8-6adb-4bd6-9fc9-ebab2ee2329e', N'william@us.gov', 0, N'AP/I7R6pQuupLgg5pxexYJOrsMzNPozrwRa2C33es8EyCN0q7jTj9iC8RCxo7GzMCQ==', N'54238b94-ecf0-4ef8-9146-b04172bce207', NULL, 0, 0, NULL, 1, 0, N'william@us.gov')
INSERT AspNetUsers (Id, Email, EmailConfirmed, PasswordHash, SecurityStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEndDateUtc, LockoutEnabled, AccessFailedCount, UserName) VALUES (N'992accc7-1782-4479-a6c9-769b535f54f3', N'joe@us.gov', 0, N'ANsWoqHHJiP9Cl6iN/Z9il8kF7aKgxhu3qayndYGzj7VVwVZsCbeTU+wqugYpoACjQ==', N'fee26031-970c-4bb3-b518-eafa95fa5b2d', NULL, 0, 0, NULL, 1, 0, N'joe@us.gov')
INSERT AspNetUsers (Id, Email, EmailConfirmed, PasswordHash, SecurityStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEndDateUtc, LockoutEnabled, AccessFailedCount, UserName) VALUES (N'ee7910f2-351b-4d30-abb1-1850d5c5831c', N'Averell@us.gov', 0, N'AIdiguWQI19fK3pRsT1qlDmIEAaWOl6jft+HCgSLBmW+9tHeGRj9aH4L2SBbdWoEDA==', N'b64871b7-c785-4c46-a54a-5cd9810d7e78', NULL, 0, 0, NULL, 1, 0, N'Averell@us.gov')
GO

SET IDENTITY_INSERT ScraspRoles ON 
INSERT ScraspRoles (id, roleName) VALUES (1, N'Non défini')
INSERT ScraspRoles (id, roleName) VALUES (2, N'Développement')
INSERT ScraspRoles (id, roleName) VALUES (3, N'Management')
INSERT ScraspRoles (id, roleName) VALUES (4, N'Infrastructure')
SET IDENTITY_INSERT ScraspRoles OFF
GO

SET IDENTITY_INSERT ScraspUsers ON 
INSERT ScraspUsers (id, AspNetUsers_id, username, ScraspRoles_id) VALUES (1, N'992accc7-1782-4479-a6c9-769b535f54f3', N'joe', 1)
INSERT ScraspUsers (id, AspNetUsers_id, username, ScraspRoles_id) VALUES (2, N'3b61deb3-2220-45d9-896d-1c04d41a33bc', N'jack', 1)
INSERT ScraspUsers (id, AspNetUsers_id, username, ScraspRoles_id) VALUES (3, N'74e37cf8-6adb-4bd6-9fc9-ebab2ee2329e', N'william', 1)
INSERT ScraspUsers (id, AspNetUsers_id, username, ScraspRoles_id) VALUES (4, N'ee7910f2-351b-4d30-abb1-1850d5c5831c', N'Averell', 1)
SET IDENTITY_INSERT ScraspUsers OFF
GO

SET IDENTITY_INSERT Projects ON 
INSERT Projects (id, title, projectDescription, refRepo) VALUES (1, N'Alpha', N'Premier projet', N'https://github.com/gituser/Alpha.git')
INSERT Projects (id, title, projectDescription, refRepo) VALUES (2, N'Beta', N'Deuxième projet', NULL)
INSERT Projects (id, title, projectDescription, refRepo) VALUES (3, N'Gamma', N'Troisième projet', NULL)
SET IDENTITY_INSERT Projects OFF
GO

SET IDENTITY_INSERT JobStates ON 
INSERT JobStates (id, stateName) VALUES (1, N'Nouveau')
INSERT JobStates (id, stateName) VALUES (2, N'Assigné')
INSERT JobStates (id, stateName) VALUES (3, N'En cours')
INSERT JobStates (id, stateName) VALUES (4, N'Terminé')
INSERT JobStates (id, stateName) VALUES (5, N'En suspens')
SET IDENTITY_INSERT JobStates OFF
GO

SET IDENTITY_INSERT Sprints ON 
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (1, 1, N'Sprint 1', NULL, NULL)
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (2, 2, N'Sprint 2', NULL, NULL)
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (3, 3, N'Sprint 3', NULL, NULL)
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (4, 4, N'Sprint 4', NULL, NULL)
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (5, 5, N'Sprint 5', NULL, NULL)
INSERT Sprints (id, number, sprintDescription, startDate, endDate) VALUES (6, 6, N'Sprint 6', NULL, NULL)
SET IDENTITY_INSERT Sprints OFF
GO

SET IDENTITY_INSERT StoryTypes ON 
INSERT StoryTypes (id, typeName) VALUES (1, N'User')
INSERT StoryTypes (id, typeName) VALUES (2, N'Technical')
SET IDENTITY_INSERT StoryTypes OFF
GO

SET IDENTITY_INSERT StoryStates ON 
INSERT StoryStates (id, stateName) VALUES (1, N'Nouvelle')
INSERT StoryStates (id, stateName) VALUES (2, N'Discussion')
INSERT StoryStates (id, stateName) VALUES (3, N'Validée')
INSERT StoryStates (id, stateName) VALUES (4, N'Rejetée')
SET IDENTITY_INSERT StoryStates OFF
GO

SET IDENTITY_INSERT Stories ON 
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (2, N'Login', N'user', N'me connecter', 1, 4, NULL, 2, 3)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (4, N'Logout', N'user', N'me déconnecter', 1, 4, NULL, 2, 2)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (6, N'Annulation d''abonnement', N'user', N'supprimer mon abonnement', 1, 3, NULL, 2, 5)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (7, N'Backup', N'admin', N'faire un backup', 2, 2, NULL, 2, 7)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (8, N'Achats', N'user', N'faire un achat sur le site', 1, 3, NULL, 1, 5)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (9, N'Vente', N'user', N'mettre en vente', 1, 4, NULL, 1, 4)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (10, N'Location', N'user', N'louer un espace', 1, 4, NULL, 1, 4)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (11, N'Restore', N'admin', N'recharger la db', 2, 3, NULL, 1, 3)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (12, N'Email', N'user', N'envoyer email ', 1, 1, NULL, 3, 3)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (13, N'SMS', N'user', N'envoyer sms', 1, 2, NULL, 3, 4)
INSERT Stories (id, shortName, actor, storyDescription, StoryTypes_id, StoryStates_id, Sprints_id, Projects_id, points) VALUES (14, N'whatsapp', N'user', N'envoyer whatsapp', 1, 2, NULL, 3, 4)
SET IDENTITY_INSERT Stories OFF
GO

SET IDENTITY_INSERT Jobs ON 
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (1, N'Coder Classe A', NULL, NULL, 1, 2, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (2, N'Coder Classe B', NULL, NULL, 2, 4, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (3, N'Coder Classe C', NULL, NULL, 3, 6, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (4, N'Coder Classe D', NULL, NULL, 2, 8, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (5, N'Coder Classe E', NULL, NULL, 3, 13, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (6, N'Tester Classe A', NULL, NULL, 4, 12, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (7, N'Tester Classe B', NULL, NULL, 3, 14, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (8, N'Tester Classe C', NULL, NULL, 4, 2, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (9, N'Tester Classe D', NULL, NULL, 1, 6, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (10, N'Documenter module XYZ', NULL, NULL, 2, 7, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (11, N'Documenter module HAG', NULL, NULL, 5, 8, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (12, N'Documenter module LAK', NULL, NULL, 1, 12, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (13, N'Installer Machine X', NULL, NULL, 2, NULL, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (14, N'Installer Machine Y', NULL, NULL, 5, 10, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (15, N'Installer Machine Z', NULL, NULL, 3, NULL, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (16, N'Installer Machine T', NULL, NULL, 4, 11, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (17, N'Organiser réunion Berlin', NULL, NULL, 1, NULL, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (18, N'Organiser réunion Madrid', NULL, NULL, 3, 7, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (19, N'Organiser réunion Milan', NULL, NULL, 3, NULL, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (20, N'Organiser réunion Bern', NULL, NULL, 2, 7, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (21, N'Organiser réunion Bullet', NULL, NULL, 3, NULL, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (22, N'Debugger dll Pink', NULL, NULL, 2, 14, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (23, N'Debugger dll Red', NULL, NULL, 5, 13, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (24, N'Debugger dll blue', NULL, NULL, 3, 4, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (25, N'Debugger dll black', NULL, NULL, 2, 8, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (26, N'Balayer', NULL, NULL, 1, 2, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (27, N'Coder Classe Bqwe', NULL, NULL, 3, 14, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (28, N'Coder Classe Cw', NULL, NULL, 2, 6, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (29, N'Coder Classe Dqqw', NULL, NULL, 1, 8, 3)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (30, N'Coder Classe Ee', NULL, NULL, 3, 12, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (31, N'Tester Classe dea', NULL, NULL, 2, 14, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (32, N'Tester Classe Lokm', NULL, NULL, 1, 6, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (33, N'Tester Classe 66', NULL, NULL, 2, 11, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (34, N'Tester Classe Dsa', NULL, NULL, 3, 13, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (35, N'Documenter module SS', NULL, NULL, 4, 11, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (36, N'Documenter module HFS', NULL, NULL, 5, 2, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (37, N'Documenter module HEE', NULL, NULL, 5, 14, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (38, N'Installer Machine J', NULL, NULL, 3, 8, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (39, N'Installer Machine O', NULL, NULL, 1, 10, 3)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (40, N'Installer Machine ZIU', NULL, NULL, 1, NULL, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (41, N'Organiser réunion Prague', NULL, NULL, 2, 2, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (42, N'Organiser réunion Turin', NULL, NULL, 3, NULL, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (43, N'Organiser réunion Schaffouse', NULL, NULL, 4, 12, 4)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (44, N'Organiser réunion Mies', NULL, NULL, 3, NULL, 1)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (45, N'Debugger dll Green', NULL, NULL, 4, 7, NULL)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (46, N'Debugger dll sas', NULL, NULL, 5, 9, 3)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (47, N'Debugger dll asa', NULL, NULL, 4, 9, 2)
INSERT Jobs (id, jobDescription, startDate, endDate, JobStates_id, Stories_id, ScraspUsers_id) VALUES (48, N'Debugger dll hhhg', NULL, NULL, 3, 6, NULL)
SET IDENTITY_INSERT Jobs OFF
GO

-- Compute teams based on tasks
INSERT INTO Teams(Projects_id,ScraspUsers_id)
SELECT Projects_id, ScraspUsers_id
FROM Stories INNER JOIN Jobs ON Stories.id = Stories_id
WHERE ScraspUsers_id IS NOT NULL

/****** Object:  Index RoleNameIndex    Script Date: 05/03/2018 13:12:01 ******/
CREATE UNIQUE NONCLUSTERED INDEX RoleNameIndex ON AspNetRoles
(
	Name ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index IX_UserId    Script Date: 05/03/2018 13:12:01 ******/
CREATE NONCLUSTERED INDEX IX_UserId ON AspNetUserClaims
( 
	UserId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index IX_UserId    Script Date: 05/03/2018 13:12:01 ******/
CREATE NONCLUSTERED INDEX IX_UserId ON AspNetUserLogins
(
	UserId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index IX_RoleId    Script Date: 05/03/2018 13:12:01 ******/
CREATE NONCLUSTERED INDEX IX_RoleId ON AspNetUserRoles
(
	RoleId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index IX_UserId    Script Date: 05/03/2018 13:12:01 ******/
CREATE NONCLUSTERED INDEX IX_UserId ON AspNetUserRoles
(
	UserId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index UserNameIndex    Script Date: 05/03/2018 13:12:01 ******/
CREATE UNIQUE NONCLUSTERED INDEX UserNameIndex ON AspNetUsers
(
	UserName ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
ALTER TABLE AspNetUserClaims  WITH CHECK ADD  CONSTRAINT FK_AspNetUserClaims_AspNetUsers_UserId FOREIGN KEY(UserId)
REFERENCES AspNetUsers (Id)
ON DELETE CASCADE
GO
ALTER TABLE AspNetUserClaims CHECK CONSTRAINT FK_AspNetUserClaims_AspNetUsers_UserId
GO
ALTER TABLE AspNetUserLogins  WITH CHECK ADD  CONSTRAINT FK_AspNetUserLogins_AspNetUsers_UserId FOREIGN KEY(UserId)
REFERENCES AspNetUsers (Id)
ON DELETE CASCADE
GO
ALTER TABLE AspNetUserLogins CHECK CONSTRAINT FK_AspNetUserLogins_AspNetUsers_UserId
GO
ALTER TABLE AspNetUserRoles  WITH CHECK ADD  CONSTRAINT FK_AspNetUserRoles_AspNetRoles_RoleId FOREIGN KEY(RoleId)
REFERENCES AspNetRoles (Id)
ON DELETE CASCADE
GO
ALTER TABLE AspNetUserRoles CHECK CONSTRAINT FK_AspNetUserRoles_AspNetRoles_RoleId
GO
ALTER TABLE AspNetUserRoles  WITH CHECK ADD  CONSTRAINT FK_AspNetUserRoles_AspNetUsers_UserId FOREIGN KEY(UserId)
REFERENCES AspNetUsers (Id)
ON DELETE CASCADE
GO
ALTER TABLE AspNetUserRoles CHECK CONSTRAINT FK_AspNetUserRoles_AspNetUsers_UserId
GO
ALTER TABLE Jobs  WITH CHECK ADD  CONSTRAINT FK__Jobs__JobStates___3587F3E0 FOREIGN KEY(JobStates_id)
REFERENCES JobStates (id)
GO
ALTER TABLE Jobs CHECK CONSTRAINT FK__Jobs__JobStates___3587F3E0
GO
ALTER TABLE Jobs  WITH CHECK ADD  CONSTRAINT FK__Jobs__ScraspUser__37703C52 FOREIGN KEY(ScraspUsers_id)
REFERENCES ScraspUsers (id)
GO
ALTER TABLE Jobs CHECK CONSTRAINT FK__Jobs__ScraspUser__37703C52
GO
ALTER TABLE Jobs  WITH CHECK ADD  CONSTRAINT FK__Jobs__Stories_id__367C1819 FOREIGN KEY(Stories_id)
REFERENCES Stories (id)
GO
ALTER TABLE Jobs CHECK CONSTRAINT FK__Jobs__Stories_id__367C1819
GO
ALTER TABLE ScraspUsers  WITH CHECK ADD FOREIGN KEY(AspNetUsers_id)
REFERENCES AspNetUsers (Id)
GO
ALTER TABLE ScraspUsers  WITH CHECK ADD FOREIGN KEY(ScraspRoles_id)
REFERENCES ScraspRoles (id)
GO
ALTER TABLE Stories  WITH CHECK ADD  CONSTRAINT FK__Stories__Project__30C33EC3 FOREIGN KEY(Projects_id)
REFERENCES Projects (id)
GO
ALTER TABLE Stories CHECK CONSTRAINT FK__Stories__Project__30C33EC3
GO
ALTER TABLE Stories  WITH CHECK ADD  CONSTRAINT FK__Stories__Sprints__2FCF1A8A FOREIGN KEY(Sprints_id)
REFERENCES Sprints (id)
GO
ALTER TABLE Stories CHECK CONSTRAINT FK__Stories__Sprints__2FCF1A8A
GO
ALTER TABLE Stories  WITH CHECK ADD  CONSTRAINT FK__Stories__StorySt__2EDAF651 FOREIGN KEY(StoryStates_id)
REFERENCES StoryStates (id)
GO
ALTER TABLE Stories CHECK CONSTRAINT FK__Stories__StorySt__2EDAF651
GO
ALTER TABLE Stories  WITH CHECK ADD  CONSTRAINT FK__Stories__StoryTy__2DE6D218 FOREIGN KEY(StoryTypes_id)
REFERENCES StoryTypes (id)
GO
ALTER TABLE Stories CHECK CONSTRAINT FK__Stories__StoryTy__2DE6D218
GO
ALTER TABLE Teams  WITH CHECK ADD FOREIGN KEY(Projects_id)
REFERENCES Projects (id)
GO
ALTER TABLE Teams  WITH CHECK ADD FOREIGN KEY(ScraspUsers_id)
REFERENCES ScraspUsers (id)
GO

CREATE TRIGGER AutoCreateScraspUser ON AspNetUsers
AFTER INSERT
AS
BEGIN
	DECLARE new_entries CURSOR FOR
		SELECT Id, Email
		FROM inserted
	OPEN new_entries

	DECLARE @vId AS NVARCHAR(128)
	DECLARE @vEmail AS NVARCHAR(256)
	FETCH NEXT FROM new_entries INTO @vId, @vEmail
	WHILE @@FETCH_STATUS=0
	BEGIN
		INSERT INTO ScraspUsers(AspNetUsers_id, ScraspRoles_id, username) VALUES (@vId, 1, SUBSTRING(@vEmail,1,CHARINDEX('@',@vEmail)-1))
		FETCH NEXT FROM new_entries INTO @vId, @vEmail
	END

	CLOSE new_entries
	DEALLOCATE new_entries
END
GO

USE master
GO
ALTER DATABASE Scrasp SET  READ_WRITE 
GO

SET NOCOUNT OFF
