ALTER TABLE `EP_ENTEL_MISLUCAS`.`dispersion_file_detail`
ADD COLUMN `is_uploaded` TINYINT NOT NULL DEFAULT '1' AFTER `lastname`,
ADD COLUMN `upload_error` VARCHAR(100) NULL DEFAULT NULL AFTER `is_uploaded`;