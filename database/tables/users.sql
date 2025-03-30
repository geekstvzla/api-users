CREATE TABLE `users` (
  `user_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `refered_by` bigint(20) unsigned DEFAULT NULL,
  `avatar` varchar(100) DEFAULT NULL,
  `username` varchar(25) NOT NULL,
  `email` varchar(255) NOT NULL,
  `second_email` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `password` blob NOT NULL,
  `status_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB;