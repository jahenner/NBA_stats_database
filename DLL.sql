SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- -----------------------------------------------------
-- Schema NBA_stats
-- -----------------------------------------------------
-- CREATE SCHEMA IF NOT EXISTS `NBA_stats` DEFAULT CHARACTER SET utf8 ;
-- USE `NBA_stats` ;
DROP TABLES IF EXISTS Cities, Games, Players, Players_has_Games, Teams, Teams_has_Games;
-- -----------------------------------------------------
-- Table `NBA_stats`.`Cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cities` (
  `city_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(145) NULL,
  `population` INT NULL,
  PRIMARY KEY (`city_id`),
  UNIQUE INDEX `city_id_UNIQUE` (`city_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `NBA_stats`.`Teams`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Teams` (
  `team_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `mascot` VARCHAR(145),
  `location` INT NOT NULL,
  PRIMARY KEY (`team_id`, `location`),
  UNIQUE INDEX `team_id_UNIQUE` (`team_id` ASC) VISIBLE,
  INDEX `fk_Teams_Cities_idx` (`location` ASC) VISIBLE,
  CONSTRAINT `fk_Teams_Cities`
    FOREIGN KEY (`location`)
    REFERENCES `Cities` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `NBA_stats`.`Games`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Games` (
  `game_id` INT NOT NULL AUTO_INCREMENT,
  `date` VARCHAR(45) NULL,
  PRIMARY KEY (`game_id`),
  UNIQUE INDEX `game_id_UNIQUE` (`game_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `NBA_stats`.`Teams_has_Games`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Teams_has_Games` (
  `home_team_id` INT NOT NULL,
  `away_team_id` INT NOT NULL,
  `game_id` INT NOT NULL,
  `home_team_score` INT NULL,
  `away_team_score` INT NULL,
  PRIMARY KEY (`away_team_id`, `game_id`, `home_team_id`),
  INDEX `fk_Teams_has_Games_Games1_idx` (`game_id` ASC) VISIBLE,
  INDEX `fk_Teams_has_Games_Home_idx` (`home_team_id` ASC) VISIBLE,
  INDEX `fk_Teams_has_Games_Away_idx` (`away_team_id` ASC) VISIBLE,
  CONSTRAINT `fk_Teams_has_Games_Home`
    FOREIGN KEY (`home_team_id`)
    REFERENCES `Teams` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Teams_has_Games_Away`
    FOREIGN KEY (`away_team_id`)
    REFERENCES `Teams` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Teams_has_Games_Games1`
    FOREIGN KEY (`game_id`)
    REFERENCES `Games` (`game_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `NBA_stats`.`Players`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Players` (
  `player_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(100) NULL,
  `last_name` VARCHAR(100) NULL,
  `age` INT NULL,
  `career_points` INT NULL,
  `career_steals` INT NULL,
  `career_blocks` INT NULL,
  `career_rebounds` INT NULL,
  `hometown` INT NOT NULL,
  `current_team` INT NULL,
  PRIMARY KEY (`player_id`, `current_team`, `hometown`),
  UNIQUE INDEX `player_id_UNIQUE` (`player_id` ASC) VISIBLE,
  INDEX `fk_Players_Cities1_idx` (`hometown` ASC) VISIBLE,
  INDEX `fk_Players_Teams1_idx` (`current_team` ASC) VISIBLE,
  CONSTRAINT `fk_Players_Cities1`
    FOREIGN KEY (`hometown`)
    REFERENCES `Cities` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Players_Teams1`
    FOREIGN KEY (`current_team`)
    REFERENCES `Teams` (`team_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `NBA_stats`.`Players_has_Games`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Players_has_Games` (
  `player_id` INT NOT NULL,
  `game_id` INT NOT NULL,
  `rebounds` INT NULL,
  `blocks` INT NULL,
  `steals` INT NULL,
  `turnovers` INT NULL,
  `minutes_played` VARCHAR(45) NULL,
  `started_game` TINYINT NULL,
  `freethrows_attempt` INT NULL,
  `freethrows_made` INT NULL,
  `field_goals_attempt` INT NULL,
  `field_goals_made` INT NULL,
  `3_points_attempt` INT NULL,
  `3_points_made` INT NULL,
  `assists` INT NULL,
  `fouls` INT NULL,
  PRIMARY KEY (`player_id`, `game_id`),
  INDEX `fk_Players_has_Games_Games1_idx` (`game_id` ASC) VISIBLE,
  INDEX `fk_Players_has_Games_Players1_idx` (`player_id` ASC) VISIBLE,
  CONSTRAINT `fk_Players_has_Games_Players1`
    FOREIGN KEY (`player_id`)
    REFERENCES `Players` (`player_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Players_has_Games_Games1`
    FOREIGN KEY (`game_id`)
    REFERENCES `Games` (`game_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Insert into Cities
-- -----------------------------------------------------
INSERT INTO Cities (name, population)
VALUES ("Los Angeles", 3967000),
  ("Atlanta", 488800),
  ("Miami", 454279),
  ("Long Beach", 466766),
  ("Gary", 76010);

-- -----------------------------------------------------
-- Insert into Games
-- -----------------------------------------------------
INSERT INTO Games (date)
VALUES ("2022-01-07"),
  ("2022-01-30"),
  ("2022-04-26");

-- -----------------------------------------------------
-- Insert into Teams
-- -----------------------------------------------------
INSERT INTO Teams (name, mascot, location)
VALUES ("Lakers", NULL, (select city_id from Cities where name="Los Angeles")),
  ("Heat", "Burnie", (select city_id from Cities where name="Miami")),
  ("Clippers", "Chuck The Condor", (select city_id from Cities where name="Los Angeles")),
  ("Hawks", "Harry The Hawk", (select city_id from Cities where name="Atlanta"));

-- -----------------------------------------------------
-- Insert into Players
-- -----------------------------------------------------
INSERT INTO Players (first_name, last_name, age, career_points, career_steals, career_blocks, career_rebounds, hometown, current_team)
VALUES ("Russell", "Westbrook", 33, 23279,	1736,	306,	7555,	(select city_id from Cities where name="Long Beach"), (select team_id from Teams where name="Lakers")),
  ("Chet", "Aubuchon", -1, 66,	0,	0,	0, (select city_id from Cities where name="Gary"), NULL),
  ("Delon", "Wright", 30,	2959,	493,	164,	1315, (select city_id from Cities where name="Los Angeles"), (select team_id from Teams where name="Hawks"));

-- -----------------------------------------------------
-- Insert into Teams_has_Games
-- -----------------------------------------------------
INSERT INTO Teams_has_Games (home_team_id, away_team_id, game_id, home_team_score, away_team_score)
VALUES ((select team_id from Teams where name="Lakers"), (select team_id from Teams where name="Hawks"), (select game_id from Games where date="2022-01-07"), 134, 118),
  ((select team_id from Teams where name="Hawks"), (select team_id from Teams where name="Lakers"), (select game_id from Games where date="2022-01-30"), 129, 121),
  ((select team_id from Teams where name="Heat"), (select team_id from Teams where name="Hawks"), (select game_id from Games where date="2022-04-26"), 97, 94);

-- -----------------------------------------------------
-- Insert into Players_has_Games
-- -----------------------------------------------------
INSERT INTO Players_has_Games (player_id,	game_id,	rebounds,	blocks,	steals,	turnovers,	minutes_played,	started_game,	freethrows_attempt,	freethrows_made,	field_goals_attempt,	field_goals_made,	3_points_attempt,	3_points_made,	assists,	fouls)
VALUES ((select player_id from Players where first_name="Russell" and last_name="Westbrook" and hometown=(select city_id from Cities where name="Long Beach") and current_team=(select team_id from Teams where name="Lakers")), (select game_id from Games where date="2022-01-07"), 11,	0,	0,	3,	"31:07",	1,	1,	3,	4,	14,	0,	0,	13,	6),
  ((select player_id from Players where first_name="Russell" and last_name="Westbrook" and hometown=(select city_id from Cities where name="Long Beach") and current_team=(select team_id from Teams where name="Lakers")), (select game_id from Games where date="2022-01-30"), 7,	0,	1,	4,	"35:00",	1,	2,	5,	8,	15,	2,	4,	12,	1),
  ((select player_id from Players where first_name="Delon" and last_name="Wright" and hometown=(select city_id from Cities where name="Los Angeles") and current_team=(select team_id from Teams where name="Hawks")), (select game_id from Games where date="2022-01-07"), 0,	0,	0,	0,	"14:10",	0,	0,	0,	1,	3,	1,	1,	1,	1);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
