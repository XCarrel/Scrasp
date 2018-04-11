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
