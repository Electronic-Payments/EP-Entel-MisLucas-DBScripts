-- daily_sales_information
CREATE TABLE IF NOT EXISTS `daily_sales_informations` (
    `id` char(36) NOT NULL,
    `file_name` varchar(100) NOT NULL,
    `sales_progress_date` date DEFAULT NULL,
    `non_commisionable_date` date DEFAULT NULL,
    `top_up_date` date DEFAULT NULL,
    `update_status` varchar(45) DEFAULT NULL,
    `status_cache_id` char(36) DEFAULT NULL,
    `is_end_of_month` tinyint DEFAULT '0',
    `active` tinyint DEFAULT '1',
    `created_by` char(36) DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_by` char(36) DEFAULT NULL,
    `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_sales_progress_date` (`sales_progress_date`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;