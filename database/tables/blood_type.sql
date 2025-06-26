CREATE TABLE `blood_type` (
  `blood_type_id` int NOT NULL AUTO_INCREMENT,
  `description` varchar(10) NOT NULL,
  `status_id` int NOT NULL,
  PRIMARY KEY (`blood_type_id`)
) ENGINE=MyISAM DEFAULT;