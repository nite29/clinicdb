-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema clinic
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `clinic` ;

-- -----------------------------------------------------
-- Schema clinic
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `clinic` DEFAULT CHARACTER SET utf8mb3 ;
USE `clinic` ;

-- -----------------------------------------------------
-- Table `clinic`.`patients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinic`.`patients` (
  `mrn` INT NOT NULL AUTO_INCREMENT,
  `last_name` VARCHAR(45) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `middle_name` VARCHAR(45) NULL DEFAULT NULL,
  `sex` ENUM('M', 'F') NOT NULL,
  `birth_date` DATE NOT NULL,
  `contact_no` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`mrn`),
  UNIQUE INDEX `mrn_UNIQUE` (`mrn` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clinic`.`doctors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinic`.`doctors` (
  `npi` INT NOT NULL AUTO_INCREMENT,
  `last_name` VARCHAR(45) NOT NULL,
  `First_name` VARCHAR(45) NOT NULL,
  `middle_name` VARCHAR(45) NULL DEFAULT NULL,
  `sex` ENUM('M', 'F') NOT NULL,
  `birth_date` DATE NOT NULL,
  `medical_certification` VARCHAR(45) NOT NULL,
  `years_of_service` INT NOT NULL,
  `specialization` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`npi`),
  UNIQUE INDEX `npi_UNIQUE` (`npi` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clinic`.`lab_requests`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinic`.`lab_requests` (
  `lab_request_id` INT NOT NULL AUTO_INCREMENT,
  `npi` INT NOT NULL,
  `mrn` INT NOT NULL,
  `reason` VARCHAR(45) NOT NULL,
  `request_date` DATE NOT NULL,
  PRIMARY KEY (`lab_request_id`),
  UNIQUE INDEX `lab_request_id_UNIQUE` (`lab_request_id` ASC) VISIBLE,
  INDEX `idx_doctors_npi` (`npi` ASC) VISIBLE,
  INDEX `idx_patients_mrn` (`mrn` ASC) VISIBLE,
  CONSTRAINT `fk_lab_requests_mrn`
    FOREIGN KEY (`mrn`)
    REFERENCES `clinic`.`patients` (`mrn`),
  CONSTRAINT `fk_lab_requests_npi`
    FOREIGN KEY (`npi`)
    REFERENCES `clinic`.`doctors` (`npi`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clinic`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinic`.`payments` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `lab_report_id` INT NOT NULL,
  `mrn` INT NOT NULL,
  `appointment_id` INT NOT NULL,
  PRIMARY KEY (`payment_id`),
  UNIQUE INDEX `payment_id_UNIQUE` (`payment_id` ASC) VISIBLE,
  INDEX `idx_appointments_appointment_id` (`appointment_id` ASC) INVISIBLE,
  INDEX `idx_lab_reports_lab_report_id` (`lab_report_id` ASC) VISIBLE,
  INDEX `idx_patients_mrn` (`mrn` ASC) VISIBLE,
  CONSTRAINT `fk_payments_appointment_id`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `clinic`.`appointments` (`appointment_id`),
  CONSTRAINT `fk_payments_lab_report_id`
    FOREIGN KEY (`lab_report_id`)
    REFERENCES `clinic`.`lab_reports` (`lab_report_id`),
  CONSTRAINT `fk_payments_mrn`
    FOREIGN KEY (`mrn`)
    REFERENCES `clinic`.`patients` (`mrn`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clinic`.`lab_reports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinic`.`lab_reports` (
  `lab_report_id` INT NOT NULL AUTO_INCREMENT,
  `lab_request_id` INT NOT NULL,
  `mrn` INT NOT NULL,
  `npi` INT NOT NULL,
  `payment_id` INT NULL DEFAULT NULL,
  `findings` VARCHAR(45) NOT NULL,
  `lab_test_datetime` DATETIME NOT NULL,
  `lab_fees` DOUBLE NOT NULL,
  `lab_results` VARCHAR(45) NULL DEFAULT NULL,
  `report_status` ENUM('pending', 'completed') NOT NULL,
  `payment_status` ENUM('unpaid', 'paid', 'refunded') NOT NULL,
  PRIMARY KEY (`lab_report_id`),
  UNIQUE INDEX `lab_report_id_UNIQUE` (`lab_report_id` ASC) VISIBLE,
  INDEX `idx_doctors_npi` (`npi` ASC) VISIBLE,
  INDEX `idx_patients_mrn` (`mrn` ASC) VISIBLE,
  INDEX `idx_lab_reports_lab_report_id` (`lab_report_id` ASC) INVISIBLE,
  INDEX `idx_payments_payment_id` (`payment_id` ASC) VISIBLE,
  INDEX `fk_lab_reports_lab_request_id` (`lab_request_id` ASC) VISIBLE,
  CONSTRAINT `fk_lab_reports_lab_request_id`
    FOREIGN KEY (`lab_request_id`)
    REFERENCES `clinic`.`lab_requests` (`lab_request_id`),
  CONSTRAINT `fk_lab_reports_mrn`
    FOREIGN KEY (`mrn`)
    REFERENCES `clinic`.`patients` (`mrn`),
  CONSTRAINT `fk_lab_reports_npi`
    FOREIGN KEY (`npi`)
    REFERENCES `clinic`.`doctors` (`npi`),
  CONSTRAINT `fk_lab_reports_payment_id`
    FOREIGN KEY (`payment_id`)
    REFERENCES `clinic`.`payments` (`payment_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clinic`.`appointments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinic`.`appointments` (
  `appointment_id` INT NOT NULL AUTO_INCREMENT,
  `mrn` INT NOT NULL,
  `npi` INT NOT NULL,
  `lab_report_id` INT NULL DEFAULT NULL,
  `purpose` VARCHAR(45) NULL DEFAULT NULL,
  `start_datetime` DATETIME NULL DEFAULT NULL,
  `end_datetime` DATETIME NULL DEFAULT NULL,
  `appointment_fees` DOUBLE NULL DEFAULT NULL,
  `payment_status` ENUM('unpaid', 'paid', 'refunded') NULL DEFAULT NULL,
  PRIMARY KEY (`appointment_id`),
  UNIQUE INDEX `idx_appointments_appointment_id` (`appointment_id` ASC) VISIBLE,
  INDEX `idx_doctors_npi` (`npi` ASC) VISIBLE,
  INDEX `idx_patients_mrn` (`mrn` ASC) VISIBLE,
  INDEX `idx_lab_reports_lab_report_id` (`lab_report_id` ASC) VISIBLE,
  CONSTRAINT `fk_appointments_lab_report_id`
    FOREIGN KEY (`lab_report_id`)
    REFERENCES `clinic`.`lab_reports` (`lab_report_id`),
  CONSTRAINT `fk_appointments_mrn`
    FOREIGN KEY (`mrn`)
    REFERENCES `clinic`.`patients` (`mrn`),
  CONSTRAINT `fk_appointments_npi`
    FOREIGN KEY (`npi`)
    REFERENCES `clinic`.`doctors` (`npi`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clinic`.`bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinic`.`bookings` (
  `booking` INT NOT NULL AUTO_INCREMENT,
  `appointment_id` INT NOT NULL,
  `mrn` INT NOT NULL,
  `npi` INT NOT NULL,
  `booking_date` DATE NOT NULL,
  `appointment_date` DATETIME NOT NULL,
  PRIMARY KEY (`booking`),
  UNIQUE INDEX `booking_UNIQUE` (`booking` ASC) VISIBLE,
  INDEX `idx_doctors_npi` (`npi` ASC) VISIBLE,
  INDEX `idx_patients_mrn` (`mrn` ASC) VISIBLE,
  INDEX `idx_appointments_appointment_id` (`appointment_id` ASC) VISIBLE,
  CONSTRAINT `fk_bookings_appointment_d`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `clinic`.`appointments` (`appointment_id`),
  CONSTRAINT `fk_bookings_mrn`
    FOREIGN KEY (`mrn`)
    REFERENCES `clinic`.`patients` (`mrn`),
  CONSTRAINT `fk_bookings_npi`
    FOREIGN KEY (`npi`)
    REFERENCES `clinic`.`doctors` (`npi`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clinic`.`diagnosis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinic`.`diagnosis` (
  `diagnosis_id` INT NOT NULL AUTO_INCREMENT,
  `appointment_id` INT NOT NULL,
  `diagnosis` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`diagnosis_id`),
  UNIQUE INDEX `diagnosis_id_UNIQUE` (`diagnosis_id` ASC) VISIBLE,
  INDEX `fk_diagnosis_lab_report_id_idx` (`appointment_id` ASC) VISIBLE,
  CONSTRAINT `fk_diagnosis_lab_report_id`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `clinic`.`appointments` (`appointment_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clinic`.`prescriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinic`.`prescriptions` (
  `prescription_id` INT NOT NULL AUTO_INCREMENT,
  `mrn` INT NOT NULL,
  `npi` INT NOT NULL,
  `medication_name` VARCHAR(45) NOT NULL,
  `dosage` DOUBLE NOT NULL,
  `frequency` VARCHAR(45) NOT NULL,
  `duration` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`prescription_id`),
  UNIQUE INDEX `prescription_id_UNIQUE` (`prescription_id` ASC) VISIBLE,
  INDEX `idx_doctors_npi` (`npi` ASC) INVISIBLE,
  INDEX `idx_patients_mrn` (`mrn` ASC) VISIBLE,
  CONSTRAINT `fk_prescriptions_mrn`
    FOREIGN KEY (`mrn`)
    REFERENCES `clinic`.`patients` (`mrn`),
  CONSTRAINT `fk_prescriptions_npi`
    FOREIGN KEY (`npi`)
    REFERENCES `clinic`.`doctors` (`npi`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clinic`.`treatment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinic`.`treatment` (
  `treament_id` INT NOT NULL AUTO_INCREMENT,
  `diagnosis_id` INT NOT NULL,
  `medication` VARCHAR(45) NOT NULL,
  `dosage` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`treament_id`),
  UNIQUE INDEX `treament_id_UNIQUE` (`treament_id` ASC) VISIBLE,
  INDEX `FKtreat_idx` (`diagnosis_id` ASC) VISIBLE,
  CONSTRAINT `FKtreat`
    FOREIGN KEY (`diagnosis_id`)
    REFERENCES `clinic`.`diagnosis` (`diagnosis_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
