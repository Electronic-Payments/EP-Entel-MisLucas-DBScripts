USE `EP_ENTEL_MISLUCAS`;
DROP procedure IF EXISTS `generate_commerce_report`;

DELIMITER $$
USE `EP_ENTEL_MISLUCAS`$$
CREATE PROCEDURE `generate_commerce_report` ( -- call generate_commerce_report(1, 10);
	IN p_page INT,
    IN p_page_size INT,
    IN p_managers_id TEXT
) 
BEGIN   
	DECLARE v_offset_value INT;
    DECLARE v_month_start_date DATE;
    DECLARE v_month_start_previous_date DATE;
	DECLARE v_last_sale_date DATE;
    DECLARE v_last_sale_previous_date DATE;
	DECLARE v_day_accumulated_progress DECIMAL(10,2);
    DECLARE v_total_days_in_month DECIMAL(10,2);	
	
    SET v_offset_value = (p_page - 1) * p_page_size;
	SET v_month_start_date = (SELECT DATE_FORMAT(CURDATE(), '%Y-%m-01'));
	SET v_last_sale_date = (SELECT MAX(sales_progress_date) FROM daily_sales_informations WHERE is_end_of_month = 1 AND active = 1);
	SET v_day_accumulated_progress = (SELECT cumulative FROM weighted_days WHERE date = v_last_sale_date);
    SET v_total_days_in_month = (SELECT MAX(cumulative) FROM weighted_days);
    SET v_month_start_previous_date = DATE_SUB(v_month_start_date, INTERVAL 1 MONTH);
    SET v_last_sale_previous_date = DATE_SUB(v_last_sale_date, INTERVAL 1 MONTH);

	WITH cte_sales_by_commerce AS (
		SELECT
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
		GROUP BY dsr.commerce_id
	),
	cte_sales_projection_by_commerce AS (
		SELECT
            commerce_id,
            ROUND(((progress_pp - (nc_pp / 2)) / v_day_accumulated_progress) * v_total_days_in_month, 0) AS proy_pp,
            ROUND(((progress_ss - nc_ss) / v_day_accumulated_progress) * v_total_days_in_month, 0) AS proy_ss,
            (progress_pp + progress_ss) AS total_progress
        FROM cte_sales_by_commerce
    ),
    cte_sales_previous_by_commerce AS (
		SELECT
			dsr.commerce_id,
			SUM(CASE WHEN sc.code = 'PREPAGO' THEN dsrd.total_progress END) AS progress_pp
		FROM daily_sales_results dsr
		JOIN daily_sales_informations dsi ON dsi.id = dsr.daily_sales_information_id AND dsi.sales_progress_date = v_last_sale_previous_date
		JOIN commerces c ON c.id = dsr.commerce_id
		JOIN daily_sales_result_category dsrc ON dsrc.daily_sales_result_id = dsr.id
		JOIN sales_categories sc ON sc.id = dsrc.sales_categories_id
		JOIN daily_sales_result_details dsrd ON dsrd.daily_sales_result_category_id = dsrc.id
		GROUP BY dsr.commerce_id
	),
    cte_visits_by_commerce AS (
		SELECT
			vs.commerce_id,
			COUNT(vs.id) AS total_visits
		FROM visit_sale vs
		WHERE vs.created_at BETWEEN v_month_start_date AND v_last_sale_date
		GROUP BY vs.commerce_id
    ),
    cte_total_records AS (
		SELECT COUNT(*) AS total_records
		FROM commerces c
        JOIN managers m on m.id = c.manager_id
		JOIN cte_sales_by_commerce sc ON sc.commerce_id = c.id
        JOIN cte_visits_by_commerce vc ON vc.commerce_id = c.id
        JOIN cte_sales_projection_by_commerce spc ON spc.commerce_id = c.id
        JOIN sales_quotes qc ON qc.commerce_id = c.id
        JOIN sales_quotes_history qch ON qch.commerce_id = c.id AND qch.month = MONTH(v_month_start_previous_date) AND qch.year = YEAR(v_last_sale_previous_date)
        JOIN cte_sales_previous_by_commerce scp ON scp.commerce_id = c.id
        LEFT JOIN challenge_prepago chp ON chp.actor_id = c.id
	)
	SELECT
		tr.total_records,
        c.document_number AS commerce_document,
        c.names AS commerce_names,
        c.type AS commerce_type,
        c.department,
        c.province,
        c.district,
        m.id AS manager_id,
        m.document_number AS manager_document,
        m.names AS manager_names,
        vc.total_visits AS q_visits,
        qc.quota_pp,
        sc.progress_pp,
        sc.nc_pp,
        sc.ur,
        spc.proy_pp,
        CONCAT(ROUND((spc.proy_pp / qc.quota_pp) * 100, 0), '%') AS cumpl_pp,
        qc.quota_ss,
        sc.progress_ss,
        sc.nc_ss,
        spc.proy_ss,
        CONCAT(ROUND((spc.proy_ss / qc.quota_ss) * 100, 0), '%') AS cumpl_ss,
        qc.closing_level AS current_level_month,
        qch.closing_level AS previous_level_month,
        determine_level_change(qc.closing_level, qch.closing_level) AS improved,
        determine_projected_level(spc.proy_pp) AS projected_level,
        IFNULL(scp.progress_pp, 0) as progress_pp_previous_month,
        IFNULL(sc.progress_pp, 0) as progress_pp_current_month,
        IFNULL(CONCAT(ROUND((sc.progress_pp / scp.progress_pp) * 100, 0), "%"), "0%") as var,
        CASE 
			WHEN chp.id IS NULL THEN "Sin campaña"
			ELSE "Tiene Campaña"
		END AS brand_campaign
	FROM
		commerces c
        JOIN managers m on m.id = c.manager_id
		JOIN cte_sales_by_commerce sc ON sc.commerce_id = c.id
        JOIN cte_visits_by_commerce vc ON vc.commerce_id = c.id
        JOIN cte_sales_projection_by_commerce spc ON spc.commerce_id = c.id
        JOIN sales_quotes qc ON qc.commerce_id = c.id
        JOIN sales_quotes_history qch ON qch.commerce_id = c.id AND qch.month = MONTH(v_month_start_previous_date) AND qch.year = YEAR(v_last_sale_previous_date)
        JOIN cte_sales_previous_by_commerce scp ON scp.commerce_id = c.id
        LEFT JOIN challenge_prepago chp ON chp.actor_id = c.id
        JOIN cte_total_records tr
	WHERE
		p_managers_id IS NOT NULL AND FIND_IN_SET(c.manager_id, p_managers_id) > 0
	ORDER BY
		m.created_at DESC
	LIMIT
		v_offset_value, p_page_size;
END$$

DELIMITER ;

