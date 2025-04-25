ALTER TABLE `EP_ENTEL_MISLUCAS`.`sales_quotes` 
DROP FOREIGN KEY `fk_commerce`;
ALTER TABLE `EP_ENTEL_MISLUCAS`.`sales_quotes` 
CHANGE COLUMN `commerce` `commerce_id` CHAR(36) NULL DEFAULT NULL ;
ALTER TABLE `EP_ENTEL_MISLUCAS`.`sales_quotes` 
ADD CONSTRAINT `fk_commerce`
  FOREIGN KEY (`commerce_id`)
  REFERENCES `EP_ENTEL_MISLUCAS`.`actors` (`id`);
