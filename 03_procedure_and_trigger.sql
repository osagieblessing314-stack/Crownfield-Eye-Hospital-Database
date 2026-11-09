-- Crownfield Eye Hospital
-- File: 04_procedure_and_trigger.sql
USE crownfield_eye_hospital;

DROP PROCEDURE IF EXISTS get_patient_appointments;
DELIMITER $$
CREATE PROCEDURE get_patient_appointments(IN p_patient_id VARCHAR(10))
BEGIN
    SELECT a.appointment_id, a.appointment_date, a.appointment_time,
           CONCAT(c.first_name,' ',c.last_name) AS clinician_name,
           cl.clinic_name, a.status
    FROM appointment a
    JOIN clinician c ON a.clinician_id = c.clinician_id
    JOIN clinic cl ON a.clinic_id = cl.clinic_id
    WHERE a.patient_id = p_patient_id
    ORDER BY a.appointment_date;
END $$
DELIMITER ;

-- Example test, expected to return two appointments for OP001.
CALL get_patient_appointments('OP001');

DROP TRIGGER IF EXISTS trg_validate_followup_date;
DELIMITER $$
CREATE TRIGGER trg_validate_followup_date
BEFORE INSERT ON follow_up
FOR EACH ROW
BEGIN
    DECLARE v_appointment_date DATE;
    SELECT appointment_date INTO v_appointment_date
    FROM appointment
    WHERE appointment_id = NEW.appointment_id;

    IF NEW.due_date < v_appointment_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Follow-up date cannot be before appointment date';
    END IF;
END $$
DELIMITER ;

-- Optional negative test:
-- Run separately after creating the trigger. It should fail with the trigger message.
-- INSERT INTO follow_up (appointment_id,due_date,priority,status)
-- VALUES (3,'2020-01-01','Routine','Pending');
