-- Create Movie table
CREATE TABLE Movies (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    yrofrelease INT,
    status VARCHAR(50),
    Censored BOOLEAN
);

-- Create People table
CREATE TABLE People (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    movie_id INT,
    role VARCHAR(50),
    DOB DATE,
    gender VARCHAR(10),
    FOREIGN KEY (movie_id) REFERENCES Movie(id)
);

-- Create Awards table
CREATE TABLE Awards (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    people_id INT,
    movie_id INT,
    yr INT,
    FOREIGN KEY (people_id) REFERENCES People(id),
    FOREIGN KEY (movie_id) REFERENCES Movie(id)
);

-- Inserting sample data into Movie table
INSERT INTO Movies (id, name, yrofrelease, status, Censored) VALUES
(1, 'Movie A', 2019, 'Hit', TRUE),
(2, 'Movie B', 2020, 'Average', FALSE),
(3, 'Movie C', 2021, 'Flop', TRUE);

-- Inserting sample data into People table
INSERT INTO People (id, name, movie_id, role, DOB, gender) VALUES
(1, 'John Doe', 1, 'Actor', '1990-05-15', 'Male'),
(2, 'Jane Smith', 2, 'Actress', '1985-09-20', 'Female'),
(3, 'Alex Johnson', 3, 'Director', '1978-12-10', 'Other'),
(4, 'Michael Williams', 1, 'Director', '1980-03-25', 'Male'),
(5, 'Emily Brown', 2, 'Actor', '1995-07-12', 'Female'),
(6, 'Chris Evans', 3, 'Actor', '1981-06-13', 'Male'),
(7, 'Emma Watson', 1, 'Actress', '1990-04-15', 'Female'),
(8, 'Daniel Craig', 2, 'Actor', '1968-03-02', 'Male'),
(9, 'Kate Winslet', 3, 'Actress', '1975-10-05', 'Female');

-- Inserting sample data into Awards table
INSERT INTO Awards (id, name, people_id, movie_id, yr) VALUES
(1, 'Oscar', 1, 1, 2020),
(2, 'Emmy', 2, 2, 2021),
(3, 'Filmfare', 3, 3, 2022),
(4, 'Oscar', 4, 1, 2020),
(5, 'Emmy', 5, 2, 2021),
(6, 'Filmfare', 6, 3, 2022),
(7, 'Oscar', 7, 1, 2020),
(8, 'Emmy', 8, 2, 2021),
(9, 'Filmfare', 9, 3, 2022);



1. Display the number of hit movies released in a three consecutive year time
range(choose range as per your inserted data)

SELECT COUNT(*) AS NumberOfHits
FROM Movies
WHERE yrofrelease BETWEEN 2019 AND 2021
AND status = 'Hit';

2. Display name and age for all people who won Oscar award when they were
less than 30 yrs old.
SELECT People.name, TIMESTAMPDIFF(YEAR, DOB, SYSDATE()) AS age 
FROM People, Awards 
where Awards.people_id = People.id
and Awards.name = 'Oscar' 
and (Awards.yr - YEAR(DOB)) <= 30;

3. Display movie name and award name for movies which have won Emmy for
actor, actress and director in same year;

SELECT Movies.name, Awards.name, Awards.yr, People.name, People.role  FROM Movies,
 Awards, People WHERE  Movies.id = Awards.movie_id  and Awards.people_id = People.id and
(People.role = 'Actor' OR People.role = 'Actress' OR People.role = 'Director') and Awards
.name = 'Emmy';

SELECT Movies.name, Awards.yr  FROM Movies,
 Awards, People WHERE  Movies.id = Awards.movie_id  and Awards.people_id = People.id and
(People.role = 'Actor' OR People.role = 'Actress' OR People.role = 'Director') and Awards
.name = 'Emmy' group by Awards.yr, Movies.id;

SELECT Movies.name, Awards.name, Awards.yr, COUNT(DISTINCT People.role) 
FROM Movies, Awards, People
WHERE  Movies.id = Awards.movie_id 
	and Awards.people_id = People.id
	and (People.role = 'Actor'
	OR People.role = 'Actress'
	OR People.role = 'Director')
	and Awards.name = 'Emmy'
	GROUP BY Movies.id, Awards.yr
	HAVING COUNT(DISTINCT People.role) = 3;










