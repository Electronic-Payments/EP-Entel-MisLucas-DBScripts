DROP PROCEDURE IF EXISTS EP_ENTEL_MISLUCAS.get_dispersion_file_history_result;
DROP PROCEDURE IF EXISTS EP_ENTEL_MISLUCAS.get_dispersion_file_history_detail;
DROP PROCEDURE IF EXISTS EP_ENTEL_MISLUCAS.get_dispersion_file_history_summary;

DELIMITER //

CREATE DEFINER=`root`@`%` PROCEDURE `EP_ENTEL_MISLUCAS`.`get_dispersion_file_history_summary`(
    IN in_dispersion_file_history_id CHAR(36)
)
BEGIN
    SELECT 
        dfh.id AS id_dispersion_file_history,
        dfd.id_row_file,
        dfd.document_number,
        dfd.document_type,
        dfd.name,
        dfd.lastname,
        dfd.description,
        dfd.amount,
        dfd.department,
        dfd.channel_type,
        dfd.is_uploaded,
        dfd.upload_error,
        pyrp.error_code,
        pyrp.error_message,
        pyrq.created_at AS date_request,
        pyrp.created_at AS date_response,
        nmw.created_at AS date_webhook,
        nmw.status_change_date_time AS date_webhook_status_change,
        TIMESTAMPDIFF(SECOND, pyrq.created_at, nmw.created_at) AS diff_response,
        bb.name AS bank,
        nmw.status AS STATUS_FINAL,
        JSON_EXTRACT(nmw.notification_response, '$.errors[0].message') AS detail_error
    FROM dispersion_file_detail dfd
    INNER JOIN dispersion_file_history dfh 
        ON dfd.id_dispersion_file_history = dfh.id
    LEFT JOIN payout_order_requests pyrq 
        ON dfd.id_row_file = pyrq.order_id
    LEFT JOIN payout_order_responses pyrp 
        ON pyrq.id = pyrp.payout_request_id
    LEFT JOIN (
        SELECT nmw_group.*
        FROM notification_monnet_webhook nmw_group
        INNER JOIN (
            SELECT nmw_sub_group.payout_order_id, 
			MAX(nmw_sub_group.status_change_date_time) AS max_date_change_date,
            MAX(nmw_sub_group.created_at) AS max_date_created_at
            FROM notification_monnet_webhook nmw_sub_group
            GROUP BY nmw_sub_group.payout_order_id
        ) nmw_latest ON nmw_group.payout_order_id = nmw_latest.payout_order_id
                     AND nmw_group.status_change_date_time = nmw_latest.max_date_change_date
                     AND nmw_group.created_at = nmw_latest.max_date_created_at
    ) nmw ON pyrq.order_id = nmw.payout_order_id
    LEFT JOIN beneficiary_bank bb 
        ON pyrq.bank_code = bb.code
    WHERE dfh.id = in_dispersion_file_history_id;
END //

DELIMITER ;

DELIMITER //

CREATE DEFINER=`root`@`%` PROCEDURE `EP_ENTEL_MISLUCAS`.`get_dispersion_file_history_detail`(
    IN in_dispersion_file_history_id CHAR(36)
)
BEGIN
    SELECT 
        dfd.name,
        dfd.lastname,
        dfd.amount,
        dfd.document_type,
        dfd.document_number,
        dfd.description,
        dfd.is_uploaded,
        dfd.upload_error,
        pors.status,
        pors.stage,
        pors.payout_response,
        nmw.stage AS bank_result,
        pors.id AS payout_order_response_id,
        nmw.id AS webhook_id
    FROM dispersion_file_detail dfd 
    INNER JOIN dispersion_file_history dfh ON dfd.id_dispersion_file_history = dfh.id
    LEFT JOIN payout_order_requests porq ON dfd.id_row_file = porq.order_id
    LEFT JOIN payout_order_responses pors ON porq.id = pors.payout_request_id
    LEFT JOIN (
        SELECT nmw_group.*
        FROM notification_monnet_webhook nmw_group
        INNER JOIN (
            SELECT nmw_sub_group.payout_order_id, 
			MAX(nmw_sub_group.status_change_date_time) AS max_date_change_date,
            MAX(nmw_sub_group.created_at) AS max_date_created_at
            FROM notification_monnet_webhook nmw_sub_group
            GROUP BY nmw_sub_group.payout_order_id
        ) nmw_latest ON nmw_group.payout_order_id = nmw_latest.payout_order_id
                     AND nmw_group.status_change_date_time = nmw_latest.max_date_change_date
                     AND nmw_group.created_at = nmw_latest.max_date_created_at
    ) nmw ON porq.order_id = nmw.payout_order_id
    WHERE dfd.id_dispersion_file_history = in_dispersion_file_history_id;
END //

DELIMITER ;