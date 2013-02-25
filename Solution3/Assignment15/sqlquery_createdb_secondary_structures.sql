CREATE  TABLE `bioprakt6`.`secondary_structures` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `secondary_structure` LONGTEXT NOT NULL ,
  `fromseq` INT(10) UNSIGNED NOT NULL ,
  `type` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;