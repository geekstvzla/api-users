CREATE TABLE `gender_types_lang` (
  `gender_types_lang_id` INT NOT NULL AUTO_INCREMENT,
  `gender_type_id` INT NOT NULL,
  `language_id` INT NOT NULL,
  `description` VARCHAR(45) NOT NULL,
  `status_id` INT(1) NOT NULL,
  PRIMARY KEY (`gender_types_lang_id`));