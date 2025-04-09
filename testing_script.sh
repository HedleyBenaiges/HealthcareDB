#!/bin/bash

# =========== Truncating all Tables ========-
echo
echo "Wiping All Tables"; sleep 1
echo 'TRUNCATE public."Patients", public."Staff", public."Doctors", public."Appointments", public."Medical Records" CASCADE;'
psql -U postgres -d HealthcareDB -c 'TRUNCATE public."Patients", public."Staff", public."Doctors", public."Appointments", public."Medical Records" CASCADE;' > /dev/null
sleep 1

echo
echo "Resetting All Primary Key Sequences"; sleep 1
echo 'ALTER SEQUENCE "Appointments_Appointment_ID_seq" RESTART WITH 1;'
echo 'ALTER SEQUENCE "Medical Records_Record_ID_seq" RESTART WITH 1;'
echo 'ALTER SEQUENCE "Patients_Patient_ID_seq" RESTART WITH 1;'
echo 'ALTER SEQUENCE "Staff_Staff_ID_seq" RESTART WITH 1;'; sleep 1
psql -U postgres -d HealthcareDB -c 'ALTER SEQUENCE "Appointments_Appointment_ID_seq" RESTART WITH 1;' > /dev/null
psql -U postgres -d HealthcareDB -c 'ALTER SEQUENCE "Medical Records_Record_ID_seq" RESTART WITH 1;' > /dev/null
psql -U postgres -d HealthcareDB -c 'ALTER SEQUENCE "Patients_Patient_ID_seq" RESTART WITH 1;' > /dev/null
psql -U postgres -d HealthcareDB -c 'ALTER SEQUENCE "Staff_Staff_ID_seq" RESTART WITH 1;' > /dev/null

# =========== Patients =============

# ----------- Inserting Patients -------------
echo
echo "Inserting Patients"; sleep 1
echo "SELECT \"registerPatient\"('Henry', 'Mayo', '1999-08-10', 'Male', 'Patient1@email.com', '0555 555 5555', '0555 555 5556', 'Patient1')"
echo "SELECT \"registerPatient\"('Jeane', 'Barber', '2002-03-03', 'Female', 'Patient2@email.com', '0777 777 7777', '0777 777 7778', 'Patient2')"
echo "SELECT \"registerPatient\"('Toby', 'Hall', '1983-02-07', 'Male', 'Patient3@email.com', '0111 111 1111', '0111 111 1112', 'Patient3')"
psql -U postgres -d HealthcareDB -c "SELECT \"registerPatient\"('Henry', 'Mayo', '1999-08-10', 'Male', 'Patient1@email.com', '0555 555 5555', '0555 555 5556', 'Patient1')" > /dev/null
psql -U postgres -d HealthcareDB -c "SELECT \"registerPatient\"('Jeane', 'Barber', '2002-03-03', 'Female', 'Patient2@email.com', '0777 777 7777', '0777 777 7778', 'Patient2')" > /dev/null
psql -U postgres -d HealthcareDB -c "SELECT \"registerPatient\"('Toby', 'Hall', '1983-02-07', 'Male', 'Patient3@email.com', '0111 111 1111', '0111 111 1112', 'Patient3')" > /dev/null
sleep 1

# ----------- Selecting Patient Tables -------------
echo
echo "Patient Table"; sleep 1
echo 'SELECT * FROM "Patients" ORDER BY "Patient_ID" ASC'; sleep 1
psql -U postgres -d HealthcareDB -c 'SELECT * FROM "Patients" ORDER BY "Patient_ID" ASC' | cat ; sleep 1

# =========== Staff =============

# ----------- Inserting Staff -------------
echo
echo "Inserting Staff"; sleep 1
echo "SELECT public.\"registerStaff\"('Warren', 'Wilder', 'Emergency Response', 'Staff1')"
psql -U postgres -d HealthcareDB -c "SELECT public.\"registerStaff\"('Warren', 'Wilder', 'Emergency Response', 'Staff1')" > /dev/null
sleep 1


# ----------- Inserting Doctors -------------
echo
echo "Inserting Doctors"; sleep 1
echo "SELECT public.\"registerDoctor\"('Max', 'Harm', 'Cardiology', 'Doctor1', 'Cardiothoracic Surgery')"
echo "SELECT public.\"registerDoctor\"('Vera', 'Chase', 'Orthopedics', 'Doctor2', 'Orthopedic Surgery')"
psql -U postgres -d HealthcareDB -c "SELECT public.\"registerDoctor\"('Max', 'Harm', 'Cardiology', 'Doctor1', 'Cardiothoracic Surgery')" > /dev/null
psql -U postgres -d HealthcareDB -c "SELECT public.\"registerDoctor\"('Vera', 'Chase', 'Orthopedics', 'Doctor2', 'Orthopedic Surgery')" > /dev/null
sleep 1

# ----------- Selecting Staff -------------
echo
echo "Staff Table (LEFT JOIN Doctors)"
echo 'SELECT * from public."Staff" LEFT JOIN public."Doctors" ON public."Staff"."Staff_ID" = public."Doctors"."Staff_ID" ORDER BY public."Staff"."Staff_ID" ASC'; sleep 1
psql -U postgres -d HealthcareDB -c 'SELECT * from public."Staff" LEFT JOIN public."Doctors" ON public."Staff"."Staff_ID" = public."Doctors"."Staff_ID" ORDER BY public."Staff"."Staff_ID" ASC' | cat; sleep 1

