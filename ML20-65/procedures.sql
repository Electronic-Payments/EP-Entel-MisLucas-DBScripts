-- stored procedure get_sales_details_summary
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `get_sales_details_summary`(IN in_date_filter DATE)
BEGIN
    DECLARE ACTIVE_STATUS TINYINT DEFAULT 1;
    DECLARE HAS_NOT_ERROR TINYINT DEFAULT 0;

SELECT
    dsd.manager_id AS manager,
    dsd.commerce_id AS commerce,
    dsd.seller_id AS seller,
    SUM(dsd.sum_pp) AS prom_sum_pp,
    SUM(dsd.sum_vr_pp) AS prom_sum_vr_pp,
    SUM(dsd.sum_pp5_vr) AS prom_sum_pp5_vr,
    SUM(dsd.sum_pp_flex_vr) AS prom_sum_pp_flex_vr,
    SUM(dsd.porta_pp) AS prom_porta_pp,
    SUM(dsd.sum_pp5_porta) AS prom_sum_pp5_porta,
    SUM(dsd.sum_pp_flex_porta) AS prom_sum_pp_flex_porta,
    SUM(dsd.ur_s) AS prom_ur_s,
    SUM(dsd.non_commissionables_pp) AS prom_non_commissionables_pp,
    SUM(dsd.sum_nc_vr_pp) AS prom_sum_nc_vr_pp,
    SUM(dsd.sum_pp5_vr_nc) AS prom_sum_pp5_vr_nc,
    SUM(dsd.sum_nc_pp_flex_vr) AS prom_sum_nc_pp_flex_vr,
    SUM(dsd.non_commissionables_porta_pp) AS prom_non_commissionables_porta_pp,
    SUM(dsd.sum_nc_porta_pp5) AS prom_sum_nc_porta_pp5,
    SUM(dsd.sum_nc_pp_flex_porta) AS prom_sum_nc_pp_flex_porta,
    SUM(dsd.sum_ss) AS prom_sum_ss,
    SUM(dsd.sum_ss_vr) AS prom_sum_ss_vr,
    SUM(dsd.sum_oss) AS prom_sum_oss,
    SUM(dsd.sum_porta_90_ss_oss) AS prom_sum_porta_90_ss_oss,
    SUM(dsd.sum_opp) AS prom_sum_opp,
    SUM(dsd.sum_porta_90_ss_opp) AS prom_sum_porta_90_ss_opp,
    SUM(dsd.sum_llaa) AS prom_sum_llaa,
    SUM(dsd.sum_nc_ss) AS prom_sum_nc_ss,
    SUM(dsd.sum_nc_ss_vr) AS prom_sum_nc_ss_vr,
    SUM(dsd.sum_nc_oss) AS prom_sum_nc_oss,
    SUM(dsd.sum_porta_90_nc_ss_oss) AS prom_sum_porta_90_nc_ss_oss,
    SUM(dsd.sum_nc_opp) AS prom_sum_nc_opp,
    SUM(dsd.sum_porta_90_nc_ss_opp) AS prom_sum_porta_90_nc_ss_opp,
    SUM(dsd.sum_nc_llaa) AS prom_sum_nc_llaa
FROM daily_sales_details dsd
         INNER JOIN daily_sales_informations dsi ON dsd.daily_sales_information_id = dsi.id
WHERE dsd.active = ACTIVE_STATUS
  AND dsd.has_error = HAS_NOT_ERROR
  AND dsi.active = ACTIVE_STATUS
  AND dsi.sales_progress_date = in_date_filter
  AND dsd.manager_id IS NOT NULL
  AND dsd.commerce_id IS NOT NULL
-- AND dsd.seller_id IS NOT NULL
GROUP BY manager, commerce, seller;
END$$
DELIMITER ;



