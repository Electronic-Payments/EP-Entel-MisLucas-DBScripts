-- daily_sales_result_category
CREATE TABLE IF NOT EXISTS `daily_sales_result_category` (
                                                             `id` char(36) NOT NULL,
    `daily_sales_result_id` char(36) NOT NULL,
    `sales_categories_id` char(36) NOT NULL,
    `sales_subcategories_id` char(36) NOT NULL,
    `total_commerce_quota` int DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `daily_sales_resul_category_result_idx` (`daily_sales_result_id`),
    KEY `daily_sales_resul_category_subcategories_idx` (`sales_subcategories_id`),
    KEY `daily_sales_resul_category_categories_idx` (`sales_categories_id`),
    CONSTRAINT `daily_sales_resul_category_categories` FOREIGN KEY (`sales_categories_id`) REFERENCES `sales_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `daily_sales_resul_category_result` FOREIGN KEY (`daily_sales_result_id`) REFERENCES `daily_sales_results` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT `daily_sales_resul_category_subcategories` FOREIGN KEY (`sales_subcategories_id`) REFERENCES `sales_subcategories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;