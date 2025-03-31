CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` text NOT NULL,
  `username` text NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `middle_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `second_ last_ name` varchar(45) DEFAULT NULL,
  `gender_id` int DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `avatar` varchar(45) DEFAULT NULL,
  `password` blob,
  `status_id` varchar(45) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB;