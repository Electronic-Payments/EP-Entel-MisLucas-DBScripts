USE `EP_ENTEL_MISLUCAS`;
DROP procedure IF EXISTS `generate_manager_report_for_export`;

DELIMITER $$
USE `EP_ENTEL_MISLUCAS`$$
CREATE PROCEDURE `generate_manager_report_for_export` ( -- call generate_manager_report_for_export(1, 10);
    IN p_managers_id TEXT
) 
BEGIN   
	DECLARE v_offset_value INT;
    DECLARE v_month_start_date DATE;
	DECLARE v_last_sale_date DATE;
	DECLARE v_day_accumulated_progress DECIMAL(10,2);
    DECLARE v_total_days_in_month DECIMAL(10,2);	
	
    SET v_offset_value = (p_page - 1) * p_page_size;
	SET v_month_start_date = (SELECT DATE_FORMAT(CURDATE(), '%Y-%m-01'));
	SET v_last_sale_date = (SELECT MAX(sales_progress_date) FROM daily_sales_informations WHERE is_end_of_month = 1 AND active = 1);
	SET v_day_accumulated_progress = (SELECT cumulative FROM weighted_days WHERE date = v_last_sale_date);
    SET v_total_days_in_month = (SELECT MAX(cumulative) FROM weighted_days);

	WITH cte_sales_by_commerce AS (
		SELECT
			c.manager_id,
			dsr.commerce_id,
			SUM(CASE WHEN sc.code = 'PREPAGO' THEN dsrd.total_progress END) AS progress_pp,
			SUM(CASE WHEN sc.code = 'PREPAGO' THEN dsrd.total_commissionable_sales END) AS nc_pp,
			SUM(CASE WHEN sc.code = 'PREPAGO' THEN dsrd.total_recharged_unit END) AS ur,
			SUM(CASE WHEN sc.code = 'POSTPAGO' THEN dsrd.total_progress END) AS progress_ss,    
			SUM(CASE WHEN sc.code = 'POSTPAGO' THEN dsrd.total_commissionable_sales END) AS nc_ss
		FROM daily_sales_results dsr
		JOIN daily_sales_informations dsi ON dsi.id = dsr.daily_sales_information_id AND dsi.sales_progress_date = v_last_sale_date AND dsi.is_end_of_month = 1 AND dsi.active = 1
		JOIN commerces c ON c.id = dsr.commerce_id
		JOIN daily_sales_result_category dsrc ON dsrc.daily_sales_result_id = dsr.id
		JOIN sales_categories sc ON sc.id = dsrc.sales_categories_id
		JOIN daily_sales_result_details dsrd ON dsrd.daily_sales_result_category_id = dsrc.id
		GROUP BY c.manager_id, dsr.commerce_id
	),
	cte_sales_by_manager AS (
		SELECT
			manager_id,
			COUNT(DISTINCT commerce_id) AS commerces_with_sale,
			COUNT(DISTINCT CASE WHEN progress_pp > 5 THEN commerce_id END) AS active_commerces,
			SUM(progress_pp) AS progress_pp,
			SUM(nc_pp) AS nc_pp,
			SUM(ur) AS ur,
			SUM(progress_ss) AS progress_ss,
			SUM(nc_ss) AS nc_ss
		FROM cte_sales_by_commerce
		GROUP BY manager_id
	),
    cte_sales_projection_by_manager AS (
		SELECT
            manager_id,
            ROUND(((progress_pp - (nc_pp / 2)) / v_day_accumulated_progress) * v_total_days_in_month, 0) AS proy_pp,
            ROUND(((progress_ss - nc_ss) / v_day_accumulated_progress) * v_total_days_in_month, 0) AS proy_ss
        FROM cte_sales_by_manager
    ),
    cte_quotes_by_manager AS (
		SELECT
			c.manager_id,
            SUM(sq.quota_pp) as quota_pp,
            SUM(sq.quota_ss) as quota_ss,
            SUM(CASE WHEN c.type = 'PDV' AND DATE(c.created_at) BETWEEN v_month_start_date AND v_last_sale_date THEN sq.quota_pp END) as quota_pp_pdv_new,
            SUM(CASE WHEN c.type = 'PDVX' AND DATE(c.created_at) BETWEEN v_month_start_date AND v_last_sale_date THEN sq.quota_pp END) as quota_pp_pdvx_new,
            SUM(CASE WHEN c.type = 'PDV' AND DATE(c.created_at) BETWEEN v_month_start_date AND v_last_sale_date THEN sq.quota_ss END) as quota_ss_pdv_new,
            SUM(CASE WHEN c.type = 'PDVX' AND DATE(c.created_at) BETWEEN v_month_start_date AND v_last_sale_date THEN sq.quota_ss END) as quota_ss_pdvx_new
		FROM sales_quotes sq
        JOIN commerces c ON c.id = sq.commerce_id
        GROUP BY c.manager_id
    ),
    cte_commerces_by_manager AS (
		SELECT 
			c.manager_id,
			COUNT(c.id) AS total_commerces,
            COUNT(CASE WHEN sq.closing_level IN ('NIVEL 1', 'NIVEL 2') THEN c.id END) AS total_commerces_level_1_2,
            COUNT(CASE WHEN sq.closing_level IN ('NIVEL 3', 'NIVEL 4') THEN c.id END) AS total_commerces_level_3_4,
            COUNT(CASE WHEN sq.closing_level IN ('NIVEL 5', 'NIVEL 6', 'NIVEL 7') THEN c.id END) AS total_commerces_level_5_6_7,
            COUNT(CASE WHEN c.type = 'PDV' THEN 1 END) AS total_commerces_pdv,
			COUNT(CASE WHEN c.type = 'PDVX' THEN 1 END) AS total_commerces_pdvx,
			COUNT(CASE WHEN c.type = 'PDV' AND DATE(c.created_at) BETWEEN v_month_start_date AND v_last_sale_date THEN 1 END) AS number_new_commerces_pdv,
            COUNT(CASE WHEN c.type = 'PDVX' AND DATE(c.created_at) BETWEEN v_month_start_date AND v_last_sale_date THEN 1 END) AS number_new_commerces_pdvx
		FROM commerces c
        LEFT JOIN sales_quotes sq ON sq.commerce_id = c.id
		GROUP BY c.manager_id
	),
    cte_visits_by_manager AS (
		SELECT
			vs.manager_id,
			COUNT(vs.id) AS total_visits,
			COUNT(DISTINCT vs.commerce_id) AS commerces_visited,
			COUNT(DISTINCT CASE WHEN sq.closing_level IN ('NIVEL 1', 'NIVEL 2') THEN vs.commerce_id END) AS commerces_visited_level_1_2,
			COUNT(DISTINCT CASE WHEN sq.closing_level IN ('NIVEL 3', 'NIVEL 4') THEN vs.commerce_id END) AS commerces_visited_level_3_4,
			COUNT(DISTINCT CASE WHEN sq.closing_level IN ('NIVEL 5', 'NIVEL 6', 'NIVEL 7') THEN vs.commerce_id END) AS commerces_visited_level_5_6_7
		FROM visit_sale vs
		JOIN sales_quotes sq ON sq.commerce_id = vs.commerce_id
		WHERE vs.created_at BETWEEN v_month_start_date AND v_last_sale_date
		GROUP BY vs.manager_id
    ),
    cte_evaluation_days_worked_by_manager AS (
		SELECT
            v.manager_id,
            DATE(v.created_at) AS visit_date,
            CASE
				WHEN m.manager_type_code = "MIXED" AND COUNT(v.id) >= 10 THEN 1
				WHEN m.manager_type_code = "PERIPHERY" AND COUNT(v.id) >= 7 THEN 1
				WHEN m.manager_type_code = "CITY" AND COUNT(v.id) >= 15 THEN 1
				ELSE 0
			END AS day_worked
        FROM visit_sale v
        JOIN managers m on m.id = v.manager_id
        WHERE v.created_at BETWEEN v_month_start_date AND v_last_sale_date
        GROUP BY 1, 2
    ),
    cte_sum_days_worked_by_manager AS (
		SELECT
			manager_id,
            COUNT(*) AS total_active_days,
            SUM(day_worked) AS total_days_worked
        FROM cte_evaluation_days_worked_by_manager
		GROUP BY manager_id
    )
	SELECT
		m.document_number AS manager_document,
		m.names AS manager_names,
		m.manager_type_value AS manager_type,
		qm.quota_pp,
		sm.progress_pp,
		sm.nc_pp,
		sm.ur,
		spm.proy_pp,
		CONCAT(ROUND((spm.proy_pp / qm.quota_pp) * 100, 0), '%') AS cumpl_pp,
		qm.quota_ss,
		sm.progress_ss,
		sm.nc_ss,
		spm.proy_ss,
		CONCAT(ROUND((spm.proy_ss / qm.quota_ss) * 100, 0), '%') AS cumpl_ss,
		cm.total_commerces_pdv AS q_pdv,
		cm.total_commerces_pdvx AS q_pdvx,
		(vm.total_visits / vm.commerces_visited) AS visit_ratio,        
		(qm.quota_pp_pdv_new + qm.quota_ss_pdv_new) AS quota_pdv_new,
		cm.number_new_commerces_pdv AS q_pdv_new,
		CONCAT((cm.number_new_commerces_pdv / (qm.quota_pp_pdv_new + qm.quota_ss_pdv_new)), '%') AS progress_pdv_new,        
		(qm.quota_pp_pdvx_new + qm.quota_ss_pdvx_new) AS quota_pdvx_new,
		cm.number_new_commerces_pdvx AS q_pdvx_new,
		CONCAT((cm.number_new_commerces_pdvx / (qm.quota_pp_pdvx_new + qm.quota_ss_pdvx_new)), '%') AS progress_pdvx_new,        
		(cm.total_commerces - sm.commerces_with_sale) AS q_commerces_without_sale,
		CONCAT(ROUND(((cm.total_commerces - sm.commerces_with_sale) / cm.total_commerces) * 100, 0), '%') AS q_commerces_without_sale_percentage,
        sm.active_commerces as active_portafolio,
        CONCAT(ROUND((sm.active_commerces / cm.total_commerces) * 100, 0), '%') AS active_portafolio_percentage,
        vm.total_visits as q_visits,
        sdwm.total_days_worked as days_worked,
        vm.commerces_visited as q_commerces_visited,
        (cm.total_commerces - vm.commerces_visited) AS q_commerces_unvisited,
        CONCAT(ROUND((vm.commerces_visited / cm.total_commerces) * 100, 0), '%') AS commerces_visited_percentage,
        cm.total_commerces,
        sdwm.total_active_days as active_days,
        (vm.commerces_visited / sdwm.total_days_worked) as total_commerces_visited_by_days_worked,
        (vm.commerces_visited / sdwm.total_active_days) as total_commerces_visited_by_active_days,
        vm.commerces_visited_level_1_2 as q_commerces_visited_level_1_2,
        vm.commerces_visited_level_3_4 as q_commerces_visited_level_3_4,
        vm.commerces_visited_level_5_6_7 as q_commerces_visited_level_5_6_7,
        cm.total_commerces_level_1_2 as q_total_pdv_level_1_2,
        cm.total_commerces_level_3_4 as q_total_pdv_level_3_4,
        cm.total_commerces_level_5_6_7 as q_total_pdv_level_5_6_7,
        CONCAT((vm.commerces_visited_level_1_2 / cm.total_commerces_level_1_2), '%') as commerces_visited_level_1_2_by_total_commerces_level_1_2__pct,
        CONCAT((vm.commerces_visited_level_3_4 / cm.total_commerces_level_3_4), '%') as commerces_visited_level_3_4_by_total_commerces_level_3_4__pct,
        CONCAT((vm.commerces_visited_level_5_6_7 / cm.total_commerces_level_5_6_7), '%') as commerces_visited_level_5_6_7_by_total_commerces_level_5_6_7__pct,
        (cm.number_new_commerces_pdv + cm.number_new_commerces_pdvx) AS q_new_commerces
	FROM
		managers m
		JOIN cte_sales_by_manager sm ON sm.manager_id = m.id
        JOIN cte_sales_projection_by_manager spm ON spm.manager_id = m.id
		JOIN cte_commerces_by_manager cm ON cm.manager_id = m.id
        JOIN cte_visits_by_manager vm ON vm.manager_id = m.id
        JOIN cte_sum_days_worked_by_manager sdwm ON sdwm.manager_id = m.id
        JOIN cte_quotes_by_manager qm ON qm.manager_id = m.id
        JOIN cte_total_records tr
	WHERE
		p_managers_id IS NOT NULL AND FIND_IN_SET(m.id, p_managers_id) > 0
	ORDER BY
		m.created_at DESC;
END$$

DELIMITER ;

