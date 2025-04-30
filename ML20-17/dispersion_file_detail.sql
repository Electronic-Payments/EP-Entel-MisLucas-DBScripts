ALTER TABLE `EP_ENTEL_MISLUCAS_UAT`.`dispersion_file_detail` 
ADD COLUMN `lastname` VARCHAR(100) NULL DEFAULT NULL BEFORE `id_dispersion_file_history`;

ALTER TABLE `EP_ENTEL_MISLUCAS_UAT`.`dispersion_file_detail`
ADD COLUMN `is_uploaded` TINYINT NOT NULL DEFAULT '1' AFTER `lastname`,
ADD COLUMN `upload_error` VARCHAR(100) NULL DEFAULT NULL AFTER `is_uploaded`;

ALTER TABLE `EP_ENTEL_MISLUCAS_UAT`.`payout_order_responses` 
ADD COLUMN `id_row_file` VARCHAR(100) NULL DEFAULT NULL;

ALTER TABLE `EP_ENTEL_MISLUCAS_UAT`.`notification_monnet_webhook` 
ADD COLUMN `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