-- stored procedure update_is_end_of_month
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_is_end_of_month`(IN in_year INT, IN in_month INT)
BEGIN
    DECLARE start_date DATE;
    DECLARE end_date DATE;
    DECLARE FLG_ACTIVE INT DEFAULT 1;  -- Variable para indicar registros activos (1 = activo)
    DECLARE FLG_INACTIVE INT DEFAULT 0; -- Variable para indicar registros inactivos (0 = inactivo)

    -- Construir fecha de inicio del mes (ej. '2025-04-01')
    SET start_date = STR_TO_DATE(CONCAT(in_year, '-', in_month, '-01'), '%Y-%m-%d');

    -- Construir fecha de inicio del siguiente mes (ej. '2025-05-01')
    SET end_date = DATE_ADD(start_date, INTERVAL 1 MONTH);

    -- Paso 1: Resetear a false todos los registros activos del mes
UPDATE daily_sales_informations dsi
SET dsi.is_end_of_month = FLG_INACTIVE
WHERE dsi.sales_progress_date >= start_date
  AND dsi.sales_progress_date < end_date;
-- AND dsi.active = FLG_ACTIVE;

-- Paso 2: Establecer a true solo el registro con la última fecha del mes y activo
UPDATE daily_sales_informations dsi
    JOIN (
    SELECT dsi2.sales_progress_date AS max_sales_progress_date, dsi2.non_commisionable_date AS max_non_commisionable_date, dsi2.top_up_date as max_top_up_date
    FROM daily_sales_informations dsi2
    WHERE dsi2.sales_progress_date >= start_date
    AND dsi2.sales_progress_date < end_date
    AND dsi2.active = FLG_ACTIVE
    ORDER BY
    dsi2.sales_progress_date DESC,
    dsi2.non_commisionable_date DESC,
    dsi2.top_up_date DESC
    LIMIT 1
    ) AS sub
ON dsi.sales_progress_date = sub.max_sales_progress_date
    AND dsi.non_commisionable_date = sub.max_non_commisionable_date
    AND dsi.top_up_date = sub.max_top_up_date
    SET dsi.is_end_of_month = FLG_ACTIVE
WHERE dsi.active = FLG_ACTIVE;
END$$
DELIMITER ;


-- stored procedure get_responsible_persons_by_seller_id
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `get_responsible_persons_by_seller_id`(
    IN in_seller_id CHAR(36)
)
BEGIN
	DECLARE v_is_active TINYINT DEFAULT '1';
    DECLARE v_seller_code VARCHAR(50) DEFAULT 'SELLER';
    DECLARE v_manager_code VARCHAR(50) DEFAULT 'MANAGER';
    DECLARE v_commerce_code_pdv VARCHAR(50) DEFAULT 'PDV';
    DECLARE v_commerce_code_pdvx VARCHAR(50) DEFAULT 'PDVX';
    DECLARE v_commerce_code_pdv_e2 VARCHAR(50) DEFAULT 'PDV E2';

WITH SellerToCommerce AS (
    SELECT
        a_seller.id AS seller_id,
        a_commerce.id AS commerce_id
    FROM actors a_seller
             JOIN actor_types at_seller ON a_seller.actor_type_id = at_seller.id
             JOIN actor_hierarchies ah_seller ON a_seller.id = ah_seller.actor_id
             JOIN actors a_commerce ON ah_seller.responsible_id = a_commerce.id
             JOIN actor_types at_commerce ON a_commerce.actor_type_id = at_commerce.id
    WHERE
        a_seller.active = v_is_active
      AND a_commerce.active = v_is_active
      AND a_seller.id = in_seller_id
      AND at_seller.code = v_seller_code
      AND at_commerce.code IN (v_commerce_code_pdv, v_commerce_code_pdvx, v_commerce_code_pdv_e2)
),
     CommerceToManager AS (
         SELECT
             a_commerce.id AS commerce_id,
             a_manager.id AS manager_id
         FROM actors a_commerce
                  JOIN actor_hierarchies ah_commerce ON a_commerce.id = ah_commerce.actor_id
                  JOIN actors a_manager ON ah_commerce.responsible_id = a_manager.id
                  JOIN actor_types at_manager ON a_manager.actor_type_id = at_manager.id
         WHERE
             a_commerce.active = v_is_active
           AND a_manager.active = v_is_active
           AND at_manager.code = v_manager_code
     )

SELECT
    stc.seller_id AS actor_seller_id,
    stc.commerce_id AS actor_commerce_id,
    ctm.manager_id AS actor_manager_id
FROM SellerToCommerce stc
         JOIN CommerceToManager ctm ON stc.commerce_id = ctm.commerce_id;
END$$
DELIMITER ;


