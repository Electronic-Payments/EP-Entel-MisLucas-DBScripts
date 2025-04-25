INSERT INTO `actions` (id, `name`, `description`) VALUES (uuid(), 'Seleccionar Socio', 'Permite seleccionar filtro de socios en el módulo de reportes.');
INSERT INTO `actions` (id, `name`, `description`) VALUES (uuid(), 'Seleccionar Jefe', 'Permite seleccionar filtro de jefes en el módulo de reportes.');
INSERT INTO `actions` (id, `name`, `description`) VALUES (uuid(), 'Seleccionar Supervisor', 'Permite seleccionar filtro de supervisores en el módulo de reportes.');
INSERT INTO `actions` (id, `name`, `description`) VALUES (uuid(), 'Seleccionar Gestor', 'Permite seleccionar filtro de gestores en el módulo de reportes.');
INSERT INTO `actions` (id,`code`, `name`, `description`) VALUES (uuid(),'SELECT_KAM', 'Seleccionar Kam', 'Permite seleccionar filtro de kam en el módulo de reportes.');

ALTER TABLE `actions` 
ADD COLUMN `code` VARCHAR(45) NULL AFTER `id`,
ADD UNIQUE INDEX `code_UNIQUE` (`code` ASC) VISIBLE;
;

UPDATE `actions` SET `code` = 'SEE' WHERE (`id` = 'b3c7d8e0-1a2b-4c3d-8e9f-0a1b2c3d4e5f');
UPDATE `actions` SET `code` = 'CREATE' WHERE (`id` = 'c4d5e6f7-2b3c-4d5e-8f9a-1b2c3d4e5f6a');
UPDATE `actions` SET `code` = 'EDIT' WHERE (`id` = 'd5e6f7a8-3c4d-5e6f-9a0b-2c3d4e5f6a7b');
UPDATE `actions` SET `code` = 'DELETE' WHERE (`id` = 'e6f7a8b9-4d5e-6f7a-8b9c-3d4e5f6a7b8c');
UPDATE `actions` SET `code` = 'SELECT_PARTNER' WHERE (`id` = 'f350d98c-195a-11f0-a4f2-42010a400014');
UPDATE `actions` SET `code` = 'SELECT_BOSS' WHERE (`id` = 'f36695c7-195a-11f0-a4f2-42010a400014');
UPDATE `actions` SET `code` = 'SELECT_SUPERVISOR' WHERE (`id` = 'f37b2db0-195a-11f0-a4f2-42010a400014');
UPDATE `actions` SET `code` = 'SELECT_MANAGER' WHERE (`id` = 'f39018cc-195a-11f0-a4f2-42010a400014');
UPDATE `actions` SET `code` = 'EXPORT' WHERE (`id` = 'f7a8b9c0-5e6f-7a8b-9c0d-4e5f6a7b8c9d');

