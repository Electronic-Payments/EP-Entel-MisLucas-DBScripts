----------------------------------------------------------
-- Ejecutar en PROD para habilitar historial de cargas. --
----------------------------------------------------------
use EP_ENTEL_MISLUCAS;

ALTER TABLE `actors`
ADD COLUMN `upload_id` CHAR(36) NULL AFTER `id`;

ALTER TABLE `actors`
ADD CONSTRAINT `fk_actors_upload`
FOREIGN KEY (`upload_id`)
REFERENCES `bulk_upload_file_history` (`upload_id`)
ON DELETE CASCADE
ON UPDATE CASCADE;
