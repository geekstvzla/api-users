CREATE TABLE `countries` (
  `country_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `phone_number_code` INT(3) NOT NULL,
  `iso_a2` VARCHAR(2) NOT NULL,
  `iso_a3` VARCHAR(2) NOT NULL,
  `status_id` INT(1) NOT NULL,
  PRIMARY KEY (`country_id`));