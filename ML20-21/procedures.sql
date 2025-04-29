DELIMITER $$
CREATE DEFINER=`rootDev`@`%` PROCEDURE `get_permissions_screens_actions`(
    IN in_user_id CHAR(36),
    IN in_application_id CHAR(36)
)
BEGIN
WITH RECURSIVE user_roles_group AS (
    SELECT ur.role_id
    FROM user_roles ur
    WHERE ur.user_id = in_user_id
      AND ur.active = 1

    UNION ALL

    SELECT rh.parent_role_id
    FROM user_roles_group ru
             JOIN role_hierarchies rh ON ru.role_id = rh.role_id
)
SELECT
    s.id AS screen_id,
    s.route AS screen_route,
    s.code AS screen_code,
    sp.code AS screen_parent_code,
    sp.route AS screen_parent_route,
    a.id AS application_id,
    -- a.name AS application_name,
    GROUP_CONCAT(DISTINCT ac.code ORDER BY ac.id SEPARATOR ',') AS available_actions
FROM user_roles_group u
         JOIN role_permissions rp ON u.role_id = rp.role_id
         JOIN permissions p ON rp.permission_id = p.id
         JOIN screens s ON p.screen_id = s.id
         LEFT JOIN screens sp ON s.parent_screen_id = sp.id
         JOIN applications a ON s.application_id = a.id
         JOIN actions ac ON p.action_id = ac.id
WHERE s.active = 1
  AND p.active = 1
  AND a.id = in_application_id
GROUP BY s.id, a.id;
END$$
DELIMITER ;
