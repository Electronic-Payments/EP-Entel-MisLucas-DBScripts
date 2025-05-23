-- daily_sales_results

CREATE TABLE IF NOT EXISTS `daily_sales_results` (
  `id` char(36) NOT NULL,
  `manager_id` char(36) DEFAULT NULL,
  `commerce_id` char(36) DEFAULT NULL,
  `daily_sales_information_id` char(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_daily_sales_result_information_idx` (`daily_sales_information_id`),
  KEY `fk_daily_sales_result_commerce_actor_idx` (`commerce_id`),
  KEY `fk_daily_sales_result_manager_actor_idx` (`manager_id`),
  CONSTRAINT `fk_daily_sales_result_commerce_actor` FOREIGN KEY (`commerce_id`) REFERENCES `actors` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_daily_sales_result_information` FOREIGN KEY (`daily_sales_information_id`) REFERENCES `daily_sales_informations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_daily_sales_result_manager_actor` FOREIGN KEY (`manager_id`) REFERENCES `actors` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
