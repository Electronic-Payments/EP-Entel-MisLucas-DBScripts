-- sales_quotes
CREATE TABLE IF NOT EXISTS `sales_quotes` (
                                              `id` char(36) NOT NULL,
    `commerce_id` char(36) DEFAULT NULL,
    `type_commerce_description` varchar(40) DEFAULT NULL,
    `closing_level` varchar(40) DEFAULT NULL,
    `quota_pp` int DEFAULT NULL,
    `quota_porta_pp` int DEFAULT NULL,
    `quota_ss` int DEFAULT NULL,
    `quota_oss` int DEFAULT NULL,
    `quota_opp` int DEFAULT NULL,
    `quota_urm1` int DEFAULT NULL,
    `subchannel` varchar(40) DEFAULT NULL,
    `month` int NOT NULL,
    `year` int NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` char(36) DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `updated_by` char(36) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `fk_commerce_idx` (`commerce_id`),
    CONSTRAINT `fk_commerce` FOREIGN KEY (`commerce_id`) REFERENCES `actors` (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;