# =========== Appointments =============

# ----------- Requesting Appointments -------------
echo
echo "Inserting Appointments"; sleep 1
echo "SELECT public.\"requestAppointment\"('Patient1', '2025-02-19 10:00:00', 'Need to sneeze but cant')"
echo "SELECT public.\"requestAppointment\"('Patient2', '2025-02-19 11:15:00', 'Heart palpatations')"
echo "SELECT public.\"requestAppointment\"('Patient3', '2025-02-19 11:30:00', 'Sounds like Rowley Birkin')"
echo "SELECT public.\"requestAppointment\"('Patient2', '2025-02-20 12:00:00', 'Sensitive to sound')"

psql -U postgres -d HealthcareDB -c "SELECT public.\"requestAppointment\"('Patient1', '2025-02-19 10:00:00', 'Need to sneeze but cant')" > /dev/null
psql -U postgres -d HealthcareDB -c "SELECT public.\"requestAppointment\"('Patient2', '2025-02-19 11:15:00', 'Heart palpatations')" > /dev/null
psql -U postgres -d HealthcareDB -c "SELECT public.\"requestAppointment\"('Patient3', '2025-02-19 11:30:00', 'Sounds like Rowley Birkin')" > /dev/null
psql -U postgres -d HealthcareDB -c "SELECT public.\"requestAppointment\"('Patient2', '2025-02-20 12:00:00', 'Sensitive to sound')" > /dev/null
sleep 1

# ----------- Approve Appointments -------------
echo
echo "Approving Appointments and Assigning Doctors"; sleep 1
echo 'SELECT public."approveAppointment"(2, 1)'
echo 'SELECT public."approveAppointment"(4, 2)'
psql -U postgres -d HealthcareDB -c 'SELECT public."approveAppointment"(2, 1)' > /dev/null
psql -U postgres -d HealthcareDB -c 'SELECT public."approveAppointment"(4, 2)' > /dev/null
sleep 1

# ----------- Cancelling Appointments -------------
echo
echo "Cancelling Appointment 1"; sleep 1
echo 'SELECT public."cancelAppointment"(1)'
psql -U postgres -d HealthcareDB -c 'SELECT public."cancelAppointment"(1)' > /dev/null
sleep 1

# ----------- Selecting Appointments -------------
echo
echo "Selecting all Appointments"
echo 'SELECT * from public."Appointments" ORDER BY "Appointment_ID" ASC'; sleep 1
psql -U postgres -d HealthcareDB -c 'SELECT * from public."Appointments" ORDER BY "Appointment_ID" ASC' | cat; sleep 1

# ========== Medical Records =============

# ---------- Creating Medical Records -------------
echo
echo "Creating Medical Records"
echo "SELECT public.\"createMedicalRecord\"(2, 2, 'Heart Problems', 'Eat less cheese', 'Cheese')"; sleep 1
psql -U postgres -d HealthcareDB -c "SELECT public.\"createMedicalRecord\"(2, 2, 'Heart Problems', 'Eat less cheese', 'Cheese')" > /dev/null
sleep 1

# ---------- Selecting Medical Record -------------
echo
echo "Selecting Medical Record"
echo 'SELECT * from public."Medical Records" ORDER BY "Record_ID" ASC'; sleep 1
psql -U postgres -d HealthcareDB -c 'SELECT * FROM public."Medical Records" ORDER BY "Record_ID" ASC' | cat; sleep 1
#
# ----------- Selecting Appointments -------------
echo
echo "This will have marked the appointment as completed"; sleep 1
echo "Selecting all Appointments"
echo 'SELECT * from public."Appointments" ORDER BY "Appointment_ID" ASC'; sleep 1
psql -U postgres -d HealthcareDB -c 'SELECT * from public."Appointments" ORDER BY "Appointment_ID" ASC' | cat; sleep 1

# =========== Views ========-
echo
echo 'Example of Views'; sleep 1
echo
echo 'Logging in as "Doctor1"'; sleep 1
echo "Selecting all from patients (no access)"; sleep 1
echo 'SET ROLE "Doctor1"; SELECT * FROM "Patients" ORDER BY "Patient_ID" ASC'; sleep 1
psql -U postgres -d HealthcareDB -c 'set role "Doctor1"; SELECT * FROM "Patients" ORDER BY "Patient_ID" ASC' | cat ; sleep 1
echo 
echo "Selecting users from doctorViewPatient"; sleep 1
echo 'SET ROLE "Doctor1"; SELECT * FROM "doctorViewPatient" ORDER BY "Patient_ID" ASC'; sleep 1
psql -U postgres -d HealthcareDB -c 'SET ROLE "Doctor1"; SELECT * FROM "doctorViewPatient"' | cat ; sleep 1



# =========== Row Level Security ========-

echo
echo 'Example of Row Level Security'; sleep 1
echo
echo "Full Patient Table"; sleep 1
echo 'SELECT * FROM "Patients" ORDER BY "Patient_ID" ASC'; sleep 1
psql -U postgres -d HealthcareDB -c 'SELECT * FROM "Patients" ORDER BY "Patient_ID" ASC' | cat ; sleep 1


echo 'Logging in as "Patient2"'; sleep 1
echo 'Select all from patients (as "Patient2")'; sleep 1
echo 'SET ROLE "Patient2"; SELECT * FROM "Patients"'; sleep 1
psql -U postgres -d HealthcareDB -c 'set role "Patient2"; SELECT * FROM "Patients"' | cat ; sleep 1

