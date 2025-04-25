UPDATE `screens` SET `name` = 'Carga masiva' WHERE (`id` = '0a1ff1dd-0b3b-11f0-8f07-42010a400012');
UPDATE `screens` SET `name` = 'Carga de jerarquía' WHERE (`id` = '9d5f15f1-0b3b-11f0-8f07-42010a400012');
UPDATE `screens` SET `route` = '/bulk-upload/hierarchy' WHERE (`id` = '9d5f15f1-0b3b-11f0-8f07-42010a400012');


INSERT INTO `screens` (`name`, `application_id`, `route`, id) VALUES ('Reportes', '00fdcaaa-e15c-489a-b2c8-a847964679f2', '/report' , "34194550-10db-11f0-8f07-42010a400012");
INSERT INTO `screens` (`id`, `name`, `icon`, `application_id`, `parent_screen_id`, `route`) VALUES ('4b81d168-10db-11f0-8f07-42010a400012', 'Reporte de Gestor', '<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"w-6 h-6 side-menu__icon\" width=\"16\" height=\"16\" fill=\"currentColor\" class=\"bi bi-bar-chart-line\" viewBox=\"0 0 16 16\"><path d=\"M11 2a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1v-3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3h1V7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7h1zm1 12h2V2h-2zm-3 0V7H7v7zm-5 0v-3H2v3z\"/></svg>', '00fdcaaa-e15c-489a-b2c8-a847964679f2', '34194550-10db-11f0-8f07-42010a400012', '/report/gestor');

UPDATE `screens` SET `icon` = '<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"w-6 h-6 side-menu__icon\" width=\"16\" height=\"16\" fill=\"currentColor\" class=\"bi bi-diagram-3\" viewBox=\"0 0 16 16\"><path fill-rule=\"evenodd\" d=\"M6 3.5A1.5 1.5 0 0 1 7.5 2h1A1.5 1.5 0 0 1 10 3.5v1A1.5 1.5 0 0 1 8.5 6v1H14a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-1 0V8h-5v.5a.5.5 0 0 1-1 0V8h-5v.5a.5.5 0 0 1-1 0v-1A.5.5 0 0 1 2 7h5.5V6A1.5 1.5 0 0 1 6 4.5zM8.5 5a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5zM0 11.5A1.5 1.5 0 0 1 1.5 10h1A1.5 1.5 0 0 1 4 11.5v1A1.5 1.5 0 0 1 2.5 14h-1A1.5 1.5 0 0 1 0 12.5zm1.5-.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zm4.5.5A1.5 1.5 0 0 1 7.5 10h1a1.5 1.5 0 0 1 1.5 1.5v1A1.5 1.5 0 0 1 8.5 14h-1A1.5 1.5 0 0 1 6 12.5zm1.5-.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zm4.5.5a1.5 1.5 0 0 1 1.5-1.5h1a1.5 1.5 0 0 1 1.5 1.5v1a1.5 1.5 0 0 1-1.5 1.5h-1a1.5 1.5 0 0 1-1.5-1.5zm1.5-.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5z\"/></svg>' WHERE (`id` = '9d5f15f1-0b3b-11f0-8f07-42010a400012');


-- agrega columna code
ALTER TABLE `screens` 
ADD COLUMN `code` VARCHAR(45) NULL AFTER `id`,
ADD UNIQUE INDEX `code_UNIQUE` (`code` ASC) VISIBLE;
;

UPDATE `screens` SET `code` = 'MAIN' WHERE (`id` = '035ff9a7-3309-4efc-97eb-fc7f73a5c2e7');
UPDATE `screens` SET `code` = 'SECURITY' WHERE (`id` = '04f2ee48-b37b-48c5-8270-6b76d014275a');
UPDATE `screens` SET `code` = 'DISPERSION' WHERE (`id` = '08392fdf-15a1-11f0-a4f2-42010a400014');
UPDATE `screens` SET `code` = 'HOME' WHERE (`id` = '1537b938-442e-4564-ac14-d66fa3c2b743');
UPDATE `screens` SET `code` = 'REPORTS' WHERE (`id` = '34194550-10db-11f0-8f07-42010a400012');
UPDATE `screens` SET `code` = 'MANAGER_REPORT' WHERE (`id` = '4b81d168-10db-11f0-8f07-42010a400012');
UPDATE `screens` SET `code` = 'PERMISSIONS' WHERE (`id` = '70fad1e5-a28f-402a-9496-9058abf7d721');
UPDATE `screens` SET `code` = 'USERS' WHERE (`id` = '8141b351-c1f5-4f5a-aa2a-b9ee6b693195');
UPDATE `screens` SET `code` = 'HERARCHY_UPLOAD' WHERE (`id` = '9d5f15f1-0b3b-11f0-8f07-42010a400012');
UPDATE `screens` SET `code` = 'ROLES' WHERE (`id` = 'b41b2557-603a-43e6-9685-b0eb1d8b95cf');
UPDATE `screens` SET `code` = 'COMMERCES_UPLOAD' WHERE (`id` = 'd39e705e-14bc-11f0-8f07-42010a400012');
UPDATE `screens` SET `code` = 'MONNET' WHERE (`id` = 'd8b0ebdd-15a0-11f0-a4f2-42010a400014');
UPDATE `screens` SET `code` = 'SALES' WHERE (`id` = 'db1fbb78-728a-46fa-9269-d0c4ee8b9363');
UPDATE `screens` SET `code` = 'BULK_UPLOAD' WHERE (`id` = 'f27a269e-2120-489a-b134-ed9c801156f8');

