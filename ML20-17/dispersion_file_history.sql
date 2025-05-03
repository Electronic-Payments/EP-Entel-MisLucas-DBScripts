ALTER TABLE `EP_ENTEL_MISLUCAS`.`dispersion_file_history` 
ADD COLUMN `created_by` CHAR(36) NULL DEFAULT NULL COMMENT 'Campo de auditoría. Esta columna tiene la finalidad de determinar quién fue el creador de un nuevo registro.' AFTER `created_at`,
ADD COLUMN `released_at` TIMESTAMP NULL DEFAULT NULL AFTER `created_by`,
ADD COLUMN `released_by` CHAR(36) NULL DEFAULT NULL  AFTER `released_at`;


ALTER TABLE `EP_ENTEL_MISLUCAS`.`dispersion_file_history` 
ADD INDEX `fk_dispersion_file_history_created_by_idx` (`created_by` ASC) VISIBLE,
ADD INDEX `fk_dispersion_file_history_released_by_idx` (`released_by` ASC) VISIBLE;
;
ALTER TABLE `EP_ENTEL_MISLUCAS`.`dispersion_file_history` 
ADD CONSTRAINT `fk_dispersion_file_history_created_by`
  FOREIGN KEY (`created_by`)
  REFERENCES `EP_ENTEL_MISLUCAS`.`users` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT,
ADD CONSTRAINT `fk_dispersion_file_history_released_by`
  FOREIGN KEY (`released_by`)
  REFERENCES `EP_ENTEL_MISLUCAS`.`users` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;