-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: mydb
-- ------------------------------------------------------
-- Server version	8.0.35

DROP SCHEMA IF EXISTS `mydb`;
CREATE SCHEMA `mydb`;
USE `mydb`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `athlete`
--

DROP TABLE IF EXISTS `athlete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `athlete` (
  `user_id` int NOT NULL,
  `coach_user_id` int DEFAULT NULL,
  `coach_start_date` date DEFAULT NULL,
  `height` int NOT NULL,
  `skill_level` enum('beginner','intermediate','expert') NOT NULL,
  `club_id` int DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_athlete_user1_idx` (`user_id`),
  KEY `fk_athlete_coach1_idx` (`coach_user_id`),
  KEY `fk_athlete_tennis_group1_idx` (`club_id`),
  CONSTRAINT `fk_athlete_coach1` FOREIGN KEY (`coach_user_id`) REFERENCES `coach` (`user_id`),
  CONSTRAINT `fk_athlete_tennis_group1` FOREIGN KEY (`club_id`) REFERENCES `club` (`id`),
  CONSTRAINT `fk_athlete_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `athlete`
--

LOCK TABLES `athlete` WRITE;
/*!40000 ALTER TABLE `athlete` DISABLE KEYS */;
INSERT INTO `athlete` VALUES (2,6,'2022-08-05',158,'beginner',1),(3,NULL,NULL,196,'intermediate',NULL),(5,5,'2023-03-01',178,'intermediate',NULL),(7,1,'2023-08-05',176,'intermediate',3);
/*!40000 ALTER TABLE `athlete` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `athlete_plays_match`
--

DROP TABLE IF EXISTS `athlete_plays_match`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `athlete_plays_match` (
  `athlete_user_id` int NOT NULL,
  `match_id` int NOT NULL,
  `result` enum('won','lost','tie') DEFAULT NULL,
  PRIMARY KEY (`athlete_user_id`,`match_id`),
  KEY `fk_athlete_has_match_match1_idx` (`match_id`),
  KEY `fk_athlete_has_match_athlete1_idx` (`athlete_user_id`),
  CONSTRAINT `fk_athlete_has_match_athlete1` FOREIGN KEY (`athlete_user_id`) REFERENCES `athlete` (`user_id`),
  CONSTRAINT `fk_athlete_has_match_match1` FOREIGN KEY (`match_id`) REFERENCES `match` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `athlete_plays_match`
--

LOCK TABLES `athlete_plays_match` WRITE;
/*!40000 ALTER TABLE `athlete_plays_match` DISABLE KEYS */;
INSERT INTO `athlete_plays_match` VALUES (2,6,'lost'),(2,7,'won'),(2,9,'won'),(3,6,'won'),(3,7,'lost'),(3,8,'lost'),(5,8,'won'),(5,10,'lost'),(7,9,'lost'),(7,10,'won');
/*!40000 ALTER TABLE `athlete_plays_match` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `athlete_wins`
--

DROP TABLE IF EXISTS `athlete_wins`;
/*!50001 DROP VIEW IF EXISTS `athlete_wins`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `athlete_wins` AS SELECT 
 1 AS `athlete_id`,
 1 AS `total_wins`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `athletes_per_postal_code`
--

DROP TABLE IF EXISTS `athletes_per_postal_code`;
/*!50001 DROP VIEW IF EXISTS `athletes_per_postal_code`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `athletes_per_postal_code` AS SELECT 
 1 AS `postal_code`,
 1 AS `total_athletes`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `athletes_without_coach`
--

DROP TABLE IF EXISTS `athletes_without_coach`;
/*!50001 DROP VIEW IF EXISTS `athletes_without_coach`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `athletes_without_coach` AS SELECT 
 1 AS `user_id`,
 1 AS `skill_level`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `club`
--

DROP TABLE IF EXISTS `club`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `club` (
  `id` int NOT NULL,
  `name` varchar(45) NOT NULL,
  `admin_user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tennis_group_user1_idx` (`admin_user_id`),
  CONSTRAINT `fk_tennis_group_user1` FOREIGN KEY (`admin_user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `club`
--

