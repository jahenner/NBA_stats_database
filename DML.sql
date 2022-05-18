SELECT Teams.name, Teams.mascot, Cities.name as location FROM Teams
JOIN Cities on Cities.city_id=Teams.location;

SELECT Players.first_name, Players.last_name, Players.age, Players.career_points, Players.career_steals, Players.career_blocks, Players.career_rebounds, Cities.name as hometown, Teams.name as curr_team FROM Players
JOIN Cities ON Players.hometown = Cities.city_id
LEFT JOIN Teams ON Players.current_team = Teams.team_id;

SELECT CONCAT(Players.first_name, ' ', Players.last_name) AS player_name, Games.date, IF(Players.current_team=Teams_has_Games.home_team_id, Teams_has_Games.home_team_id, Teams_has_Games.away_team_id) as opposing_team, Players_has_Games.rebounds, Players_has_Games.blocks, Players_has_Games.steals, Players_has_Games.turnovers, Players_has_Games.minutes_played, Players_has_Games.started_game, Players_has_Games.freethrows_attempt, Players_has_Games.freethrows_made, Players_has_Games.field_goals_attempt, Players_has_Games.field_goals_made, Players_has_Games.3_points_attempt, Players_has_Games.3_points_made, Players_has_Games.assists, Players_has_Games.fouls FROM Players_has_Games
JOIN Players ON Players_has_Games.player_id = Players.player_id
JOIN Games ON Games.game_id=Players_has_Games.game_id
JOIN Teams_has_Games ON Teams_has_Games.game_id=Games.game_id;

SELECT * FROM Players
WHERE age >= 30
and  (career_blocks >= 6 or career_rebounds >= 10)
and  ( 10 >= current_team >= 1)
and  (first_name like '%R%' or first_name like '%D%' or last_name like '%Westbrook%');

SELECT name, population FROM Cities;

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