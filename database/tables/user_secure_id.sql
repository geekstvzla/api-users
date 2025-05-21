CREATE TABLE `user_secure_id` (
  `user_secure_id_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `secure_id` text NOT NULL,
  PRIMARY KEY (`user_secure_id_id`),
  KEY `fk_user_secure_id_users_idx` (`user_id`),
  CONSTRAINT `fk_user_secure_id_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;