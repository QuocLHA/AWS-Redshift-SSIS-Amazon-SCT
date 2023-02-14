use DEP304x_ASM3_Netflix_DW
go

-- table show time load
drop table tbDataLoaders_pro

create table tbDataLoaders_pro(
	DateLog varchar(255),
	DataLoader varchar(255),
	StartDateTime datetime,
	EndDateTime datetime
)

INSERT INTO tbDataLoaders_pro (DateLog,DataLoader,StartDateTime)
VALUES (CONVERT(VARCHAR(12),GETDATE(),112),'TimeDataLoaderOne Package',GETDATE())

-- drop all table
drop table dim_country_pro
drop table dim_date_pro
drop table dim_director_pro
drop table dim_duration_pro
drop table dim_info_pro
drop table dim_rating_pro
drop table dim_type_pro
drop table fact_netflix_show_pro

-- create table
create table dim_country_pro (
	countryID int identity(1,1) primary key,
	country varchar(255)
)
go

create table dim_director_pro (
	directorID int identity(1,1) primary key,
	director nvarchar(255)
)
go

create table dim_date_pro (
	dateID int identity(1,1) primary key,
	date_added varchar(255),
	release_year varchar(255)
)
go

create table dim_rating_pro (
	ratingID int identity(1,1) primary key,
	rating varchar(255)
)
go

create table dim_type_pro (
	typeID int identity(1,1) primary key,
	type varchar(255)
)
go

create table dim_duration_pro (
	durationID int identity(1,1) primary key,
	duration varchar(255)
)
go

create table dim_info_pro (
	infoID int identity(1,1) primary key,
	title nvarchar(255),
	listed_in nvarchar(255),
	description nvarchar(1000),
	cast nvarchar(2000)
)
go

create table fact_netflix_show_pro (
	show_id int primary key,
	countryID int,
	dateID int,
	directorID int,
	durationID int,
	infoID int,
	ratingID int,
	typeID int
)
go

--create stored procedures
CREATE OR ALTER PROCEDURE LOAD_DIM_COUNTRY
AS
INSERT INTO dbo.dim_country_pro (country)
	SELECT DISTINCT source.country
	FROM DEP304x_ASM3_Source.dbo.netflix_shows_clean source
	WHERE NOT EXISTS (
	SELECT 1 FROM dbo.dim_country_pro dim
	WHERE dim.country = source.country
	)
	order by country;
GO

CREATE OR ALTER PROCEDURE LOAD_DIM_DATE
AS
INSERT INTO dbo.dim_date_pro (date_added, release_year)
	SELECT DISTINCT source.date_added, source.release_year
	FROM DEP304x_ASM3_Source.dbo.netflix_shows_clean source
	WHERE NOT EXISTS (
	SELECT 1 FROM dbo.dim_date_pro dim
	WHERE dim.date_added = source.date_added AND dim.release_year = source.release_year
	)
	order by date_added, release_year;
GO

CREATE OR ALTER PROCEDURE LOAD_DIM_DIRECTOR
AS
INSERT INTO dbo.dim_director_pro (director)
	SELECT DISTINCT source.director
	FROM DEP304x_ASM3_Source.dbo.netflix_shows_clean source
	WHERE NOT EXISTS (
	SELECT 1 FROM dbo.dim_director_pro dim
	WHERE dim.director = source.director 
	)
	order by director;
GO

CREATE OR ALTER PROCEDURE LOAD_DIM_DURATION
AS
INSERT INTO dbo.dim_duration_pro (duration)
	SELECT DISTINCT source.duration
	FROM DEP304x_ASM3_Source.dbo.netflix_shows_clean source
	WHERE NOT EXISTS (
	SELECT 1 FROM dbo.dim_duration_pro dim
	WHERE dim.duration = source.duration 
	)
	order by duration;
GO

CREATE OR ALTER PROCEDURE LOAD_DIM_INFO
AS
INSERT INTO dbo.dim_info_pro (title, listed_in, description, cast)
	SELECT DISTINCT source.title, source.listed_in, source.description, source.cast
	FROM DEP304x_ASM3_Source.dbo.netflix_shows_clean source
	WHERE NOT EXISTS (
	SELECT 1 FROM dbo.dim_info_pro dim
	WHERE dim.title = source.title
	AND dim.listed_in = source.listed_in
	AND dim.description = source.description
	AND dim.cast = source.cast
	)
	order by title, listed_in, description, cast;
GO

CREATE OR ALTER PROCEDURE LOAD_DIM_RATING
AS
INSERT INTO dbo.dim_rating_pro (rating)
	SELECT DISTINCT source.rating
	FROM DEP304x_ASM3_Source.dbo.netflix_shows_clean source
	WHERE NOT EXISTS (
	SELECT 1 FROM dbo.dim_rating_pro dim
	WHERE dim.rating = source.rating 
	)
	order by rating;
GO

CREATE OR ALTER PROCEDURE LOAD_DIM_TYPE
AS
INSERT INTO dbo.dim_type_pro (type)
	SELECT DISTINCT source.type
	FROM DEP304x_ASM3_Source.dbo.netflix_shows_clean source
	WHERE NOT EXISTS (
	SELECT 1 FROM dbo.dim_type_pro dim
	WHERE dim.type = source.type 
	)
	order by type;
GO

CREATE OR ALTER PROCEDURE LOAD_FACT_NETFLIX_SHOWS
AS 
INSERT INTO dbo.fact_netflix_show_pro (show_id,countryID, dateID, directorID, durationID, infoID, ratingID, typeID)
SELECT show_id,countryID, dateID, directorID, durationID, infoID, ratingID, typeID
FROM DEP304x_ASM3_Source.dbo.netflix_shows_clean source
LEFT JOIN dbo.dim_info_pro
ON dbo.dim_info_pro.cast = source.cast
AND dbo.dim_info_pro.description = source.description
AND dbo.dim_info_pro.listed_in = source.listed_in
AND dbo.dim_info_pro.title = source.title
LEFT JOIN dbo.dim_type_pro ON dim_type_pro.type = source.type
LEFT JOIN dbo.dim_director_pro ON dim_director_pro.director = source.director
LEFT JOIN dbo.dim_country_pro ON dim_country_pro.country = source.country
LEFT JOIN dbo.dim_date_pro
ON dim_date_pro.date_added = source.date_added
AND dim_date_pro.release_year = source.release_year
LEFT JOIN dbo.dim_rating_pro ON dim_rating_pro.rating = source.rating
LEFT JOIN dbo.dim_duration_pro ON dim_duration_pro.duration = source.duration

GO

-- execute stored procedures
exec LOAD_DIM_COUNTRY
go
exec LOAD_DIM_DATE
go
exec LOAD_DIM_DIRECTOR
go
exec LOAD_DIM_DURATION
go
exec LOAD_DIM_INFO
go
exec LOAD_DIM_RATING
go
exec LOAD_DIM_TYPE
go
exec LOAD_FACT_NETFLIX_SHOWS
go

--show time load
UPDATE tbDataLoaders_pro
SET EndDateTime = GETDATE()
WHERE DateLog = CONVERT(VARCHAR(12),GETDATE(),112)

select * from tbDataLoaders_pro