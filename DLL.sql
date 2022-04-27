SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- -----------------------------------------------------
-- Schema NBA_stats
-- -----------------------------------------------------
-- CREATE SCHEMA IF NOT EXISTS `NBA_stats` DEFAULT CHARACTER SET utf8 ;
-- USE `NBA_stats` ;

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
  `current_team` INT,
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
    ON DELETE NO ACTION
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
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Insert into Cities
-- -----------------------------------------------------
-- INSERT INTO Cities 

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
