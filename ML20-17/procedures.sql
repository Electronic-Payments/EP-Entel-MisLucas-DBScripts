CREATE DEFINER=`rootDev`@`%` PROCEDURE `get_dispersion_file_history_detail`(
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
        TIMESTAMPDIFF(SECOND, pyrq.created_at, nmw.created_at) AS diff_response,
        bb.name AS bank,
        nmw.status AS STATUS_FINAL,
        JSON_EXTRACT(nmw.notification_response, '$.errors[0].message') AS detail_error
    FROM EP_ENTEL_MISLUCAS_UAT.dispersion_file_detail dfd
    INNER JOIN EP_ENTEL_MISLUCAS_UAT.dispersion_file_history dfh 
        ON dfd.id_dispersion_file_history = dfh.id
    LEFT JOIN EP_ENTEL_MISLUCAS_UAT.notification_monnet_webhook nmw 
        ON dfd.id_row_file = nmw.payout_order_id
    LEFT JOIN EP_ENTEL_MISLUCAS_UAT.payout_order_requests pyrq 
        ON dfd.id_row_file = pyrq.order_id
    LEFT JOIN EP_ENTEL_MISLUCAS_UAT.payout_order_responses pyrp 
        ON pyrq.id = pyrp.payout_request_id
    LEFT JOIN EP_ENTEL_MISLUCAS_UAT.beneficiary_bank bb 
        ON pyrq.bank_code = bb.code
    WHERE dfh.id = in_dispersion_file_history_id;
END