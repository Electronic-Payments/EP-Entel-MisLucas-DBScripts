ALTER TABLE `EP_ENTEL_MISLUCAS`.`actors`
    ADD COLUMN `has_sellers` TINYINT NOT NULL DEFAULT '0' AFTER `catalog_managertype_id`;