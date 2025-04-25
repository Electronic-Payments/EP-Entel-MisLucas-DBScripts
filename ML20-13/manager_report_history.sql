CREATE TABLE manager_report_history (
    total_records INT NOT NULL,
    manager_document VARCHAR(255),
    manager_names VARCHAR(255),
    manager_type VARCHAR(255),
    quota_pp DOUBLE,
    progress_pp DOUBLE,
    nc_pp DOUBLE,
    ur DOUBLE,
    proy_pp DOUBLE,
    cumpl_pp VARCHAR(255),
    quota_ss DOUBLE,
    progress_ss DOUBLE,
    nc_ss DOUBLE,
    proy_ss DOUBLE,
    cumpl_ss VARCHAR(255),
    q_pdv INT,
    q_pdvx INT,
    visit_ratio DOUBLE,
    quota_pdv_new INT,
    q_pdv_new INT,
    progress_pdv_new VARCHAR(255),
    quota_pdvx_new INT,
    q_pdvx_new INT,
    progress_pdvx_new VARCHAR(255),
    q_commerces_without_sale INT,
    q_commerces_without_sale_percentage VARCHAR(255),
    active_portafolio INT,
    active_portafolio_percentage VARCHAR(255),
    q_visits INT,
    days_worked INT,
    q_commerces_visited INT,
    q_commerces_unvisited INT,
    commerces_visited_percentage VARCHAR(255),
    total_commerces INT,
    active_days INT,
    total_commerces_visited_by_days_worked DOUBLE,
    total_commerces_visited_by_active_days DOUBLE,
    q_commerces_visited_level1_2 INT,
    q_commerces_visited_level3_4 INT,
    q_commerces_visited_level5_6_7 INT,
    q_total_pdv_level1_2 INT,
    q_total_pdv_level3_4 INT,
    q_total_pdv_level5_6_7 INT,
    commerces_visited_level1_2_by_total_commerces_level1_2_pct VARCHAR(255),
    commerces_visited_level3_4_by_total_commerces_level3_4_pct VARCHAR(255),
    commerces_visited_level5_6_7_by_total_commerces_level5_6_7_pct VARCHAR(255),
    q_new_commerces INT
);

ALTER TABLE `EP_ENTEL_MISLUCAS`.`manager_report_history` 
DROP COLUMN `total_records`;

ALTER TABLE `EP_ENTEL_MISLUCAS`.`manager_report_history` 
ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT FIRST,
ADD PRIMARY KEY (`id`);
;

ALTER TABLE `EP_ENTEL_MISLUCAS`.`manager_report_history` 
ADD COLUMN `month` INT NULL AFTER `id`,
ADD COLUMN `year` INT NULL AFTER `month`;

ALTER TABLE `EP_ENTEL_MISLUCAS`.`manager_report_history` 
ADD COLUMN `manager_id` INT NULL AFTER `year`;

