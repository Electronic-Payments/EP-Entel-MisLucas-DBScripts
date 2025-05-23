ALTER TABLE `EP_ENTEL_MISLUCAS`.`daily_sales_results` 
CHANGE COLUMN `manager_id` `manager_id` CHAR(36) NULL ;


ALTER TABLE `EP_ENTEL_MISLUCAS`.`daily_sales_results` 
DROP FOREIGN KEY `fk_daily_sales_result_commerce_actor`;
ALTER TABLE `EP_ENTEL_MISLUCAS`.`daily_sales_results` 
CHANGE COLUMN `commerce_id` `commerce_id` CHAR(36) NULL ;
ALTER TABLE `EP_ENTEL_MISLUCAS`.`daily_sales_results` 
ADD CONSTRAINT `fk_daily_sales_result_commerce_actor`
  FOREIGN KEY (`commerce_id`)
  REFERENCES `EP_ENTEL_MISLUCAS`.`actors` (`id`);