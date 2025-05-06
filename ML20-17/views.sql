CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `EP_ENTEL_MISLUCAS`.`v_notification_webhook_dispersion` AS with `T1` as (
select
    `nm`.`payout_order_id` AS `payout_order_id`,
    `nm`.`status` AS `status`,
    `nm`.`notification_response` AS `notification_response`,
    `nm`.`created_at` AS `created_at`
from
    (`EP_ENTEL_MISLUCAS_UAT`.`notification_monnet_webhook` `nm`
left join (`EP_ENTEL_MISLUCAS_UAT`.`payout_order_responses` `prq`
left join `EP_ENTEL_MISLUCAS_UAT`.`payout_order_requests` `pr` on
    ((`pr`.`id` = `prq`.`payout_request_id`))) on
    ((`nm`.`payout_order_id` = `pr`.`order_id`))))
select
	`dfh`.`file_name` AS `dispersion_file_name`,
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
from
    ((((((`EP_ENTEL_MISLUCAS_UAT`.`dispersion_file_detail` `dfd`
join `EP_ENTEL_MISLUCAS_UAT`.`dispersion_file_history` `dfh` on
    ((`dfd`.`id_dispersion_file_history` = `dfh`.`id`)))
left join `EP_ENTEL_MISLUCAS_UAT`.`payout_order_requests` `pr` on
    ((`pr`.`order_id` = `dfd`.`id_row_file`)))
left join `EP_ENTEL_MISLUCAS_UAT`.`payout_order_responses` `prq` on
    ((`pr`.`id` = `prq`.`payout_request_id`)))
left join `EP_ENTEL_MISLUCAS_UAT`.`beneficiary_document` `bd` on
    ((`dfd`.`document_type` = `bd`.`type`)))
left join `EP_ENTEL_MISLUCAS_UAT`.`beneficiary_bank` `bb` on
    ((`pr`.`bank_code` = `bb`.`code`)))
left join `T1` `webhook` on
    ((`webhook`.`payout_order_id` = `pr`.`order_id`)));