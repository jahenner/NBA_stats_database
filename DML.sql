SELECT Teams.name, Teams.mascot, Cities.name as location FROM Teams
JOIN Cities on Cities.city_id=Teams.location;

SELECT * FROM Players
WHERE age >= 30
and  (career_blocks >= 6 or career_rebounds >= 10)
and  ( 10 >= current_team >= 1)
and  (first_name like '%R%' or first_name like '%D%' or last_name like '%Westbrook%');

/* Cities Read */
SELECT * FROM Cities;

/* Games Read */
SELECT Games.game_id as game_id, home.team_id as home_id, away.team_id as away_id, Games.date, home.name as home_team, away.name as away_team, Teams_has_Games.home_team_score, Teams_has_Games.away_team_score FROM Teams_has_Games LEFT JOIN Teams home ON Teams_has_Games.home_team_id=home.team_id LEFT JOIN Teams away ON Teams_has_Games.away_team_id=away.team_id JOIN Games ON Games.game_id=Teams_has_Games.game_id;

/* Teams Read */
SELECT Teams.team_id, Teams.name, Teams.mascot, Cities.name as location, Cities.city_id FROM Teams JOIN Cities on Cities.city_id=Teams.location;

/* Players Read */
SELECT Players.player_id, Players.first_name, Players.last_name, Players.age, Players.career_points, Players.career_steals, Players.career_blocks, Players.career_rebounds, Cities.name as hometown, Teams.name as curr_team FROM Players JOIN Cities ON Players.hometown = Cities.city_id LEFT JOIN Teams ON Players.current_team = Teams.team_id;

/* PlayerStats Read */
SELECT CONCAT(Players.first_name, ' ', Players.last_name) AS player_name, Games.date, IF(Players.current_team=Teams_has_Games.home_team_id, Teams_has_Games.home_team_id, Teams_has_Games.away_team_id) as opposing_team, Players_has_Games.rebounds, Players_has_Games.blocks, Players_has_Games.steals, Players_has_Games.turnovers, Players_has_Games.minutes_played, Players_has_Games.started_game, Players_has_Games.freethrows_attempt, Players_has_Games.freethrows_made, Players_has_Games.field_goals_attempt, Players_has_Games.field_goals_made, Players_has_Games.3_points_attempt, Players_has_Games.3_points_made, Players_has_Games.assists, Players_has_Games.fouls FROM Players_has_Games JOIN Players ON Players_has_Games.player_id = Players.player_id JOIN Games ON Games.game_id=Players_has_Games.game_id JOIN Teams_has_Games ON Teams_has_Games.game_id=Games.game_id;

/* Games Update */
SELECT date from Games WHERE game_id=${game_id}
UPDATE Games SET date='${req.body.date}' WHERE game_id=${game_id}
UPDATE Teams_has_Games SET home_team_id=${req.body.home_id}, away_team_id=${req.body.away_id}, home_team_score=${req.body.home_team_score}, away_team_score=${req.body.away_team_score} WHERE game_id=${game_id}

/* City Update */
SELECT * from Cities WHERE city_id=${city_id}
UPDATE Cities SET name='${req.body.name}' WHERE city_id=${city_id}
UPDATE Cities SET population='${req.body.population}' WHERE city_id=${city_id}

/* Teams Update */
UPDATE Teams SET name='${req.body.name}', mascot='${req.body.mascot}', location=${req.body.city_id} WHERE team_id=${team_id}

/* Player Update */
UPDATE Players SET first_name='${req.body.first_name}', last_name='${req.body.last_name}', age=${req.body.age}, career_points=${req.body.career_points}, career_blocks=${req.body.career_blocks}, career_steals=${req.body.career_steals}, career_rebounds=${req.body.career_rebounds}, hometown=${req.body.city_id}, current_team=${req.body.current_team} WHERE player_id=${req.body._id}

/* Games Add */
INSERT INTO Games (date) VALUES ('${req.body.date}');
INSERT INTO Teams_has_Games (home_team_id, away_team_id, game_id, home_team_score, away_team_score) VALUES (${req.body.homeTeam}, ${req.body.awayTeam}, (SELECT max(game_id) from Games), ${req.body.homeScore}, ${req.body.awayScore});

