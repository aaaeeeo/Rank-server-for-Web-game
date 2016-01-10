# ************************************************************
# Sequel Pro SQL dump
# Version 4499
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: localhost (MySQL 5.7.10)
# Database: gamerank
# Generation Time: 2016-01-10 18:23:04 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table games
# ------------------------------------------------------------

DROP TABLE IF EXISTS `games`;

CREATE TABLE `games` (
  `game_token` varchar(11) NOT NULL DEFAULT '',
  `game_name` varchar(20) NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(100) DEFAULT NULL,
  `add_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`game_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `games` WRITE;
/*!40000 ALTER TABLE `games` DISABLE KEYS */;

INSERT INTO `games` (`game_token`, `game_name`, `disabled`, `description`, `add_time`)
VALUES
	('1','test_game_1',0,NULL,'0000-00-00 00:00:00'),
	('2','test_game_2',0,NULL,'0000-00-00 00:00:00'),
	('3','test_game_3',0,NULL,'0000-00-00 00:00:00');

/*!40000 ALTER TABLE `games` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table highScores
# ------------------------------------------------------------

DROP TABLE IF EXISTS `highScores`;

CREATE TABLE `highScores` (
  `user_id` char(28) NOT NULL,
  `game_token` varchar(11) NOT NULL DEFAULT '',
  `score` int(11) DEFAULT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `valid` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`,`game_token`),
  KEY `highScore_games_game_id_fk` (`game_token`),
  CONSTRAINT `highScores_games_game_token_fk` FOREIGN KEY (`game_token`) REFERENCES `games` (`game_token`),
  CONSTRAINT `highScores_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `highScores` WRITE;
/*!40000 ALTER TABLE `highScores` DISABLE KEYS */;

INSERT INTO `highScores` (`user_id`, `game_token`, `score`, `update_time`, `valid`)
VALUES
	('oXQ7gt9aM1hynR6j6J1Hp5PTB9EQ','1',10,'2016-01-08 00:27:05',1),
	('oXQ7gt9aM1hynR6j6J1Hp5PTB9EQ','2',15,'2016-01-08 00:27:23',1),
	('t2','1',120,'2016-01-10 02:04:03',1),
	('t3','1',20,'2016-01-08 00:46:37',1),
	('t4','1',30,'2016-01-08 00:46:52',1);

/*!40000 ALTER TABLE `highScores` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `log`;

CREATE TABLE `log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `game_token` varchar(11) NOT NULL DEFAULT '',
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
  KEY `log_games_game_id_fk` (`game_token`),
  KEY `log_users_user_id_fk` (`user_id`),
  CONSTRAINT `log_games_game_token_fk` FOREIGN KEY (`game_token`) REFERENCES `games` (`game_token`),
  CONSTRAINT `log_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;

INSERT INTO `log` (`log_id`, `game_token`, `user_id`, `time`, `level`, `action`, `value`, `IP`, `raw_request`, `notes`, `effect`)
VALUES
	(1,'1','t2','2016-01-08 01:24:50',0,'UPLOAD SCORE',40,'1','1',NULL,0),
	(2,'1','t2','2016-01-08 01:28:51',0,'UPLOAD SCORE',9,'1','1',NULL,0),
	(3,'1','t2','2016-01-08 01:29:41',0,'UPLOAD SCORE',8,'1','1',NULL,0),
	(4,'1','t2','2016-01-08 16:33:36',0,'UPLOAD SCORE',100,'1','1',NULL,2),
	(5,'1','t2','2016-01-08 16:33:57',0,'UPLOAD SCORE',50,'1','1',NULL,0),
	(6,'1','t2','2016-01-10 02:04:03',0,'UPLOAD SCORE',120,'2','2',NULL,2),
	(12,'1','t2','2016-01-10 02:56:08',0,'GET RANK',0,'127.0.0.1:51346','raw','',0),
	(18,'1','t2','2016-01-10 03:04:47',0,'GET RANK',0,'127.0.0.1:51346','raw','',0),
	(25,'1','t2','2016-01-10 03:07:00',0,'GET RANK',0,'127.0.0.1:51346','raw','',0),
	(26,'1','t8','2016-01-10 03:11:09',0,'CREATE USER',0,'127.0.0.1:51651','raw','',0),
	(27,'1','t2','2016-01-10 03:13:27',0,'GET RANK',0,'127.0.0.1:51679','(\'127.0.0.1\', 51679)	\nGET /get_rank.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51679)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(28,'1','t2','2016-01-10 03:15:02',0,'GET RANK',0,'127.0.0.1:51712','(\'127.0.0.1\', 51712)	\nGET /get_rank.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51712)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(29,'1','t2','2016-01-10 03:30:36',0,'LOGIN',0,'127.0.0.1:51882','(\'127.0.0.1\', 51882)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51882)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(30,'1','t2','2016-01-10 03:30:36',0,'LOGIN',0,'127.0.0.1:51883','(\'127.0.0.1\', 51883)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51883)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(31,'1','t2','2016-01-10 03:30:36',0,'LOGIN',0,'127.0.0.1:51884','(\'127.0.0.1\', 51884)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51884)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(32,'1','t2','2016-01-10 03:31:56',0,'LOGIN',0,'127.0.0.1:51901','(\'127.0.0.1\', 51901)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51901)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(33,'1','t2','2016-01-10 03:31:56',0,'LOGIN',0,'127.0.0.1:51902','(\'127.0.0.1\', 51902)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51902)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(34,'1','t2','2016-01-10 03:31:56',0,'LOGIN',0,'127.0.0.1:51903','(\'127.0.0.1\', 51903)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51903)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(35,'1','t2','2016-01-10 03:32:22',0,'LOGIN',0,'127.0.0.1:51907','(\'127.0.0.1\', 51907)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51907)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(36,'1','t2','2016-01-10 03:32:22',0,'LOGIN',0,'127.0.0.1:51908','(\'127.0.0.1\', 51908)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51908)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(37,'1','t2','2016-01-10 03:32:22',0,'LOGIN',0,'127.0.0.1:51909','(\'127.0.0.1\', 51909)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51909)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(38,'1','t2','2016-01-10 03:33:19',0,'LOGIN',0,'127.0.0.1:51920','(\'127.0.0.1\', 51920)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51920)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(39,'1','t2','2016-01-10 03:33:19',0,'LOGIN',0,'127.0.0.1:51921','(\'127.0.0.1\', 51921)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51921)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(40,'1','t2','2016-01-10 03:33:19',0,'LOGIN',0,'127.0.0.1:51922','(\'127.0.0.1\', 51922)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51922)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(41,'1','t2','2016-01-10 03:33:51',0,'LOGIN',0,'127.0.0.1:51932','(\'127.0.0.1\', 51932)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51932)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(42,'1','t2','2016-01-10 03:33:51',0,'LOGIN',0,'127.0.0.1:51933','(\'127.0.0.1\', 51933)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51933)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(43,'1','t2','2016-01-10 03:33:51',0,'LOGIN',0,'127.0.0.1:51934','(\'127.0.0.1\', 51934)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51934)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(44,'1','t2','2016-01-10 03:35:04',0,'LOGIN',0,'127.0.0.1:51965','(\'127.0.0.1\', 51965)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51965)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(45,'1','t2','2016-01-10 03:35:04',0,'LOGIN',0,'127.0.0.1:51966','(\'127.0.0.1\', 51966)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51966)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(46,'1','t2','2016-01-10 03:35:04',0,'LOGIN',0,'127.0.0.1:51967','(\'127.0.0.1\', 51967)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51967)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(47,'1','t2','2016-01-10 03:35:22',0,'LOGIN',0,'127.0.0.1:51969','(\'127.0.0.1\', 51969)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51969)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(48,'1','t2','2016-01-10 03:35:22',0,'LOGIN',0,'127.0.0.1:51970','(\'127.0.0.1\', 51970)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51970)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(49,'1','t2','2016-01-10 03:35:22',0,'LOGIN',0,'127.0.0.1:51971','(\'127.0.0.1\', 51971)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51971)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(50,'1','t2','2016-01-10 03:35:41',0,'LOGIN',0,'127.0.0.1:51976','(\'127.0.0.1\', 51976)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51976)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0),
	(51,'1','t2','2016-01-10 03:36:07',0,'LOGIN',0,'127.0.0.1:51980','(\'127.0.0.1\', 51980)	\nGET /login.lol?gametoken=1&userid=t2 HTTP/1.1	\n<socket.socket fd=7, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=(\'127.0.0.1\', 8000), raddr=(\'127.0.0.1\', 51980)>	\nHost: localhost:8000\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Language: en-us\nConnection: keep-alive\nAccept-Encoding: gzip, deflate\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9\n\n','',0);

/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `log_update_score` BEFORE INSERT ON `log` FOR EACH ROW begin
IF new.action='UPLOAD SCORE' THEN
  IF (select count(*) from highScores where game_token=new.game_token AND user_id=new.user_id) =0 THEN
    INSERT INTO highScores(user_id, game_token, score) VALUES (new.user_id, new.game_token, new.value);
    SET new.effect=1;
  ELSEIF (select count(*) from highScores where game_token=new.game_token AND user_id=new.user_id AND score>new.value) =0 THEN
    UPDATE highScores SET score=new.value WHERE game_token=new.game_token AND user_id=new.user_id;
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
   `game_token` VARCHAR(11) NOT NULL DEFAULT '',
   `rank` BIGINT(22) NULL DEFAULT NULL,
   `user_id` CHAR(28) NOT NULL,
   `user_name` VARCHAR(20) NOT NULL,
   `score` INT(11) NULL DEFAULT NULL,
   `head_image` TEXT NOT NULL
) ENGINE=MyISAM;



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

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`user_id`, `user_name`, `disabled`, `head_image`, `register_time`)
VALUES
	('oXQ7gt9aM1hynR6j6J1Hp5PTB9EQ','正气LOSO',0,'http:\\/\\/wx.qlogo.cn\\/mmopen\\/Q3auHgzwzM74MVdUaaY1j7caXYfqSlDDic5iaAicWKsB0ThxEjv9bzJxCt3EaJP6QnQUZAlXWBoiaibKVKt1EJNSN1nepNoK98dUhcVPAfGUz3hs\\/0','2016-01-08 00:25:06'),
	('t2','test',0,'ttt','2016-01-08 00:28:00'),
	('t3','test3',0,'ttt','2016-01-08 00:45:53'),
	('t4','test4',0,'fdfdcc','2016-01-08 00:46:21'),
	('t7','test7',0,'t7m','2016-01-10 03:07:00'),
	('t8','test7',0,'t7m','2016-01-10 03:11:09');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;




# Replace placeholder table for rank with correct view syntax
# ------------------------------------------------------------

DROP TABLE `rank`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `rank` AS (select `x`.`game_token` AS `game_token`,`x`.`rank` AS `rank`,`x`.`user_id` AS `user_id`,`gamerank`.`users`.`user_name` AS `user_name`,`x`.`score` AS `score`,`gamerank`.`users`.`head_image` AS `head_image` from ((select `a`.`user_id` AS `user_id`,`a`.`game_token` AS `game_token`,`a`.`score` AS `score`,((select count(`gamerank`.`highscores`.`score`) from `gamerank`.`highscores` where ((`gamerank`.`highscores`.`score` > `a`.`score`) and (`gamerank`.`highscores`.`game_token` = `a`.`game_token`) and (`gamerank`.`highscores`.`valid` = TRUE))) + 1) AS `rank` from `gamerank`.`highscores` `a` where (`a`.`valid` = TRUE)) `x` join `gamerank`.`users`) where (`gamerank`.`users`.`user_id` = `x`.`user_id`) order by `x`.`game_token`,`x`.`rank`);

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
