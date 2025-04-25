INSERT INTO `EP_ENTEL_MISLUCAS_UAT`.`catalog_values` (`catalog_type_id`, `value`, id) VALUES ('52c39303-05df-11f0-9de9-42010a400011', 'CE', "b54d1448-109b-11f0-8f07-42010a400012");
INSERT INTO `EP_ENTEL_MISLUCAS_UAT`.`catalog_values` (`catalog_type_id`, `value`, id) VALUES ('52c39303-05df-11f0-9de9-42010a400011', 'PASAPORTE', "c8ef74d1-109b-11f0-8f07-42010a400012");
INSERT INTO `EP_ENTEL_MISLUCAS_UAT`.`catalog_values` (`catalog_type_id`, `value`, id) VALUES ('52c39303-05df-11f0-9de9-42010a400011', 'OTRO', "cddec125-109b-11f0-8f07-42010a400012");

ALTER TABLE `catalog_values` 
ADD COLUMN `code` VARCHAR(45) NULL DEFAULT NULL AFTER `catalog_type_id`,
ADD COLUMN `description` VARCHAR(300) NULL AFTER `value`,
ADD UNIQUE INDEX `code_UNIQUE` (`code` ASC) VISIBLE;
;
