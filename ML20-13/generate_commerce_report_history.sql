USE `EP_ENTEL_MISLUCAS`;
DROP procedure IF EXISTS `generate_commerce_report_history`;

DELIMITER $$
USE `EP_ENTEL_MISLUCAS`$$
CREATE PROCEDURE `generate_commerce_report_history` ( -- call generate_commerce_report_history(1, 10, '', 3, 2024);
	IN p_page INT,
    IN p_page_size INT,
    IN p_managers_id TEXT,
    IN p_month INT,
    IN p_year INT
) 
BEGIN   
	DECLARE v_offset_value INT;

	SET v_offset_value = (p_page - 1) * p_page_size;

	SELECT
		COUNT(*) OVER() AS total_records,
		commerce_document,
		commerce_names,
		commerce_type,
		department,
		province,
		district,
		manager_document,
		manager_names,
		q_visits,
		quota_pp,
		progress_pp,
		nc_pp,
		ur,
		proy_pp,
		cumpl_pp,
		quota_ss,
		progress_ss,
		nc_ss,
		proy_ss,
		cumpl_ss,
		current_level_month,
		previous_level_month,
		improved,
		projected_level,
		progress_pp_previous_month,
		progress_pp_current_month,
		var,
		brand_campaign
	FROM
		commerce_report_history
	WHERE
		month = p_month AND year = p_year
        AND (p_managers_id IS NULL OR FIND_IN_SET(manager_id, p_managers_id))
	ORDER BY
		id DESC
	LIMIT 
		v_offset_value, p_page_size;
END$$

DELIMITER ;

