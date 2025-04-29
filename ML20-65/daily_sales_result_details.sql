-- daily_sales_result_details
CREATE TABLE IF NOT EXISTS `daily_sales_result_details` (
                                                            `id` char(36) NOT NULL,
    `seller_id` char(36) DEFAULT NULL,
    `daily_sales_result_category_id` char(36) NOT NULL,
    `total_progress` int DEFAULT NULL,
    `total_commissionable_sales` int DEFAULT NULL,
    `total_recharged_unit` int DEFAULT NULL,
    `total_ru_percentage` decimal(10,0) DEFAULT NULL,
    `active` tinyint DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `daily_sales_result_details_result_category_idx` (`daily_sales_result_category_id`),
    KEY `daily_sales_result_details_seller_actor_idx` (`seller_id`),
    CONSTRAINT `daily_sales_result_details_result_category` FOREIGN KEY (`daily_sales_result_category_id`) REFERENCES `daily_sales_result_category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `daily_sales_result_details_seller_actor` FOREIGN KEY (`seller_id`) REFERENCES `actors` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;