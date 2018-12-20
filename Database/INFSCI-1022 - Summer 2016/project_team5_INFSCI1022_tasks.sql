USE emr_team5_1022;

# Task a
SELECT diagnosis_name AS `disease`, COUNT(DISTINCT v.fk_patient_id) AS `number of patients`
FROM visits v
JOIN visit_symptom v_sym ON v.visit_id = v_sym.fk_visit_id
JOIN symptoms sym ON v_sym.fk_symptom_id = sym.symptom_id
JOIN diag_sym ON sym.symptom_id = diag_sym.fk_symptom_id
JOIN diagnoses diag ON diag_sym.fk_diagnosis_id = diag.diagnosis_id
WHERE v.visit_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY diagnosis_id
ORDER BY `disease`;

# Task b
SELECT COUNT(DISTINCT u.user_id) AS `patients NOT diagnosed in last 6 months`
FROM users u
WHERE u.user_type = 'patient' AND u.user_id NOT IN
(
SELECT DISTINCT v.fk_patient_id
FROM visits v
JOIN visit_symptom v_sym ON v.visit_id = v_sym.fk_visit_id
JOIN symptoms sym ON v_sym.fk_symptom_id = sym.symptom_id
JOIN diag_sym ON sym.symptom_id = diag_sym.fk_symptom_id
JOIN diagnoses diag ON diag_sym.fk_diagnosis_id = diag.diagnosis_id
WHERE v.visit_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
);

# Task c
SELECT AVG((TIME_TO_SEC(v.leave_time) - TIME_TO_SEC(v.arrive_time))/60) AS `average duration (minutes)`,
	   MAX((TIME_TO_SEC(v.leave_time) - TIME_TO_SEC(v.arrive_time))/60) AS `maximum duration (minutes)`,
       MIN((TIME_TO_SEC(v.leave_time) - TIME_TO_SEC(v.arrive_time))/60) AS `minimum duration (minutes)`
FROM visits v;

# Task d
SELECT m.medication_name, COUNT(DISTINCT pre_med.fk_prescription_id) AS `number of being prescribed`
FROM medications m, pre_med
WHERE m.medication_id = pre_med.fk_medication_id
GROUP BY pre_med.fk_medication_id
ORDER BY `number of being prescribed` DESC
LIMIT 5;

# Task e
SELECT sym.symptom_name, COUNT(DISTINCT v_sym.fk_visit_id) AS `number of visits`
FROM symptoms sym, visit_symptom v_sym
WHERE sym.symptom_id = v_sym.fk_symptom_id
GROUP BY v_sym.fk_symptom_id
ORDER BY `number of visits` DESC, sym.symptom_name ASC
LIMIT 10;

# Task f
SELECT v.fk_physician_id AS `doctor_id`, CONCAT(u.first_name,' ',u.last_name) AS `patient`,
       sym.symptom_name AS `complaint`, COUNT(v_sym.fk_visit_id) AS `visit times`
FROM users u
JOIN visits v ON u.user_id = v.fk_patient_id
JOIN visit_symptom v_sym ON v.visit_id = v_sym.fk_visit_id
JOIN symptoms sym ON v_sym.fk_symptom_id = sym.symptom_id
WHERE v.fk_physician_id='u1044'
GROUP BY v.fk_physician_id, v.fk_patient_id, v_sym.fk_symptom_id
HAVING `visit times`>1
ORDER BY `visit times` DESC;

# Task g
SELECT v.fk_physician_id AS `doctor_id`, CONCAT(u.first_name,' ',u.last_name) AS `doctor_name`,
	   COUNT(DISTINCT fk_patient_id) AS `number of dead patients`
FROM users u
JOIN visits v ON u.user_id = v.fk_patient_id
JOIN visit_symptom v_sym ON v.visit_id = v_sym.fk_visit_id
JOIN symptoms sym ON v_sym.fk_symptom_id = sym.symptom_id
JOIN diag_sym ON sym.symptom_id = diag_sym.fk_symptom_id
JOIN diagnoses diag ON diag_sym.fk_diagnosis_id = diag.diagnosis_id
WHERE UCASE(diag.diagnosis_name) LIKE '%DEATH%' AND YEAR(v.visit_date) = (YEAR(NOW()) - 1)
GROUP BY v.fk_physician_id
HAVING `number of dead patients`>=1
ORDER BY `number of dead patients` DESC;