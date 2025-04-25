USE `EP_ENTEL_MISLUCAS`;
DROP function IF EXISTS `determine_projected_level`;

USE `EP_ENTEL_MISLUCAS`;
DROP function IF EXISTS `Data`.`determine_projected_level`;
;

DELIMITER $$
USE `EP_ENTEL_MISLUCAS`$$
CREATE FUNCTION `determine_projected_level`(proy_pp DECIMAL(10, 2)) RETURNS varchar(30) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE v_level VARCHAR(30);
--
    IF proy_pp >= 81 THEN
        SET v_level = 'NIVEL 6';
    ELSEIF proy_pp >= 56 THEN
        SET v_level = 'NIVEL 5';
    ELSEIF proy_pp >= 36 THEN
        SET v_level = 'NIVEL 4';
    ELSEIF proy_pp >= 21 THEN
        SET v_level = 'NIVEL 3';
    ELSEIF proy_pp >= 11 THEN
        SET v_level = 'NIVEL 2';
    ELSEIF proy_pp >= 1 THEN
        SET v_level = 'NIVEL 1';
    ELSE
        SET v_level = 'FUERA DE RANGO';
    END IF;

    RETURN nivel;
END$$

DELIMITER ;
;

