-- Crownfield Eye Hospital
-- File: 06_security.sql
-- Run with an account that has permission to CREATE ROLE, CREATE USER and GRANT.
USE crownfield_eye_hospital;

CREATE ROLE IF NOT EXISTS
    'hospital_admin', 'doctor_role', 'receptionist_role', 'patient_role';

GRANT ALL PRIVILEGES ON crownfield_eye_hospital.* TO 'hospital_admin';

GRANT SELECT ON crownfield_eye_hospital.* TO 'doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.diagnosis TO 'doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.prescription TO 'doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.prescription_item TO 'doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.follow_up TO 'doctor_role';

GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.patient TO 'receptionist_role';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.appointment TO 'receptionist_role';
GRANT SELECT ON crownfield_eye_hospital.clinic TO 'receptionist_role';

-- The patient view filters rows using the database login name.
-- The example patient login below is patient_OP001, so it sees OP001 rows only.
CREATE OR REPLACE SQL SECURITY DEFINER VIEW patient_appointment_summary AS
SELECT a.patient_id, a.appointment_id, a.appointment_date,
       a.appointment_time, a.status, cl.clinic_name
FROM appointment a
JOIN clinic cl ON a.clinic_id = cl.clinic_id
WHERE a.patient_id = REPLACE(SUBSTRING_INDEX(USER(), '@', 1), 'patient_', '');

GRANT SELECT ON crownfield_eye_hospital.patient_appointment_summary TO 'patient_role';

-- Example accounts. Change these demonstration passwords immediately.
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'ChangeMe_Admin_2026!';
CREATE USER IF NOT EXISTS 'doctor_user'@'localhost' IDENTIFIED BY 'ChangeMe_Doctor_2026!';
CREATE USER IF NOT EXISTS 'reception_user'@'localhost' IDENTIFIED BY 'ChangeMe_Reception_2026!';
CREATE USER IF NOT EXISTS 'patient_OP001'@'localhost' IDENTIFIED BY 'ChangeMe_Patient_2026!';

GRANT 'hospital_admin' TO 'admin_user'@'localhost';
GRANT 'doctor_role' TO 'doctor_user'@'localhost';
GRANT 'receptionist_role' TO 'reception_user'@'localhost';
GRANT 'patient_role' TO 'patient_OP001'@'localhost';

SET DEFAULT ROLE ALL TO
    'admin_user'@'localhost',
    'doctor_user'@'localhost',
    'reception_user'@'localhost',
    'patient_OP001'@'localhost';

-- SHA-256 demonstration only. Do not use SHA2 for production password storage.
INSERT INTO app_user (username, password_hash, user_type)
VALUES ('doctor_demo', SHA2('ExamplePassword123!', 256), 'Doctor')
ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash);
