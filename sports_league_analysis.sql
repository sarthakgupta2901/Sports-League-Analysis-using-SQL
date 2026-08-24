-- Sports League Analysis using MySQL

CREATE DATABASE sports_league;
USE sports_league;


-- Creating Teams table

CREATE TABLE Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL
);

INSERT INTO Teams (team_id, team_name) VALUES
(1, 'Red Dragons'),
(2, 'Blue Tigers'),
(3, 'Green Sharks'),
(4, 'Yellow Eagles'),
(5, 'Black Panthers'),
(6, 'White Wolves'),
(7, 'Orange Bears'),
(8, 'Purple Lions'),
(9, 'Silver Falcons'),
(10, 'Gold Hawks'),
(11, 'Crimson Hawks'),
(12, 'Azure Foxes'),
(13, 'Emerald Snakes'),
(14, 'Amber Owls'),
(15, 'Ivory Elephants'),
(16, 'Navy Dolphins'),
(17, 'Bronze Rhinos'),
(18, 'Violet Lynxes'),
(19, 'Steel Bulls'),
(20, 'Titan Bears');


-- Creating Players table

CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

INSERT INTO Players (player_id, player_name, team_id) VALUES
(1, 'John Doe', 1),
(2, 'Jane Smith', 2),
(3, 'Michael Brown', 3),
(4, 'Emily Davis', 4),
(5, 'David Wilson', 5),
(6, 'Sarah Moore', 6),
(7, 'James Taylor', 7),
(8, 'Linda Anderson', 8),
(9, 'Robert Lee', 9),
(10, 'Maria Martinez', 10),
(11, 'Chris Evans', 11),
(12, 'Scarlett Johnson', 12),
(13, 'Mark Ruffalo', 13),
(14, 'Jeremy Renner', 14),
(15, 'Tom Holland', 15),
(16, 'Benedict Cumberbatch', 16),
(17, 'Chadwick Boseman', 17),
(18, 'Elizabeth Olsen', 18),
(19, 'Paul Rudd', 19),
(20, 'Tom Hardy', 20);


-- Creating Games table

CREATE TABLE Games (
    game_id INT PRIMARY KEY,
    team1_id INT,
    team2_id INT,
    score_team1 INT,
    score_team2 INT,
    game_date DATE,
    FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
    FOREIGN KEY (team2_id) REFERENCES Teams(team_id)
);

INSERT INTO Games (game_id, team1_id, team2_id, score_team1, score_team2, game_date) VALUES
(1, 1, 2, 5, 3, '2024-11-10'),
(2, 3, 4, 2, 4, '2024-11-11'),
(3, 5, 6, 6, 6, '2024-11-12'),
(4, 7, 8, 3, 3, '2024-11-13'),
(5, 9, 10, 7, 1, '2024-11-14'),
(6, 1, 3, 4, 2, '2024-11-15'),
(7, 2, 4, 5, 5, '2024-11-16'),
(8, 6, 7, 6, 2, '2024-11-17'),
(9, 8, 9, 4, 6, '2024-11-18'),
(10, 5, 10, 7, 3, '2024-11-19'),
(11, 11, 12, 3, 5, '2024-11-20'),
(12, 13, 14, 4, 4, '2024-11-21'),
(13, 15, 16, 7, 6, '2024-11-22'),
(14, 17, 18, 5, 8, '2024-11-23'),
(15, 19, 20, 9, 2, '2024-11-24'),
(16, 11, 13, 6, 5, '2024-11-25'),
(17, 12, 14, 7, 4, '2024-11-26'),
(18, 15, 17, 5, 6, '2024-11-27'),
(19, 16, 18, 8, 7, '2024-11-28'),
(20, 19, 11, 4, 3, '2024-11-29');


-- Creating PlayerStats table

CREATE TABLE PlayerStats (
    stat_id INT PRIMARY KEY,
    player_id INT,
    game_id INT,
    points INT,
    assists INT,
    rebounds INT,
    FOREIGN KEY (player_id) REFERENCES Players(player_id),
    FOREIGN KEY (game_id) REFERENCES Games(game_id)
);

