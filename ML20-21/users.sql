ALTER TABLE `EP_ENTEL_MISLUCAS`.`users` 
ADD COLUMN `first_login` TINYINT NOT NULL DEFAULT '1' AFTER `actor_id`;

UPDATE users
SET first_login = 0;


ALTER TABLE `EP_ENTEL_MISLUCAS`.`actors` 
DROP FOREIGN KEY `fk_actor_updated_by`,
DROP FOREIGN KEY `fk_actor_created_by`;
ALTER TABLE `EP_ENTEL_MISLUCAS`.`actors` 
DROP INDEX `fk_employees__updated_by_idx` ,
DROP INDEX `fk_employees_created_by_idx` ;
;