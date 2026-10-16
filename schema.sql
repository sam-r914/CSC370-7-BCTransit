CREATE DATABASE `bctransit` 
USE `bctransit`;

CREATE TABLE `bus_route` (
  `route_id` varchar(15) NOT NULL,
  `route_length` int DEFAULT NULL,
  `route_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`route_id`)
) 

CREATE TABLE `bus_stop` (
  `stop_id` int NOT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `stop_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`stop_id`)
) 

CREATE TABLE `privileged_user` (
  `user_id` int NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `privileged_user_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) 

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
)

CREATE TABLE `ratings` (
  `stop_id` int NOT NULL,
  `type` enum('noise','cleanliness') NOT NULL,
  `count` int DEFAULT NULL,
  `sum` int DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `average` double(10,2) GENERATED ALWAYS AS ((`sum` / `count`)) VIRTUAL,
  PRIMARY KEY (`stop_id`,`type`),
  CONSTRAINT `fk_ratings_stop` FOREIGN KEY (`stop_id`) REFERENCES `bus_stop` (`stop_id`)
) 

CREATE TABLE `route_stops` (
  `stop_id` int NOT NULL,
  `route_id` varchar(15) NOT NULL,
  `position_index` int NOT NULL,
  PRIMARY KEY (`stop_id`,`route_id`,`position_index`),
  KEY `FK_route` (`route_id`),
  CONSTRAINT `FK_route` FOREIGN KEY (`route_id`) REFERENCES `bus_route` (`route_id`),
  CONSTRAINT `FK_stop` FOREIGN KEY (`stop_id`) REFERENCES `bus_stop` (`stop_id`)
) 

CREATE TABLE `tf_accessibility` (
  `stop_id` int NOT NULL,
  `name` enum('wheelchair','shelter','trashcan','seating','sidewalk') NOT NULL,
  `value` tinyint(1) DEFAULT '0',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`stop_id`,`name`),
  CONSTRAINT `tf_accessibility_ibfk_1` FOREIGN KEY (`stop_id`) REFERENCES `bus_stop` (`stop_id`)
) 

CREATE TABLE `user` (
  `user_id` int NOT NULL,
  `email` varchar(30) DEFAULT NULL,
  `password` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) 
