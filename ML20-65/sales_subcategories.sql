-- sales_subcategories
CREATE TABLE IF NOT EXISTS `sales_subcategories` (
                                                     `id` char(36) NOT NULL,
    `code` varchar(20) NOT NULL,
    `description` varchar(255) DEFAULT NULL,
    `short_description` varchar(100) DEFAULT NULL,
    `order` tinyint DEFAULT NULL,
    `sales_category_id` char(36) NOT NULL,
    `active` tinyint DEFAULT NULL,
    `created_by` char(36) DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_by` char(36) DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `fk_sales_subcategories_categories_idx` (`sales_category_id`),
    CONSTRAINT `fk_sales_subcategories_categories` FOREIGN KEY (`sales_category_id`) REFERENCES `sales_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- sales_subcategories DATA
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('174f5da0-62d1-4888-bc06-b12c1523ae95', 'VR_PP5', 'Venta Regular PP5', 'VR PP5', '1', 'c20f575f-324a-4648-a6e6-d2c6bffcba4e', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:50:37');
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('1f96db0e-bee9-4d84-b9da-66d23b7b5141', 'OSS', 'Porta Origen Postpago', 'OSS', '1', 'c9cc9af8-1134-4cd2-81ca-5ae0ecb3c899', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:50:37');
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('31bfe524-bfe2-408a-92d6-5311259ac366', 'OPP_GT_90', 'Porta Origen Prepago > 90  dias', 'OPP > 90', '4', 'c9cc9af8-1134-4cd2-81ca-5ae0ecb3c899', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:53:26');
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('5452245b-d137-4147-b674-f71c10c55087', 'VR_PPFLEX', 'Venta Regular PPFlex', 'VR PPFLEX', '3', 'c20f575f-324a-4648-a6e6-d2c6bffcba4e', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:50:38');
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('918f0f0c-a168-4e85-8775-0a3085d1da70', 'LLAA', 'LLAA', 'LLAA', '6', 'c9cc9af8-1134-4cd2-81ca-5ae0ecb3c899', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:50:38');
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('9de736a7-6dc9-47a4-91a3-ac638c577d88', 'PORTA_PP5', 'Portabilidad PP5', 'Porta PP5', '2', 'c20f575f-324a-4648-a6e6-d2c6bffcba4e', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:50:38');
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('cad9dd6d-8a49-46e3-983c-baf8cca499ed', 'OPP', 'Porta Origen Prepago', 'OPP', '3', 'c9cc9af8-1134-4cd2-81ca-5ae0ecb3c899', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:50:39');
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('d77fa351-dc4a-4c46-8d74-a331bb8e05a1', 'OSS_GT_90', 'Porta Origen Postpago > 90 dias', 'OSS > 90', '2', 'c9cc9af8-1134-4cd2-81ca-5ae0ecb3c899', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:50:39');
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('da487023-9bd9-470d-b37f-0d9d343a89de', 'VR', 'Venta Regular	VR', 'VR', '5', 'c9cc9af8-1134-4cd2-81ca-5ae0ecb3c899', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:50:39');
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('e10e56a1-e40a-4056-ad47-e13337bb24c7', 'PREPAGO', 'Prepago', 'Prepago', '0', 'c20f575f-324a-4648-a6e6-d2c6bffcba4e', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:50:40');
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('e3e537b4-e82a-46a0-89be-72b8f466370e', 'POSTPAGO', 'Postpago', 'Postpago', '0', 'c9cc9af8-1134-4cd2-81ca-5ae0ecb3c899', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:50:40');
INSERT INTO `EP_ENTEL_MISLUCAS`.`sales_subcategories`(`id`,`code`,`description`,`short_description`,`order`,`sales_category_id`,`active`,`created_by`,`created_at`,`updated_by`,`updated_at`) VALUES
    ('fbea03aa-bf94-4ed4-984b-7a9e6564f8a5', 'PORTA_PPFLEX', 'Portabilidad PPFlex', 'Porta PPFLEX', '4', 'c20f575f-324a-4648-a6e6-d2c6bffcba4e', '1', NULL, '2025-04-03 17:51:55', NULL, '2025-04-07 17:50:40');
