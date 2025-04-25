USE `EP_ENTEL_MISLUCAS`;
DROP procedure IF EXISTS `generate_manager_report_history`;

DELIMITER $$
USE `EP_ENTEL_MISLUCAS`$$
CREATE PROCEDURE `generate_manager_report_history` ( -- call generate_manager_report_history(1, 10, '', 3, 2024);
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
		manager_document,
		manager_names,
		manager_type,
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
		q_pdv,
		q_pdvx,
		visit_ratio,
		quota_pdv_new,
		q_pdv_new,
		progress_pdv_new,
		quota_pdvx_new,
		q_pdvx_new,
		progress_pdvx_new,
		q_commerces_without_sale,
		q_commerces_without_sale_percentage,
		active_portafolio,
		active_portafolio_percentage,
		q_visits,
		days_worked,
		q_commerces_visited,
		q_commerces_unvisited,
		commerces_visited_percentage,
		total_commerces,
		active_days,
		total_commerces_visited_by_days_worked,
		total_commerces_visited_by_active_days,
		q_commerces_visited_level1_2,
		q_commerces_visited_level3_4,
		q_commerces_visited_level5_6_7,
		q_total_pdv_level1_2,
		q_total_pdv_level3_4,
		q_total_pdv_level5_6_7,
		commerces_visited_level1_2_by_total_commerces_level1_2_pct,
		commerces_visited_level3_4_by_total_commerces_level3_4_pct,
		commerces_visited_level5_6_7_by_total_commerces_level5_6_7_pct,
		q_new_commerces
	FROM
		manager_report_history
	WHERE
		month = p_month AND year = p_year
        AND (p_managers_id IS NULL OR FIND_IN_SET(manager_id, p_managers_id))
	ORDER BY
		id DESC
	LIMIT 
		v_offset_value, p_page_size;
END$$

DELIMITER ;

