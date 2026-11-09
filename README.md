# Crownfield Eye Hospital Database

## Project overview
This individual repository contains the SQL implementation and Entity Relationship Diagram (ERD) for the Crownfield Eye Hospital database. The database has ten main relational tables: Patient, Clinician, Specialty, Clinic, Appointment, Diagnosis, Prescription, Medicine, Prescription_Item and Follow_Up.

## Requirements
- MySQL Server 8.0 or later.
- MySQL Workbench or another MySQL client.
- A MySQL account with permission to create databases, tables, stored procedures, triggers, roles and users. The security script requires additional administrative privileges.

## Repository structure and execution order
Run the SQL files in the following order:

1. `01_schema.sql` - creates the `crownfield_eye_hospital` database, its ten main tables, keys, constraints and the demonstration `app_user` table.
2. `02_individual_queries.sql` - inserts the sample data, runs the four SELECT query examples (GROUP BY/HAVING, INNER JOIN, LEFT JOIN and subquery), and demonstrates COMMIT and ROLLBACK. Run the sample INSERT statements only once unless the existing sample records have been removed.
3. `03_procedure_and_trigger.sql` - creates the `get_patient_appointments` stored procedure and the `trg_validate_followup_date` trigger. It also includes the procedure test call.
4. `04_security.sql` - creates the four database roles, grants permissions, creates example users and demonstrates password hashing. Run this file using an account with the required administrative privileges.
5. `05_ERD/Crownfield_Eye_Hospital_ERD.png` - visual database design showing entities, attributes, primary keys, foreign keys and relationships. This is an image, not an SQL script, so it does not need to be executed.

## Setup steps in MySQL Workbench
1. Install and start MySQL Server 8.0 or later.
2. Open MySQL Workbench and connect to your MySQL server.
3. Open `01_schema.sql` and execute the complete script.
4. Open and execute `02_individual_queries.sql`. Check the result grids for the query outputs.
5. Open and execute `03_procedure_and_trigger.sql`. Test the procedure using the included `CALL` statement.
6. Open and execute `04_security.sql` with an account that can create roles and users and grant privileges.
7. Review the ERD image in the `05_ERD` folder.

## Individual SQL features
- GROUP BY and HAVING: identifies clinicians with at least two appointments.
- INNER JOIN: displays appointment information with patient, clinician and clinic details.
- LEFT JOIN: identifies appointments without a recorded diagnosis.
- Subquery: identifies clinicians whose appointment totals are above the average.
- Stored procedure: retrieves appointments for a supplied patient ID.
- Trigger: rejects a follow-up due date earlier than its appointment date.
- Transactions: demonstrates ROLLBACK and COMMIT.

## Assumptions and limitations
- A clinician has one primary specialty in this design.
- A patient can have many appointments; each appointment belongs to one patient.
- An appointment can have zero or many diagnoses and zero or many prescriptions.
- Prescription and Medicine have a many-to-many relationship implemented through Prescription_Item.
- Each appointment can have at most one follow-up because `follow_up.appointment_id` is UNIQUE.
- The sample patient login is named `patient_OP001`; the patient appointment view uses this username pattern to filter records. Other patient accounts must follow the same naming pattern and be granted the patient role.
- Example account passwords in `04_security.sql` are coursework placeholders and must be changed before any real use.
- SHA2 is included only as a coursework demonstration. A production system should use a password-hashing algorithm designed for passwords, such as Argon2id or bcrypt.
- This is an academic demonstration database, not a production hospital system.
- The SQL scripts target MySQL 8.0 or later. Review the Action Output panel in MySQL Workbench after each execution and resolve any errors before proceeding.

## Evidence for assessment
Useful screenshots include successful table creation, sample data, the output of each SQL query, the stored procedure result, trigger validation, transaction tests, role grants and the ERD.