LOCK TABLES `club` WRITE;
/*!40000 ALTER TABLE `club` DISABLE KEYS */;
INSERT INTO `club` VALUES (1,'Tiger Cubs',3),(2,'Fox Troters',1),(3,'THMMY TEAMY',4),(4,'Barca',6);
/*!40000 ALTER TABLE `club` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coach`
--

DROP TABLE IF EXISTS `coach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coach` (
  `user_id` int NOT NULL,
  `experience` enum('beginner','intermediate','expert') NOT NULL,
  `hourly_rate` int NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_coach_user1_idx` (`user_id`),
  CONSTRAINT `fk_coach_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach`
--

LOCK TABLES `coach` WRITE;
/*!40000 ALTER TABLE `coach` DISABLE KEYS */;
INSERT INTO `coach` VALUES (1,'expert',250),(4,'intermediate',27),(5,'beginner',11),(6,'beginner',10),(7,'intermediate',30);
/*!40000 ALTER TABLE `coach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match`
--

DROP TABLE IF EXISTS `match`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `match` (
  `id` int NOT NULL,
  `venue_id` int NOT NULL,
  `tournament_id` int DEFAULT NULL,
  `sponsor_user_id` int DEFAULT NULL,
  `result` enum('first_pair_won','second_pair_won','tie') DEFAULT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pairs_match_venue1_idx` (`venue_id`),
  KEY `fk_pairs_match_tournament1_idx` (`tournament_id`),
  KEY `fk_pairs_match_sponsor1_idx` (`sponsor_user_id`),
  CONSTRAINT `fk_pairs_match_sponsor1` FOREIGN KEY (`sponsor_user_id`) REFERENCES `sponsor` (`user_id`),
  CONSTRAINT `fk_pairs_match_tournament1` FOREIGN KEY (`tournament_id`) REFERENCES `tournament` (`id`),
  CONSTRAINT `fk_pairs_match_venue1` FOREIGN KEY (`venue_id`) REFERENCES `venue` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match`
--

LOCK TABLES `match` WRITE;
/*!40000 ALTER TABLE `match` DISABLE KEYS */;
INSERT INTO `match` VALUES (1,1,1,NULL,NULL,'2023-01-05'),(2,2,NULL,NULL,NULL,'2023-08-03'),(3,1,1,3,NULL,'2023-08-05'),(4,3,1,3,NULL,'2023-01-02'),(5,2,NULL,NULL,NULL,'2023-08-23'),(6,1,NULL,3,NULL,'2023-08-27'),(7,3,2,NULL,NULL,'2023-08-02'),(8,4,2,NULL,NULL,'2023-09-02'),(9,1,2,NULL,NULL,'2023-01-02'),(10,2,2,3,NULL,'2023-08-23');
/*!40000 ALTER TABLE `match` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pair`
--

DROP TABLE IF EXISTS `pair`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pair` (
  `id` int NOT NULL,
  `coach_user_id` int DEFAULT NULL,
  `coaching_start_date` date DEFAULT NULL,
  `creation_date` date NOT NULL,
  `club_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pair_coach1_idx` (`coach_user_id`),
  KEY `fk_pair_tennis_group1_idx` (`club_id`),
  CONSTRAINT `fk_pair_coach1` FOREIGN KEY (`coach_user_id`) REFERENCES `coach` (`user_id`),
  CONSTRAINT `fk_pair_tennis_group1` FOREIGN KEY (`club_id`) REFERENCES `club` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pair`
--

LOCK TABLES `pair` WRITE;
/*!40000 ALTER TABLE `pair` DISABLE KEYS */;
INSERT INTO `pair` VALUES (1,NULL,NULL,'2023-02-05',3),(2,6,'2023-08-09','2023-08-01',1),(3,NULL,NULL,'2023-08-12',NULL),(4,NULL,NULL,'2023-02-05',3),(5,4,'2023-08-09','2023-07-05',NULL);
/*!40000 ALTER TABLE `pair` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pair_has_athlete`
--

DROP TABLE IF EXISTS `pair_has_athlete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pair_has_athlete` (
  `pair_id` int NOT NULL,
  `athlete_user_id` int NOT NULL,
  PRIMARY KEY (`pair_id`,`athlete_user_id`),
  KEY `fk_pair_has_athlete_athlete1_idx` (`athlete_user_id`),
  KEY `fk_pair_has_athlete_pair1_idx` (`pair_id`),
  CONSTRAINT `fk_pair_has_athlete_athlete1` FOREIGN KEY (`athlete_user_id`) REFERENCES `athlete` (`user_id`),
  CONSTRAINT `fk_pair_has_athlete_pair1` FOREIGN KEY (`pair_id`) REFERENCES `pair` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pair_has_athlete`
--

LOCK TABLES `pair_has_athlete` WRITE;
/*!40000 ALTER TABLE `pair_has_athlete` DISABLE KEYS */;
INSERT INTO `pair_has_athlete` VALUES (4,2),(5,2),(1,3),(2,3),(2,5),(3,5),(4,5),(1,7),(3,7),(5,7);
/*!40000 ALTER TABLE `pair_has_athlete` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pair_plays_match`
--

DROP TABLE IF EXISTS `pair_plays_match`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pair_plays_match` (
  `pair_id` int NOT NULL,
  `match_id` int NOT NULL,
  `result` enum('won','lost','tie') DEFAULT NULL,
  PRIMARY KEY (`pair_id`,`match_id`),
  KEY `fk_pair_has_match_match1_idx` (`match_id`),
  KEY `fk_pair_has_match_pair1_idx` (`pair_id`),
  CONSTRAINT `fk_pair_has_match_match1` FOREIGN KEY (`match_id`) REFERENCES `match` (`id`),
  CONSTRAINT `fk_pair_has_match_pair1` FOREIGN KEY (`pair_id`) REFERENCES `pair` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pair_plays_match`
--

LOCK TABLES `pair_plays_match` WRITE;
/*!40000 ALTER TABLE `pair_plays_match` DISABLE KEYS */;
INSERT INTO `pair_plays_match` VALUES (1,1,'lost'),(2,1,'won'),(2,2,'lost'),(3,2,'won'),(3,5,'won'),(4,3,'won'),(4,4,'won'),(5,3,'lost'),(5,4,'lost'),(5,5,'lost');
/*!40000 ALTER TABLE `pair_plays_match` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referee`
--

DROP TABLE IF EXISTS `referee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `referee` (
  `user_id` int NOT NULL,
  `experience` enum('beginner','intermediate','expert') NOT NULL,
  `hourly_rate` int NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_referee_user1_idx` (`user_id`),
  CONSTRAINT `fk_referee_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `referee`
--

LOCK TABLES `referee` WRITE;
/*!40000 ALTER TABLE `referee` DISABLE KEYS */;
INSERT INTO `referee` VALUES (1,'beginner',250),(2,'intermediate',27),(3,'intermediate',10),(4,'beginner',11),(7,'intermediate',30);
/*!40000 ALTER TABLE `referee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `referee_pair_count`
--

DROP TABLE IF EXISTS `referee_pair_count`;
/*!50001 DROP VIEW IF EXISTS `referee_pair_count`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `referee_pair_count` AS SELECT 
 1 AS `referee_id`,
 1 AS `pair_match_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `root_user`
--

DROP TABLE IF EXISTS `root_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `root_user` (
  `user_id` int NOT NULL,
  `adinistration_level` int DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `adinistration_level_UNIQUE` (`adinistration_level`),
  CONSTRAINT `fk_root_user_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `root_user`
--

LOCK TABLES `root_user` WRITE;
/*!40000 ALTER TABLE `root_user` DISABLE KEYS */;
INSERT INTO `root_user` VALUES (3,0);
/*!40000 ALTER TABLE `root_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sfyraei`
--

DROP TABLE IF EXISTS `sfyraei`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sfyraei` (
  `referee_user_id` int NOT NULL,
  `match_id` int NOT NULL,
  PRIMARY KEY (`referee_user_id`,`match_id`),
  KEY `fk_referee_has_match_match1_idx` (`match_id`),
  KEY `fk_referee_has_match_referee1_idx` (`referee_user_id`),
  CONSTRAINT `fk_referee_has_match_match1` FOREIGN KEY (`match_id`) REFERENCES `match` (`id`),
  CONSTRAINT `fk_referee_has_match_referee1` FOREIGN KEY (`referee_user_id`) REFERENCES `referee` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sfyraei`
--

LOCK TABLES `sfyraei` WRITE;
/*!40000 ALTER TABLE `sfyraei` DISABLE KEYS */;
INSERT INTO `sfyraei` VALUES (2,3),(3,5),(7,6),(7,8),(7,10);
/*!40000 ALTER TABLE `sfyraei` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `single_matches_in_city`
--

DROP TABLE IF EXISTS `single_matches_in_city`;
/*!50001 DROP VIEW IF EXISTS `single_matches_in_city`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `single_matches_in_city` AS SELECT 
 1 AS `city`,
 1 AS `match_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `sponsor`
--

DROP TABLE IF EXISTS `sponsor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sponsor` (
  `user_id` int NOT NULL,
  `budget` int NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_sponsor_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sponsor`
--

LOCK TABLES `sponsor` WRITE;
/*!40000 ALTER TABLE `sponsor` DISABLE KEYS */;
INSERT INTO `sponsor` VALUES (3,123456);
/*!40000 ALTER TABLE `sponsor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tournament`
--

DROP TABLE IF EXISTS `tournament`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tournament` (
  `id` int NOT NULL,
  `tournament_type` enum('singles','pairs') NOT NULL,
  `name` varchar(45) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `organizer_user_id` int NOT NULL,
  PRIMARY KEY (`id`,`organizer_user_id`),
  KEY `fk_tournament_user1_idx` (`organizer_user_id`),
  CONSTRAINT `fk_tournament_user1` FOREIGN KEY (`organizer_user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tournament`
--

LOCK TABLES `tournament` WRITE;
/*!40000 ALTER TABLE `tournament` DISABLE KEYS */;
INSERT INTO `tournament` VALUES (1,'pairs','July Championship','2023-08-01','2023-08-30',3),(2,'singles','Grand Summer Championship','2023-08-05','2023-09-05',6);
/*!40000 ALTER TABLE `tournament` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `password_hash` varchar(45) NOT NULL,
  `date_of_birth` date NOT NULL,
  `contact_number` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `postal_code` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `iduser_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'TheBeef','34n21k4g21jh3b','1999-07-20','306976543210','beef@mail.com','female','57846'),(2,'Megas_Alexandros','4h213j4b312k4','1999-03-03','306900000001','ceo@macedonia.gr','male','1'),(3,'Ross','054n6k5jl2kn','1999-04-02','306912345678','ross@rossross.io','other','51234'),(4,'Kostas_skg','532jlkm7l6k','1999-03-01','306912121212','kost@gmail.com','female','56430'),(5,'Mitsos','5alsdkfjnl2','1999-04-01','306983927503','mitser@gmail.com','male','56431'),(6,'Obama','34n2m1k123l4hj24','1969-03-01','306912121213','obams@gmail.com','male','56230'),(7,'TunaLover','43n12kl4n312lk4j','1999-04-02','306934567890','tuna@mail.com','male','56401');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venue`
--

DROP TABLE IF EXISTS `venue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venue` (
  `id` int NOT NULL,
  `type` enum('grass','acrylic','clay') NOT NULL,
  `city` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venue`
--

LOCK TABLES `venue` WRITE;
/*!40000 ALTER TABLE `venue` DISABLE KEYS */;
INSERT INTO `venue` VALUES (1,'grass','Thessaloniki - Greece'),(2,'acrylic','New Orleans - USA'),(3,'grass','Athens - Greece'),(4,'clay','Athens - Greece'),(5,'grass','Tirana - Albania');
/*!40000 ALTER TABLE `venue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `athlete_wins`
--

/*!50001 DROP VIEW IF EXISTS `athlete_wins`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `athlete_wins` AS select `a`.`user_id` AS `athlete_id`,count((case when (`apm`.`result` = 'won') then 1 end)) AS `total_wins` from (`athlete` `a` left join `athlete_plays_match` `apm` on((`a`.`user_id` = `apm`.`athlete_user_id`))) group by `a`.`user_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `athletes_per_postal_code`
--

/*!50001 DROP VIEW IF EXISTS `athletes_per_postal_code`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `athletes_per_postal_code` AS select `u`.`postal_code` AS `postal_code`,count(`a`.`user_id`) AS `total_athletes` from (`user` `u` join `athlete` `a` on((`u`.`id` = `a`.`user_id`))) group by `u`.`postal_code` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `athletes_without_coach`
--

/*!50001 DROP VIEW IF EXISTS `athletes_without_coach`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `athletes_without_coach` AS select `athlete`.`user_id` AS `user_id`,`athlete`.`skill_level` AS `skill_level` from `athlete` where (`athlete`.`coach_user_id` is null) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `referee_pair_count`
--

/*!50001 DROP VIEW IF EXISTS `referee_pair_count`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `referee_pair_count` AS select `r`.`user_id` AS `referee_id`,count(distinct `ppm`.`match_id`) AS `pair_match_count` from ((`referee` `r` join `sfyraei` `o` on((`r`.`user_id` = `o`.`referee_user_id`))) join `pair_plays_match` `ppm` on((`o`.`match_id` = `ppm`.`match_id`))) group by `r`.`user_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `single_matches_in_city`
--

/*!50001 DROP VIEW IF EXISTS `single_matches_in_city`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `single_matches_in_city` AS select `v`.`city` AS `city`,`m`.`id` AS `match_id` from (`match` `m` join `venue` `v` on((`m`.`venue_id` = `v`.`id`))) where `m`.`id` in (select `pair_plays_match`.`match_id` from `pair_plays_match`) is false */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-22 21:44:07
