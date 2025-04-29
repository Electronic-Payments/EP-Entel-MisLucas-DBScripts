CREATE TABLE `reset_password_tokens` (
                                         `id` char(36) NOT NULL,
                                         `user_id` char(36) NOT NULL,
                                         `verification_token` char(36) NOT NULL,
                                         `expires_at` datetime NOT NULL,
                                         `is_used` tinyint DEFAULT '0',
                                         `active` tinyint NOT NULL DEFAULT '1',
                                         PRIMARY KEY (`id`),
                                         KEY `fk_password_reset_token_user_idx` (`user_id`),
                                         CONSTRAINT `fk_password_reset_token_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;