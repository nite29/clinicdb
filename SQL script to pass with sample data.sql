-- MySQL Workbench Forward Engineering with Sample Data

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Drop and recreate the database
DROP SCHEMA IF EXISTS `clinic`;
CREATE SCHEMA IF NOT EXISTS `clinic` DEFAULT CHARACTER SET utf8mb3;
USE `clinic`;

-- Create patients table
CREATE TABLE `patients` (
  `mrn` INT NOT NULL AUTO_INCREMENT,
  `last_name` VARCHAR(45) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `middle_name` VARCHAR(45) NULL DEFAULT NULL,
  `sex` ENUM('M', 'F') NOT NULL,
  `birth_date` DATE NOT NULL,
  `contact_no` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`mrn`)
) ENGINE = InnoDB  DEFAULT CHARSET=utf8mb3;

-- Insert sample data into patients
INSERT INTO `patients` (`last_name`, `first_name`, `middle_name`, `sex`, `birth_date`, `contact_no`) VALUES
('Doe', 'John', 'A', 'M', '1990-05-15', '09171234567'),
('Smith', 'Jane', 'B', 'F', '1985-08-22', '09181234567');

-- Create doctors table
CREATE TABLE `doctors` (
  `npi` INT NOT NULL AUTO_INCREMENT,
  `last_name` VARCHAR(45) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `middle_name` VARCHAR(45) NULL DEFAULT NULL,
  `sex` ENUM('M', 'F') NOT NULL,
  `birth_date` DATE NOT NULL,
  `medical_certification` VARCHAR(45) NOT NULL,
  `years_of_service` INT NOT NULL,
  `specialization` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`npi`)
) ENGINE = InnoDB  DEFAULT CHARSET=utf8mb3;

-- Insert sample data into doctors
INSERT INTO `doctors` (`last_name`, `first_name`, `middle_name`, `sex`, `birth_date`, `medical_certification`, `years_of_service`, `specialization`) VALUES
('Brown', 'Alice', 'C', 'F', '1978-03-12', 'MD123456', 15, 'Cardiology'),
('Wilson', 'David', 'D', 'M', '1982-06-25', 'MD654321', 10, 'Dermatology');

-- Create appointments table
CREATE TABLE `appointments` (
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
  FOREIGN KEY (`mrn`) REFERENCES `patients` (`mrn`),
  FOREIGN KEY (`npi`) REFERENCES `doctors` (`npi`)
) ENGINE = InnoDB  DEFAULT CHARSET=utf8mb3;

-- Insert sample data into appointments
INSERT INTO `appointments` (`mrn`, `npi`, `purpose`, `start_datetime`, `end_datetime`, `appointment_fees`, `payment_status`) VALUES
(1, 1, 'Check-up', '2024-03-15 10:00:00', '2024-03-15 10:30:00', 500.00, 'paid'),
(2, 2, 'Skin Treatment', '2024-03-16 14:00:00', '2024-03-16 14:45:00', 700.00, 'unpaid');

-- Create lab_requests table
CREATE TABLE `lab_requests` (
  `lab_request_id` INT NOT NULL AUTO_INCREMENT,
  `npi` INT NOT NULL,
  `mrn` INT NOT NULL,
  `reason` VARCHAR(45) NOT NULL,
  `request_date` DATE NOT NULL,
  PRIMARY KEY (`lab_request_id`),
  FOREIGN KEY (`mrn`) REFERENCES `patients` (`mrn`),
  FOREIGN KEY (`npi`) REFERENCES `doctors` (`npi`)
) ENGINE = InnoDB  DEFAULT CHARSET=utf8mb3;

-- Insert sample data into lab_requests
INSERT INTO `lab_requests` (`npi`, `mrn`, `reason`, `request_date`) VALUES
(1, 1, 'Blood Test', '2024-03-14'),
(2, 2, 'Allergy Test', '2024-03-15');

-- Create lab_reports table
CREATE TABLE `lab_reports` (
  `lab_report_id` INT NOT NULL AUTO_INCREMENT,
  `lab_request_id` INT NOT NULL,
  `mrn` INT NOT NULL,
  `npi` INT NOT NULL,
  `findings` VARCHAR(45) NOT NULL,
  `lab_test_datetime` DATETIME NOT NULL,
  `lab_fees` DOUBLE NOT NULL,
  `lab_results` VARCHAR(45) NULL DEFAULT NULL,
  `report_status` ENUM('pending', 'completed') NOT NULL,
  `payment_status` ENUM('unpaid', 'paid', 'refunded') NOT NULL,
  PRIMARY KEY (`lab_report_id`),
  FOREIGN KEY (`lab_request_id`) REFERENCES `lab_requests` (`lab_request_id`),
  FOREIGN KEY (`mrn`) REFERENCES `patients` (`mrn`),
  FOREIGN KEY (`npi`) REFERENCES `doctors` (`npi`)
) ENGINE = InnoDB  DEFAULT CHARSET=utf8mb3;

-- Insert sample data into lab_reports
INSERT INTO `lab_reports` (`lab_request_id`, `mrn`, `npi`, `findings`, `lab_test_datetime`, `lab_fees`, `lab_results`, `report_status`, `payment_status`) VALUES
(1, 1, 1, 'Normal', '2024-03-14 11:00:00', 200.00, 'OK', 'completed', 'paid'),
(2, 2, 2, 'Mild Allergy', '2024-03-15 15:00:00', 300.00, 'Advised Treatment', 'completed', 'unpaid');

-- Create payments table
CREATE TABLE `payments` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `lab_report_id` INT NOT NULL,
  `mrn` INT NOT NULL,
  `appointment_id` INT NOT NULL,
  PRIMARY KEY (`payment_id`),
  FOREIGN KEY (`lab_report_id`) REFERENCES `lab_reports` (`lab_report_id`),
  FOREIGN KEY (`mrn`) REFERENCES `patients` (`mrn`),
  FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`)
) ENGINE = InnoDB  DEFAULT CHARSET=utf8mb3;

-- Insert sample data into payments
INSERT INTO `payments` (`lab_report_id`, `mrn`, `appointment_id`) VALUES
(1, 1, 1),
(2, 2, 2);

-- Create diagnosis table
CREATE TABLE `diagnosis` (
  `diagnosis_id` INT NOT NULL AUTO_INCREMENT,
  `appointment_id` INT NOT NULL,
  `diagnosis` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`diagnosis_id`),
  FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`)
) ENGINE = InnoDB  DEFAULT CHARSET=utf8mb3;

-- Insert sample data into diagnosis
INSERT INTO `diagnosis` (`appointment_id`, `diagnosis`) VALUES
(1, 'Flu'),
(2, 'Skin Rash');

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
DEFAULT CHARACTER SET = utf8mb3;

-- Insert sample treatments
INSERT INTO clinic.treatment (diagnosis_id, medication, dosage) VALUES
(1, 'Amlodipine', '5mg daily'),
(2, 'Ibuprofen', '400mg every 8 hours');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
