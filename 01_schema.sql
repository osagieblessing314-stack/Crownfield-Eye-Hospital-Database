-- Crownfield Eye Hospital
-- File: 01_schema.sql
-- Run first. Tested design target: MySQL 8.0+

CREATE DATABASE IF NOT EXISTS crownfield_eye_hospital;
USE crownfield_eye_hospital;

CREATE TABLE specialty (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE patient (
    patient_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    date_of_birth DATE,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clinician (
    clinician_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty_id INT NOT NULL,
    email VARCHAR(100) UNIQUE,
    CONSTRAINT fk_clinician_specialty
        FOREIGN KEY (specialty_id) REFERENCES specialty(specialty_id)
);

CREATE TABLE clinic (
    clinic_id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_name VARCHAR(80) NOT NULL UNIQUE,
    address VARCHAR(150)
);

CREATE TABLE appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    clinician_id INT NOT NULL,
    clinic_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    notes VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    CONSTRAINT chk_appointment_status
        CHECK (status IN ('Scheduled','Completed','Cancelled','Did Not Attend')),
    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    CONSTRAINT fk_appointment_clinician
        FOREIGN KEY (clinician_id) REFERENCES clinician(clinician_id),
    CONSTRAINT fk_appointment_clinic
        FOREIGN KEY (clinic_id) REFERENCES clinic(clinic_id)
);

CREATE TABLE diagnosis (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    diagnosis_name VARCHAR(100) NOT NULL,
    diagnosis_notes VARCHAR(255),
    CONSTRAINT fk_diagnosis_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
        ON DELETE CASCADE
);

CREATE TABLE medicine (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE prescription (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    prescription_date DATE NOT NULL,
    CONSTRAINT fk_prescription_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
        ON DELETE CASCADE
);

CREATE TABLE prescription_item (
    prescription_item_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    dose VARCHAR(50) NOT NULL,
    route VARCHAR(30) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration_days INT NOT NULL,
    CONSTRAINT chk_duration CHECK (duration_days > 0),
    CONSTRAINT uq_prescription_medicine UNIQUE (prescription_id, medicine_id),
    CONSTRAINT fk_item_prescription
        FOREIGN KEY (prescription_id) REFERENCES prescription(prescription_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_item_medicine
        FOREIGN KEY (medicine_id) REFERENCES medicine(medicine_id)
);

CREATE TABLE follow_up (
    follow_up_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    due_date DATE NOT NULL,
    priority VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    CONSTRAINT chk_followup_priority CHECK (priority IN ('Routine','High','Urgent')),
    CONSTRAINT chk_followup_status CHECK (status IN ('Pending','Booked','Completed','Cancelled')),
    CONSTRAINT fk_followup_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
        ON DELETE CASCADE
);

-- Authentication demonstration table. SHA2 is for coursework demonstration only.
CREATE TABLE app_user (
    app_user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash CHAR(64) NOT NULL,
    user_type VARCHAR(20) NOT NULL,
    CONSTRAINT chk_app_user_type CHECK
        (user_type IN ('Administrator','Doctor','Receptionist','Patient'))
);