INSERT INTO PlayerStats (stat_id, player_id, game_id, points, assists, rebounds) VALUES
(1, 1, 6, 8, 2, 5),
(2, 2, 7, 6, 4, 3),
(3, 3, 8, 9, 1, 2),
(4, 4, 9, 10, 2, 6),
(5, 5, 10, 12, 3, 4),
(6, 6, 6, 7, 2, 3),
(7, 7, 7, 4, 4, 2),
(8, 8, 8, 5, 3, 7),
(9, 9, 9, 6, 1, 5),
(10, 10, 10, 8, 2, 6),
(11, 1, 3, 3, 1, 4),
(12, 2, 4, 4, 2, 5),
(13, 3, 5, 5, 3, 6),
(14, 4, 6, 6, 1, 3),
(15, 5, 7, 7, 2, 4),
(16, 6, 8, 8, 3, 2),
(17, 7, 9, 9, 4, 3),
(18, 8, 10, 10, 2, 4),
(19, 9, 6, 11, 1, 5),
(20, 10, 7, 12, 3, 6);


-- Question 1: Total points scored by each player

SELECT player_id, SUM(points) AS total_points
FROM PlayerStats
GROUP BY player_id;


-- Question 2: Players who scored between 3 and 6 points

SELECT *
FROM PlayerStats
WHERE points BETWEEN 3 AND 6;


-- Question 3: Players from the same team

SELECT team_id, COUNT(*) AS players
FROM Players
GROUP BY team_id;


-- Question 4: Games played in the last 30 days of the dataset

SELECT game_id, game_date
FROM Games
WHERE game_date >= (
    SELECT MAX(game_date) FROM Games
) - INTERVAL 30 DAY;


-- Question 5: Create a view to summarize player statistics

CREATE VIEW player_summary AS
SELECT player_id,
       SUM(points) AS total_points,
       SUM(assists) AS total_assists,
       SUM(rebounds) AS total_rebounds
FROM PlayerStats
GROUP BY player_id;

SELECT * FROM player_summary;


-- Question 6: Prevent negative points using a trigger

DELIMITER //

CREATE TRIGGER check_points
BEFORE INSERT ON PlayerStats
FOR EACH ROW
BEGIN
    IF NEW.points < 0 THEN
        SET NEW.points = 0;
    END IF;
END //

DELIMITER ;


-- Question 7: Fetch players and their respective teams

SELECT Players.player_name, Teams.team_name
FROM Players
LEFT JOIN Teams
ON Players.team_id = Teams.team_id;


-- Question 8: Total points scored by each team

SELECT Teams.team_name, SUM(PlayerStats.points) AS total_points
FROM Players
JOIN Teams ON Players.team_id = Teams.team_id
JOIN PlayerStats ON Players.player_id = PlayerStats.player_id
GROUP BY Teams.team_name;


-- Question 9: Players who scored more than 5 points

SELECT player_id, points
FROM PlayerStats
WHERE points > 5;


-- Question 10: Assign Sarah Moore to Green Sharks

UPDATE Players
SET team_id = 3
WHERE player_id = 6;


-- Question 11: Delete records where game_id is 5

DELETE FROM PlayerStats
WHERE stat_id = 13;


-- Question 12: Players who scored above the average in Game 6

SELECT player_id, points
FROM PlayerStats
WHERE game_id = 6
AND points > (
    SELECT AVG(points)
    FROM PlayerStats
    WHERE game_id = 6
);


-- Question 13: Top 3 players based on total points

SELECT player_id, SUM(points) AS total_points
FROM PlayerStats
GROUP BY player_id
ORDER BY total_points DESC
LIMIT 3;


-- Question 14: Teams that have won at least one game

SELECT team1_id AS team_id
FROM Games
WHERE score_team1 > score_team2

UNION

SELECT team2_id AS team_id
FROM Games
WHERE score_team2 > score_team1;


-- Question 15: Average rebounds for each team

SELECT Teams.team_name, AVG(PlayerStats.rebounds) AS avg_rebounds
FROM Players
JOIN Teams ON Players.team_id = Teams.team_id
JOIN PlayerStats ON Players.player_id = PlayerStats.player_id
GROUP BY Teams.team_name
ORDER BY avg_rebounds DESC;