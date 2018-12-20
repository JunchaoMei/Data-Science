USE emr_team5_1022;

# Make Backups of 4 Original Tables
ALTER TABLE `emr_team5_1022`.`medications` 
	RENAME TO  `emr_team5_1022`.`medications_original` ;
ALTER TABLE `emr_team5_1022`.`medication_categories` 
	RENAME TO  `emr_team5_1022`.`medication_categories_original` ;
ALTER TABLE `emr_team5_1022`.`diagnoses` 
	RENAME TO  `emr_team5_1022`.`diagnoses_original` ;
ALTER TABLE `emr_team5_1022`.`symptoms` 
	RENAME TO  `emr_team5_1022`.`symptoms_original` ;

# Show 4 Original Tables
/*
SELECT * FROM medications_original;
SELECT * FROM medication_categories_original;
SELECT * FROM diagnoses_original;
SELECT * FROM symptoms_original;
*/

# Create Tables
CREATE TABLE `medication_categories` (
  `category_id` varchar(36) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM medication_categories;
	# Import medication_categories.csv

CREATE TABLE `diagnoses` (
  `diagnosis_id` varchar(36) NOT NULL,
  `diagnosis_name` varchar(255) NOT NULL,
  PRIMARY KEY (`diagnosis_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM diagnoses;
	# Import diagnoses.csv

CREATE TABLE `symptoms` (
  `symptom_id` varchar(36) NOT NULL,
  `symptom_name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`symptom_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM symptoms;
    # Import symptoms.csv

CREATE TABLE `medications` (
  `medication_id` varchar(36) NOT NULL,
  `medication_name` varchar(500) NOT NULL,
  `fk_category_id` varchar(36) NOT NULL,
  `min_dosage` int NOT NULL,
  PRIMARY KEY (`medication_id`),
  FOREIGN KEY (`fk_category_id`) REFERENCES `medication_categories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM medications;
    # Import medications.csv

CREATE TABLE `side_effects` (
  `side_effect_id` varchar(36) NOT NULL,
  `side_effect_name` varchar(500) NOT NULL,
  `side_effect_description` text,
  PRIMARY KEY (`side_effect_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM side_effects;
    # Import side_effects.csv

CREATE TABLE `med_side_effect` (
  `fk_side_effect_id` varchar(36) NOT NULL,
  `fk_medication_id` varchar(36) NOT NULL,
  FOREIGN KEY (`fk_side_effect_id`) REFERENCES `side_effects` (`side_effect_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_medication_id`) REFERENCES `medications` (`medication_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM med_side_effect;
    # Import med_side_effect.csv

CREATE TABLE `locations` (
  `location_id` varchar(36) NOT NULL,
  `state` varchar(10) NOT NULL,
  `city` varchar(20) NOT NULL,
  `street_address` varchar(30) NOT NULL,
  `zip` varchar(10) NOT NULL,
  PRIMARY KEY (`location_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM locations;
    # Import locations.csv

CREATE TABLE `pharmacies` (
  `pharmacy_id` varchar(36) NOT NULL,
  `fk_location_id` varchar(36) NOT NULL,
  PRIMARY KEY (`pharmacy_id`),
  FOREIGN KEY (`fk_location_id`) REFERENCES `locations` (`location_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM pharmacies;
INSERT INTO `emr_team5_1022`.`pharmacies` (`pharmacy_id`, `fk_location_id`) VALUES
  ('phar001', '101'),('phar002', '102'),('phar003', '103'),('phar004', '104'),('phar005', '105');

CREATE TABLE `medical_practices` (
  `medical_practice_id` varchar(36) NOT NULL,
  `medical_practice_name` varchar(100) NOT NULL,
  `medical_practice_type` varchar(50) NOT NULL,
  `mp_description` text,
  `fk_location_id` varchar(36) NOT NULL,
  PRIMARY KEY (`medical_practice_id`),
  FOREIGN KEY (`fk_location_id`) REFERENCES `locations` (`location_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM medical_practices;
	# Import medical_practices.csv

CREATE TABLE `users` (
  `user_id` varchar(36) NOT NULL,
  `user_type` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `age` int NOT NULL,
  `gender` varchar(10) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM users;
    # Import users.csv

CREATE TABLE `user_practice` (
  `fk_user_id` varchar(36) NOT NULL,
  `fk_medical_practice_id` varchar(36) NOT NULL,
  FOREIGN KEY (`fk_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_medical_practice_id`) REFERENCES `medical_practices` (`medical_practice_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM user_practice;
    # Import user_practice.csv

CREATE TABLE `tests` (
  `test_id` varchar(36) NOT NULL,
  `test_name` varchar(100) NOT NULL,
  `test_description` text,
  PRIMARY KEY (`test_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM tests;
    # Import tests.csv

CREATE TABLE `visits` (
  `visit_id` varchar(36) NOT NULL,
  `fk_patient_id` varchar(36) NOT NULL,
  `fk_physician_id` varchar(36) NOT NULL,
  `visit_date` date NOT NULL,
  `arrive_time` time NOT NULL,
  `leave_time` time NOT NULL,
  `comments` text,
  PRIMARY KEY (`visit_id`),
  FOREIGN KEY (`fk_patient_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_physician_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM visits;
    # Import visits.csv

CREATE TABLE `prescriptions` (
  `prescription_id` varchar(36) NOT NULL,
  `fk_visit_id` varchar(36) NOT NULL,
  `prescription_notes` text,
  PRIMARY KEY (`prescription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `prescriptions`
  ADD FOREIGN KEY (`fk_visit_id`) REFERENCES `visits` (`visit_id`) ON DELETE CASCADE ON UPDATE CASCADE;
	# SELECT * FROM prescriptions;
    # Import prescriptions.csv

CREATE TABLE `med_pharmacy` (
  `fk_medication_id` varchar(36) NOT NULL,
  `target_pharmacy_id` varchar(36) NOT NULL,
  FOREIGN KEY (`fk_medication_id`) REFERENCES `medications` (`medication_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`target_pharmacy_id`) REFERENCES `pharmacies` (`pharmacy_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM med_pharmacy;
    # Import med_pharmacy.csv

CREATE TABLE `pre_med` (
  `fk_medication_id` varchar(36) NOT NULL,
  `fk_prescription_id` varchar(36) NOT NULL,
  FOREIGN KEY (`fk_medication_id`) REFERENCES `medications` (`medication_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_prescription_id`) REFERENCES `prescriptions` (`prescription_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM pre_med;
    # Import pre_med.csv

CREATE TABLE `diag_sym` (
  `fk_diagnosis_id` varchar(36) NOT NULL,
  `fk_symptom_id` varchar(36) NOT NULL,
  FOREIGN KEY (`fk_diagnosis_id`) REFERENCES `diagnoses` (`diagnosis_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_symptom_id`) REFERENCES `symptoms` (`symptom_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM diag_sym;
    # Import diag_sym.csv

CREATE TABLE `visit_symptom` (
  `fk_visit_id` varchar(36) NOT NULL,
  `fk_symptom_id` varchar(36) NOT NULL,
  FOREIGN KEY (`fk_visit_id`) REFERENCES `visits` (`visit_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_symptom_id`) REFERENCES `symptoms` (`symptom_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM visit_symptom;
    # Import visit_symptom.csv

CREATE TABLE `visit_test` (
  `fk_visit_id` varchar(36) NOT NULL,
  `fk_test_id` varchar(36) NOT NULL,
  FOREIGN KEY (`fk_visit_id`) REFERENCES `visits` (`visit_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_test_id`) REFERENCES `tests` (`test_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	# SELECT * FROM visit_test;
    # Import visit_test

# Show all the tables created
SELECT * FROM `medication_categories`;
SELECT * FROM `diagnoses`;
SELECT * FROM `symptoms`;
SELECT * FROM `medications`;
SELECT * FROM `side_effects`;
SELECT * FROM `med_side_effect`;
SELECT * FROM `locations`;
SELECT * FROM `pharmacies`;
SELECT * FROM `medical_practices`;
SELECT * FROM `users`;
SELECT * FROM `user_practice`;
SELECT * FROM `tests`;
SELECT * FROM `visits`;
SELECT * FROM `prescriptions`;
SELECT * FROM `med_pharmacy`;
SELECT * FROM `pre_med`;
SELECT * FROM `diag_sym`;
SELECT * FROM `visit_symptom`;
SELECT * FROM `visit_test`;