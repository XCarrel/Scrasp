USE Scrasp
GO

-- Drop tables

IF OBJECT_ID('Teams', 'U') IS NOT NULL DROP TABLE Teams;
IF OBJECT_ID('Jobs', 'U') IS NOT NULL DROP TABLE Jobs;
IF OBJECT_ID('JobStates', 'U') IS NOT NULL DROP TABLE JobStates;
IF OBJECT_ID('Stories', 'U') IS NOT NULL DROP TABLE Stories;
IF OBJECT_ID('StoryStates', 'U') IS NOT NULL DROP TABLE StoryStates;
IF OBJECT_ID('StoryTypes', 'U') IS NOT NULL DROP TABLE StoryTypes;
IF OBJECT_ID('Sprints', 'U') IS NOT NULL DROP TABLE Sprints;
IF OBJECT_ID('Projects', 'U') IS NOT NULL DROP TABLE Projects;
IF OBJECT_ID('ScraspUsers', 'U') IS NOT NULL DROP TABLE ScraspUsers;
IF OBJECT_ID('ScraspRoles', 'U') IS NOT NULL DROP TABLE ScraspRoles;

-- Create tables

CREATE TABLE ScraspRoles
(
	id int NOT NULL IDENTITY PRIMARY KEY,
	roleName varchar(15)
)

CREATE TABLE ScraspUsers
(
	id int NOT NULL IDENTITY PRIMARY KEY,
	AspNetUsers_id nvarchar(128) NOT NULL REFERENCES AspNetUsers(Id),
	username varchar(35) NOT NULL,
	ScraspRoles_id int NOT NULL REFERENCES ScraspRoles(id)
);

CREATE TABLE Projects
(
	id int NOT NULL IDENTITY PRIMARY KEY,
	title varchar(35) NOT NULL,
	projectDescription text,
	refRepo varchar(100) -- URL of the repository
);

CREATE TABLE Sprints
(
	id int NOT NULL IDENTITY PRIMARY KEY,
	number int,
	sprintDescription text,
	startDate date, -- Planned 
	endDate date -- Planned
);

CREATE TABLE StoryTypes
(
	id int NOT NULL IDENTITY PRIMARY KEY,
	typeName varchar(15)
)

CREATE TABLE StoryStates
(
	id int NOT NULL IDENTITY PRIMARY KEY,
	stateName varchar(15)
)

CREATE TABLE Stories
(
	id int NOT NULL IDENTITY PRIMARY KEY,
	shortName varchar(15), -- "visible" id
	actor varchar(35) NOT NULL,
	storyDescription text,
	StoryTypes_id int NOT NULL REFERENCES StoryTypes(id),
	StoryStates_id int NOT NULL REFERENCES StoryStates(id),
	Sprints_id int NULL REFERENCES Sprints(id), -- Sprint is null = Story is in the project's backlog
	Projects_id int NOT NULL REFERENCES Projects(id),
	points int
);

CREATE TABLE JobStates
(
	id int NOT NULL IDENTITY PRIMARY KEY,
	stateName varchar(15)
)

CREATE TABLE Jobs
(
	id int NOT NULL IDENTITY PRIMARY KEY,
	jobDescription text,
	startDate date, -- Planned 
	endDate date, -- Planned
	JobStates_id int NOT NULL REFERENCES JobStates(id),
	Stories_id int NOT NULL REFERENCES Stories(id),
	ScraspUsers_id int NOT NULL REFERENCES ScraspUsers(id)
)

CREATE TABLE Teams
(
	id int NOT NULL IDENTITY PRIMARY KEY,
	Projects_id int NOT NULL REFERENCES Projects(id),
	ScraspUsers_id int NOT NULL REFERENCES ScraspUsers(id)
)

GO

-- Data

SET NOCOUNT ON
INSERT INTO ScraspRoles (roleName) VALUES ('Non défini'),('Développement'),('Management'),('Infrastructure');
INSERT INTO JobStates (stateName) VALUES ('Nouveau'),('Assigné'),('En cours'),('Terminé'),('En suspens');
INSERT INTO StoryTypes(typeName) VALUES ('User'),('Technical');
INSERT INTO StoryStates(stateName) VALUES ('Nouvelle'),('Discussion'),('Validée'),('Rejetée');
INSERT INTO ScraspUsers(AspNetUsers_id,username,ScraspRoles_id) SELECT id, Email,1 FROM AspNetUsers;
INSERT INTO Projects(title,projectDescription) VALUES ('Alpha','Premier projet'),('Beta','Deuxième projet'),('Gamma','Troisième projet');
SET NOCOUNT OFF