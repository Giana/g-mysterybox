CREATE TABLE `mysterybox_current` (
	`id` BIGINT(255) NOT NULL AUTO_INCREMENT,
    `spawn_date` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
    `spawn_coords_x` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `spawn_coords_y` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `spawn_coords_z` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `spawn_coords_w` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    PRIMARY KEY (`id`) USING BTREE
) COLLATE='latin1_swedish_ci' ENGINE=InnoDB;

CREATE TABLE `mysterybox_history` (
	`id` BIGINT(255) NOT NULL AUTO_INCREMENT,
    `spawn_date` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
    `spawn_coords_x` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `spawn_coords_y` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `spawn_coords_z` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `spawn_coords_w` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `found_date` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
    `loot_name` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
    `recipient_name` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
    `recipient_citizenid` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
    `recipient_license` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
    PRIMARY KEY (`id`) USING BTREE
) COLLATE='latin1_swedish_ci' ENGINE=InnoDB;