-- sales_categories
CREATE TABLE IF NOT EXISTS `sales_categories` (
                                                  `id` char(36) NOT NULL,
    `code` varchar(10) NOT NULL,
    `description` varchar(255) DEFAULT NULL,
    `order` tinyint DEFAULT NULL,
    `active` tinyint DEFAULT NULL,
    `created_by` char(36) DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_by` char(36) DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- sales_categories DATA
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_categories`(`id`,`code`,`description`,`order`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`)VALUES
    ('c20f575f-324a-4648-a6e6-d2c6bffcba4e', 'PREPAGO', 'Prepago', '2', '1', NULL, '2025-04-03 17:51:08', NULL, '2025-04-07 17:48:35');

INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_categories`(`id`,`code`,`description`,`order`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`)VALUES
    ('c9cc9af8-1134-4cd2-81ca-5ae0ecb3c899', 'POSTPAGO', 'Postpago', '1', '1', NULL, '2025-04-03 17:51:08', NULL, '2025-04-07 17:48:35');