/* Cities Add */
INSERT INTO Cities (name, population) VALUES ('${req.body.name}', '${req.body.population}');

/* Teams Add */
INSERT INTO Teams (name, mascot, location) VALUES ('${req.body.name}', '${req.body.mascot}', '${req.body.location}');

/* Players Add */
INSERT INTO Players(first_name, last_name, age, career_points, career_steals, career_blocks, career_rebounds, hometown, current_team) VALUES ('${req.body.first_name}', '${req.body.last_name}', '${req.body.age}', '${req.body.career_points}', '${req.body.career_steals}', '${req.body.career_blocks}', '${req.body.career_rebounds}', '${req.body.hometown}', '${req.body.current_team}');

/* Games Delete */
DELETE FROM Teams_has_Games WHERE game_id=${game_id}
DELETE FROM Players_has_Games WHERE game_id=${game_id}
DELETE FROM Games WHERE game_id=${game_id}

/* Cities Delete */
DELETE FROM Cities WHERE city_id=${city_id}

/* Teams Delete */
DELETE FROM Teams WHERE team_id=${team_id}





/* Additional Queries for Use/Reference */

SELECT Games.date, home.name as home_team, away.name as away_team, Teams_has_Games.home_team_score, Teams_has_Games.away_team_score
FROM Teams_has_Games
LEFT JOIN Teams home ON Teams_has_Games.home_team_id=home.team_id
LEFT JOIN Teams away ON Teams_has_Games.away_team_id=away.team_id
JOIN Games ON Games.game_id=Teams_has_Games.game_id;

INSERT INTO Players (first_name, last_name, age, career_points, career_steals, career_blocks, career_rebounds, hometown, current_team) 
   VALUES (:fnameInput, :lnameInput, :ageInput, :careerPointsInput, :careerStealsInput, :careerBlocksInput, :careerReboundsInput, :HometownDropDownInput, :currentTeamDropDownInput);

INSERT INTO Teams (name, mascot, location) 
   VALUES (:teamNameInput, :mascotNameInput, :location_from_dropdown_Input);

INSERT INTO Players_has_Games (player, game, rebounds, blocks, steals, turnovers, minutes_played, started_game, freethrow_attempts, freethrows_made, field_goal_attempts, field_goals_made, 3_point_attempts, 3_points_made, assists, fouls) 
   VALUES (:playerNameDropDownInput, :GameNameDropDownInput, :blocksInput, :stealsInput, :turnOversInput, :minutesPlayedInput, :startedGameDropDownInput, :freethrowsAttemptsInput, :freeThrowsMadeInput, :fieldGoalAttemptsInput, :fieldGoalsMadeInput, :3PointAttemptsInput, :3PointsMadeInput, :assistsInput, :foulsInput);

INSERT INTO Cities (name, population) 
   VALUES (:nameInput, :populationInput);

INSERT INTO Games (date) 
   VALUES (:dateInput);

INSERT INTO Teams_has_Games (home_team, away_team, game_id, home_team_score, away_team_score)
   VALUES (:homeTeamDropDown, :awayTeamDropDown, (SELECT game_id FROM Games WHERE date=:dateInput), :homeTeamScoreInput, :awayTeamScoreInput);

DELETE FROM Players WHERE id = :player_ID_selected_from_players_page;

DELETE FROM Teams WHERE id = :team_ID_selected_from_teams_page;

DELETE FROM Players WHERE player_id
= :player_ID_selected_from_players_has_games AND game_id
= :game_ID_selected_from-games;

UPDATE Teams
   SET name = :nameInput, mascot= :mascotInput, 
       location = :location_from_dropdown_Input
   WHERE id= :team_ID_from_the_update_form;

UPDATE Players
   SET first_name = :fnameInput, last_name= :lnameInput, age= :ageInput, career_points: :career_pointsInput, career_steals: :career_stealsInput, career_blocks: :career_blocksInput, 
       career_rebounds: :career_reboundsInput, hometown: :hometownInputDropDownInput, current_team: :current_teamDropDownInput  
   WHERE id= :player_ID_from_the_update_form;