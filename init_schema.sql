CREATE DATABASE  IF NOT EXISTS `bctransit`;
USE `bctransit`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: bctransit
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `bus_route`
--
DROP TABLE IF EXISTS `bus_route`;

CREATE TABLE `bus_route` (
  `route_id` varchar(15) NOT NULL,
  `route_length` int DEFAULT NULL,
  `route_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`route_id`)
);

--
-- Dumping data for table `bus_route`
--

LOCK TABLES `bus_route` WRITE;
/*!40000 ALTER TABLE `bus_route` DISABLE KEYS */;
/*!40000 ALTER TABLE `bus_route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bus_stop`
--
DROP TABLE IF EXISTS `bus_stop`;

CREATE TABLE `bus_stop` (
  `stop_id` int NOT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `stop_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`stop_id`)
);

--
-- Table structure for table `privileged_user`
--
DROP TABLE IF EXISTS `privileged_user`;

CREATE TABLE `privileged_user` (
  `user_id` int NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `privileged_user_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Table structure for table `proposed_changes`
--
DROP TABLE IF EXISTS `proposed_changes`;

CREATE TABLE `proposed_changes` (
  `user_id` int NOT NULL,
  `stop_id` int DEFAULT NULL,
  `date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','approved','denied') DEFAULT 'pending',
  `description` varchar(200) DEFAULT NULL,
  `value` varchar(20) DEFAULT NULL,
  `type` enum('wheelchair','shelter','trashcan','seating','sidewalk') NOT NULL,
  `reviewed_by` int DEFAULT NULL,
  PRIMARY KEY (`user_id`,`date_time`),
  KEY `stop_id` (`stop_id`),
  KEY `reviewed_by` (`reviewed_by`),
  CONSTRAINT `proposed_changes_ibfk_1` FOREIGN KEY (`stop_id`) REFERENCES `bus_stop` (`stop_id`),
  CONSTRAINT `proposed_changes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `proposed_changes_ibfk_3` FOREIGN KEY (`reviewed_by`) REFERENCES `privileged_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Table structure for table `ratings`
--
DROP TABLE IF EXISTS `ratings`;

CREATE TABLE `ratings` (
  `stop_id` int NOT NULL,
  `type` enum('noise','cleanliness') NOT NULL,
  `count` int DEFAULT NULL,
  `sum` int DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `average` double(10,2) GENERATED ALWAYS AS ((`sum` / `count`)) VIRTUAL,
  PRIMARY KEY (`stop_id`,`type`),
  CONSTRAINT `fk_ratings_stop` FOREIGN KEY (`stop_id`) REFERENCES `bus_stop` (`stop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Table structure for table `route_stops`
--
DROP TABLE IF EXISTS `route_stops`;

CREATE TABLE `route_stops` (
  `stop_id` int NOT NULL,
  `route_id` varchar(15) NOT NULL,
  `position_index` int NOT NULL,
  PRIMARY KEY (`stop_id`,`route_id`,`position_index`),
  KEY `FK_route` (`route_id`),
  CONSTRAINT `FK_route` FOREIGN KEY (`route_id`) REFERENCES `bus_route` (`route_id`),
  CONSTRAINT `FK_stop` FOREIGN KEY (`stop_id`) REFERENCES `bus_stop` (`stop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Table structure for table `tf_accessibility`
--
DROP TABLE IF EXISTS `tf_accessibility`;

CREATE TABLE `tf_accessibility` (
  `stop_id` int NOT NULL,
  `name` enum('wheelchair','shelter','trashcan','seating','sidewalk') NOT NULL,
  `value` tinyint(1) DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`stop_id`,`name`),
  CONSTRAINT `tf_accessibility_ibfk_1` FOREIGN KEY (`stop_id`) REFERENCES `bus_stop` (`stop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Table structure for table `user`
--
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `user_id` int NOT NULL,
  `email` varchar(30) DEFAULT NULL,
  `password` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

