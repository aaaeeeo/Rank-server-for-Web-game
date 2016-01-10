# ************************************************************
# Sequel Pro SQL dump
# Version 4499
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: localhost (MySQL 5.7.10)
# Database: gamerank
# Generation Time: 2016-01-09 06:18:14 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `user_id` char(28) NOT NULL,
  `user_name` varchar(20) NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  `head_image` text NOT NULL,
  `register_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


# Dump of table games
# ------------------------------------------------------------

DROP TABLE IF EXISTS `games`;

CREATE TABLE `games` (
  `game_id` int(11) NOT NULL AUTO_INCREMENT,
  `game_name` varchar(20) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `game_token` varchar(10) NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`game_id`),
  UNIQUE KEY `games_game_token_uindex` (`game_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table highScores
# ------------------------------------------------------------

DROP TABLE IF EXISTS `highScores`;

CREATE TABLE `highScores` (
  `user_id` char(28) NOT NULL,
  `game_id` int(11) NOT NULL,
  `score` int(11) DEFAULT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `valid` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`,`game_id`),
  KEY `highScore_games_game_id_fk` (`game_id`),
  CONSTRAINT `highScores_games_game_id_fk` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`),
  CONSTRAINT `highScores_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `log`;

CREATE TABLE `log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `user_id` char(28) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `level` int(11) NOT NULL DEFAULT '0',
  `action` varchar(50) NOT NULL,
  `value` int(11) DEFAULT NULL,
  `IP` varchar(20) NOT NULL,
  `raw_request` text,
  `notes` text,
  `effect` int(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`log_id`),
  KEY `log_games_game_id_fk` (`game_id`),
  KEY `log_users_user_id_fk` (`user_id`),
  CONSTRAINT `log_games_game_id_fk` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`),
  CONSTRAINT `log_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `log_update_score` BEFORE INSERT ON `log` FOR EACH ROW begin
IF new.action='UPLOAD SCORE' THEN
  IF (select count(*) from highScores where game_id=new.game_id AND user_id=new.user_id) =0 THEN
    INSERT INTO highScores(user_id, game_id, score) VALUES (new.user_id, new.game_id, new.value);
    SET new.effect=1;
  ELSEIF (select count(*) from highScores where game_id=new.game_id AND user_id=new.user_id AND score>new.value) =0 THEN
    UPDATE highScores SET score=new.value WHERE game_id=new.game_id AND user_id=new.user_id;
    SET new.effect=2;
  END IF;
END IF;
end */;;
DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;


# Dump of table rank
# ------------------------------------------------------------

DROP VIEW IF EXISTS `rank`;

CREATE TABLE `rank` (
   `game_id` INT(11) NOT NULL,
   `rank` BIGINT(22) NULL DEFAULT NULL,
   `user_id` CHAR(28) NOT NULL,
   `user_name` VARCHAR(20) NOT NULL,
   `score` INT(11) NULL DEFAULT NULL,
   `head_image` TEXT NOT NULL
) ENGINE=MyISAM;



# Replace placeholder table for rank with correct view syntax
# ------------------------------------------------------------

DROP TABLE `rank`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `rank` AS (select `x`.`game_id` AS `game_id`,`x`.`rank` AS `rank`,`x`.`user_id` AS `user_id`,`gamerank`.`users`.`user_name` AS `user_name`,`x`.`score` AS `score`,`gamerank`.`users`.`head_image` AS `head_image` from ((select `a`.`user_id` AS `user_id`,`a`.`game_id` AS `game_id`,`a`.`score` AS `score`,((select count(`gamerank`.`highscores`.`score`) from `gamerank`.`highscores` where ((`gamerank`.`highscores`.`score` > `a`.`score`) and (`gamerank`.`highscores`.`game_id` = `a`.`game_id`) and (`gamerank`.`highscores`.`valid` = TRUE))) + 1) AS `rank` from `gamerank`.`highscores` `a` where (`a`.`valid` = TRUE)) `x` join `gamerank`.`users`) where (`gamerank`.`users`.`user_id` = `x`.`user_id`) order by `x`.`game_id`,`x`.`rank`);

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
