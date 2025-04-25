DROP PROCEDURE IF EXISTS list_recursive_actors_by_type_and_responsibles;
DELIMITER $$

CREATE PROCEDURE list_recursive_actors_by_type_and_responsibles(
	IN p_actor_type_code VARCHAR(50),
    IN p_responsibles_id TEXT    
)
BEGIN
    WITH RECURSIVE cte_actors_recursive AS (
        -- Caso base: Seleccionamos los actores que coinciden con cualquier filtro proporcionado
        SELECT 
            a.id,
            aty.code AS type
        FROM actors a
        JOIN actor_types aty ON aty.id = a.actor_type_id
        WHERE 
            FIND_IN_SET(a.id, p_responsibles_id) > 0

        UNION ALL

        -- Recursión: Encontramos los actores debajo en la jerarquía de los actores filtrados
        SELECT 
            a.id,
            aty.code AS type
        FROM actor_hierarchies ah
        JOIN cte_actors_recursive ar ON ar.id = ah.responsible_id
        JOIN actors a ON a.id = ah.actor_id
        JOIN actor_types aty ON aty.id = a.actor_type_id
    )
    SELECT * FROM cte_actors_recursive WHERE type = "MANAGER";
END $$

DELIMITER ;
