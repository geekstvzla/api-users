CREATE TABLE `document_type_lang` (
  `document_type_lang_id` INT NOT NULL AUTO_INCREMENT,
  `document_type_id` INT NOT NULL,
  `language_id` INT NOT NULL,
  `description` VARCHAR(45) NOT NULL,
  `status_id` INT(1) NOT NULL,
  PRIMARY KEY (`document_type_lang_id`));