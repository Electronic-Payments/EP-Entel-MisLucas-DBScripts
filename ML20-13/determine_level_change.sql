USE `EP_ENTEL_MISLUCAS`;
DROP function IF EXISTS `determine_level_change`;

USE `EP_ENTEL_MISLUCAS`;
DROP function IF EXISTS `EP_ENTEL_MISLUCAS`.`determine_level_change`;
;

DELIMITER $$
USE `EP_ENTEL_MISLUCAS`$$
CREATE FUNCTION `determine_level_change`(
    p_current_level_month VARCHAR(40), 
    p_previous_level_month VARCHAR(40)
) RETURNS varchar(20) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE v_resultado VARCHAR(20);
    DECLARE v_current_level INT;
    DECLARE v_previous_level INT;

	-- Extraer solo el número del nivel (asumiendo formato 'NIVEL X')
    SET v_current_level = CAST(SUBSTRING_INDEX(p_current_level_month, ' ', -1) AS UNSIGNED);
    SET v_previous_level = CAST(SUBSTRING_INDEX(p_previous_level_month, ' ', -1) AS UNSIGNED);
    
    -- Lógica para determinar el cambio
    IF p_previous_level_month IS NULL OR p_current_level_month IS NULL THEN
        SET v_resultado = 'INDETERMINADO';
    ELSEIF v_current_level > v_previous_level THEN
        SET v_resultado = CONCAT('SUBIÓ ', v_current_level - v_previous_level, ' NIVEL');
    ELSEIF v_current_level < v_previous_level THEN
        SET v_resultado = CONCAT('BAJÓ ', v_previous_level - v_current_level, ' NIVEL');
    ELSE
        SET v_resultado = 'MANTUVO';
    END IF;

    -- Retorna el resultado
    RETURN v_resultado;
END$$

DELIMITER ;
;

