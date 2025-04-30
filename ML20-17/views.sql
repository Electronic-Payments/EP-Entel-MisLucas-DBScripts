CREATE ALGORITHM = UNDEFINED 
DEFINER = `rootDev`@`%` 
SQL SECURITY DEFINER 
VIEW `v_notification_webhook_dispersion` AS

WITH `T1` AS (
    SELECT 
        `nm`.`payout_order_id` AS `payout_order_id`,
        `nm`.`status` AS `status`,
        `nm`.`notification_response` AS `notification_response`,
        `nm`.`created_at` AS `created_at`
    FROM 
        `notification_monnet_webhook` `nm`
        LEFT JOIN (
            `payout_order_responses` `prq`
            LEFT JOIN `payout_order_requests` `pr`
                ON `pr`.`id` = `prq`.`payout_request_id`
        )
        ON `nm`.`payout_order_id` = `pr`.`order_id`
)

SELECT 
    `dfd`.`id` AS `dispersion_file_detail_id`,
    `prq`.`id` AS `id_payout_order_response`,
    `dfd`.`document_number` AS `document_number`,
    `dfd`.`name` AS `name`,
    `dfd`.`lastname` AS `last_name`,
    `pr`.`account_number_cci` AS `account_number_cci`,
    `bd`.`id` AS `beneficiary_document_id`,
    `bd`.`type` AS `beneficiary_document_type`,
    `dfd`.`amount` AS `amount`,
    `pr`.`currency` AS `currency`,
    `dfd`.`is_uploaded` AS `uploaded`,
    `dfd`.`upload_error` AS `upload_error`,
    `prq`.`error_code` AS `error_code`,
    `prq`.`error_message` AS `error_message`,
    `pr`.`created_at` AS `request_created_at`,
    `prq`.`created_at` AS `response_created_at`,
    `webhook`.`created_at` AS `webhook_created_at`,
    TIMESTAMPDIFF(SECOND, `prq`.`created_at`, `webhook`.`created_at`) AS `processing_time_seconds`,
    `bb`.`id` AS `bank_id`,
    `bb`.`name` AS `bank_name`,
    `webhook`.`status` AS `final_status`,
    JSON_EXTRACT(`webhook`.`notification_response`, '$.errors[0].message') AS `detail_error`,
    `prq`.`id_row_file` AS `id_row_file`,
    `prq`.`id_dispersion_file_history` AS `id_dispersion_file_history`,
    `dfd`.`channel_type` AS `channel_type`,
    `dfd`.`description` AS `description`
FROM 
    `dispersion_file_detail` `dfd`
    JOIN `dispersion_file_history` `dfh`
        ON `dfd`.`id_dispersion_file_history` = `dfh`.`id`
    LEFT JOIN `payout_order_requests` `pr`
        ON `pr`.`order_id` = `dfd`.`id_row_file`
    LEFT JOIN `payout_order_responses` `prq`
        ON `pr`.`id` = `prq`.`payout_request_id`
    LEFT JOIN `beneficiary_document` `bd`
        ON `dfd`.`document_type` = `bd`.`type`
    LEFT JOIN `beneficiary_bank` `bb`
        ON `pr`.`bank_code` = `bb`.`code`
    LEFT JOIN `T1` `webhook`
        ON `webhook`.`payout_order_id` = `pr`.`order_id`;