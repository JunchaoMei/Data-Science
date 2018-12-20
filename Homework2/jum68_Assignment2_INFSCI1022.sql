# Task 1
CREATE DATABASE movie_tracker;
USE movie_tracker;

# Task 2
CREATE TABLE  movies (
	movie_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
	title VARCHAR(200) NOT NULL,
    release_date DATETIME NOT NULL,
	plot_description VARCHAR(4000) NOT NULL
);
CREATE TABLE  actors (
	actor_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATETIME NOT NULL,
	biography VARCHAR(1000) NOT NULL
);
CREATE TABLE  locations (
	location_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    location_name VARCHAR(100) NOT NULL,
    street_address VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
	state CHAR(2) NOT NULL,
    zip VARCHAR(5) NOT NULL
);

# Task 3
CREATE TABLE  movies_actors (
	movie_id INT NOT NULL,
    actor_id INT NOT NULL
);
ALTER TABLE movies_actors	
	ADD FOREIGN KEY (movie_id)
	REFERENCES movies(movie_id)
	ON DELETE CASCADE	
	ON UPDATE CASCADE;
ALTER TABLE movies_actors	
	ADD FOREIGN KEY (actor_id)
	REFERENCES actors(actor_id)
	ON DELETE CASCADE	
	ON UPDATE CASCADE;
CREATE TABLE  movies_locations (
	movie_id INT NOT NULL,
    location_id INT NOT NULL
);
ALTER TABLE movies_locations	
	ADD FOREIGN KEY (movie_id)
	REFERENCES movies(movie_id)
	ON DELETE CASCADE	
	ON UPDATE CASCADE;
ALTER TABLE movies_locations	
	ADD FOREIGN KEY (location_id)
	REFERENCES locations(location_id)
	ON DELETE CASCADE	
	ON UPDATE CASCADE;

# Task 4
INSERT INTO movies (movie_id, title, release_date, plot_description)
	VALUES
	(1,'Apple','2001-01-01','Apple-plot'),
	(2,'Ball','2002-02-02','Ball-plot'),
	(3,'Candy','2003-03-03','Candy-plot');
    SELECT * FROM movies;
INSERT INTO actors (actor_id, first_name, last_name, birth_date, biography)
	VALUES
	(101,'Amy','Angel','2011-01-01','Amy-bio'),
	(102,'Bob','Brian','2012-02-02','Bob-bio'),
	(103,'Chris','Crystal','2013-03-03','Chris-bio');
    SELECT * FROM actors;
INSERT INTO locations (location_id, location_name, street_address, city, state, zip)
	VALUES
	(1001,'Airport','1111 Ann Avenue','Armstrong','AZ','10202'),
	(1002,'Bedroom','2222 Bates Street','Bowman','BA','10303'),
	(1003,'Court','3333 Charter Lane','Central','CO','10404');
    SELECT * FROM locations;

# Task 5
INSERT INTO movies_actors (movie_id, actor_id)
	VALUES
	(1,101),(1,102),(2,101),(2,103),(3,102);
    SELECT * FROM movies_actors;
INSERT INTO movies_locations (movie_id, location_id)
	VALUES
	(1,1001),(1,1002),(2,1001),(2,1003),(3,1002);
    SELECT * FROM movies_locations;

# Task 6
SELECT * FROM actors
ORDER BY actors.last_name ASC
LIMIT 2;

# Task 7
SELECT location_name, city, street_address
FROM locations
ORDER BY location_name DESC;

# Task 8
SELECT * FROM movies
WHERE release_date BETWEEN '2001-12-31' AND '2003-01-01';

# Task 9
UPDATE locations SET zip = 15217;
SELECT * FROM locations;

# Task 10
DELETE FROM actors
WHERE actor_id = 102;
SELECT * FROM actors;