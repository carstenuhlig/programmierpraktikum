CREATE  TABLE `bioprakt6`.`structure_alignments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `structure_alignment` LONGTEXT NOT NULL ,
  `align_id` INT NULL ,
  `fromseq` INT(10) UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;