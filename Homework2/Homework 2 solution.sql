#DROP DATABASE movie_tracker;

/* TASK1 */
CREATE DATABASE movie_tracker;
USE movie_tracker;


/* TASK2 */
CREATE TABLE movies (
  movie_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 `title` VARCHAR(30) NOT NULL,
  release_date DATETIME NOT NULL,
  plot_description VARCHAR(4000) NOT NULL
);

CREATE TABLE actors (
  actor_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  birth_date DATETIME NOT NULL,
  biography VARCHAR(1000) NOT NULL
);

CREATE TABLE locations (
  location_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  location_name VARCHAR(100) NOT NULL,
  street_address VARCHAR(150) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state CHAR(2) NOT NULL,
  zip VARCHAR(5) NOT NULL
);


/* TASK3 */
CREATE TABLE movies_actors (
  movie_id INT,
  actor_id INT
);

CREATE TABLE movies_locations (
  movie_id INT,
  location_id INT
);

ALTER TABLE movies_actors
  ADD FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  ADD FOREIGN KEY (actor_id) REFERENCES actors(actor_id)
  ON DELETE CASCADE ON UPDATE CASCADE;
 
ALTER TABLE movies_locations
  ADD FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  ADD FOREIGN KEY (location_id) REFERENCES locations(location_id)
  ON DELETE CASCADE ON UPDATE CASCADE;

/* TASK 4 */
INSERT INTO movie_tracker.movies
(`title`,release_date,plot_description)
VALUES
('Toy Story 1','1995-01-01','The plot involves Andy, an imaginative young suburban boy, getting a new Buzz Lightyear toy, causing Sheriff Woody, a vintage cowboy figure, to think that he has been replaced as Andy\'s favorite toy'),
('Toy Story 2','1999-01-01','The plot involves Woody getting stolen by a greedy toy collector named Al. Buzz and several of Andy\'s toys set off to attempt to free Woody, who meanwhile has discovered his origins as a historic television star.'),
('Toy Story 3','2010-01-01','Set ten years after the events of the second film, the plot focuses on the toys accidentally being dropped off at a daycare center while their owner, Andy, is getting ready to go away to college');


INSERT INTO movie_tracker.actors
(first_name,last_name, birth_date, biography)
VALUES
('Tom','Hanks','1956-01-01','An American actor and filmmaker'),
('Tim','Allen','1953-06-13','An American actor and comedian'),
('Shawn','Wallace','1943-01-01',' An American stand-up comedian, actor, singer, dancer, playwright, essayist, and voice artist');


INSERT INTO movie_tracker.locations
(location_name, street_address, city, state, zip)
VALUES
('Hollywood','1 Hollywood Blvd','Hollywood','CA','111111'),
('CMU Software Engineering Institute','5th Avenue','Pittsburgh','PA','15260'),
('New York Times Square','Time Square','New York','NY','12222');


/* TASK 5 */
INSERT INTO movie_tracker.movies_actors
(movie_id,actor_id)
VALUES
(1,2),
(2,1),
(3,3);

INSERT INTO movie_tracker.movies_locations
(movie_id,location_id)
VALUES
(1,1),
(2,2),
(3,3);


/* TASK 6 */
SELECT * 
FROM movie_tracker.actors
ORDER BY last_name ASC
LIMIT 2;


/* TASK7 */
SELECT *
FROM movie_tracker.locations
ORDER BY location_name DESC;


/* TASK 8 */
SELECT *
FROM movie_tracker.movies
WHERE release_date BETWEEN '2010-06-01' AND '2015-09-01';

/* TASK 9 */
UPDATE movie_tracker.locations
SET zip = '15217';


/* TASK 10 */
DELETE FROM movie_tracker.actors
WHERE actor_id = 1;



