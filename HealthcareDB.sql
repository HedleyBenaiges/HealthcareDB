--
-- PostgreSQL database dump
--

-- Dumped from database version 15.10 (Debian 15.10-0+deb12u1)
-- Dumped by pg_dump version 15.10 (Debian 15.10-0+deb12u1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: approveAppointment(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."approveAppointment"("_Appointment_ID" integer, "_Doctor_ID" integer) RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN
	UPDATE public."Appointments"
	SET "Doctor_ID" = "_Doctor_ID", "Status" = 'Approved'
	WHERE "Appointment_ID" = "_Appointment_ID";
END;$$;


ALTER FUNCTION public."approveAppointment"("_Appointment_ID" integer, "_Doctor_ID" integer) OWNER TO postgres;

--
-- Name: cancelAppointment(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."cancelAppointment"("_Appointment_ID" integer) RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN
	UPDATE public."Appointments"
	SET "Status" = 'Cancelled'
	WHERE "Appointment_ID" = "_Appointment_ID";
END;$$;


ALTER FUNCTION public."cancelAppointment"("_Appointment_ID" integer) OWNER TO postgres;

--
-- Name: createMedicalRecord(integer, integer, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."createMedicalRecord"("_Patient_ID" integer, "_Appointment_ID" integer, "_Diagnosis" text, "_Prescription" text, "_Allergies" text) RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO public."Medical Records" 
		("Patient_ID", "Appointment_ID", "Diagnosis", "Prescription", "Allergies")
		VALUES ("_Patient_ID", "_Appointment_ID", "_Diagnosis", "_Prescription", "_Allergies");
	UPDATE public."Appointments"
		SET "Status" = 'Completed'
		WHERE public."Appointments"."Appointment_ID" = "_Appointment_ID";
END;$$;


ALTER FUNCTION public."createMedicalRecord"("_Patient_ID" integer, "_Appointment_ID" integer, "_Diagnosis" text, "_Prescription" text, "_Allergies" text) OWNER TO postgres;

--
-- Name: registerDoctor(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."registerDoctor"("_First_Name" character varying, "_Last_Name" character varying, "_Department" character varying, "_Username" character varying, "_Specialty" character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE
	staff_id INTEGER;
BEGIN
	INSERT INTO public."Staff" ("First_Name", "Last_Name", "Job_Title", "Department", "Username")
	VALUES ("_First_Name", "_Last_Name", 'Doctor', "_Department", "_Username");
	SELECT "Staff_ID" INTO staff_id FROM public."Staff" WHERE "Username" = "_Username"; 
	INSERT INTO public."Doctors" VALUES (staff_id, "_Specialty");
END;$$;


ALTER FUNCTION public."registerDoctor"("_First_Name" character varying, "_Last_Name" character varying, "_Department" character varying, "_Username" character varying, "_Specialty" character varying) OWNER TO postgres;

--
-- Name: registerPatient(character varying, character varying, date, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."registerPatient"("_First_Name" character varying, "_Last_Name" character varying, "_DoB" date, "_Gender" character varying, "_Email" character varying, "_Phone" character varying, "_Emergency_Phone" character varying, "_Username" character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO public."Patients" ("First_Name", "Last_Name", "Date_of_Birth", "Gender", "Email", "Phone", "Emergency_Phone", "Username")
	VALUES ("_First_Name","_Last_Name","_DoB","_Gender","_Email","_Phone","_Emergency_Phone","_Username");
END$$;


ALTER FUNCTION public."registerPatient"("_First_Name" character varying, "_Last_Name" character varying, "_DoB" date, "_Gender" character varying, "_Email" character varying, "_Phone" character varying, "_Emergency_Phone" character varying, "_Username" character varying) OWNER TO postgres;

--
-- Name: registerStaff(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."registerStaff"("_First_Name" character varying, "_Last_Name" character varying, "_Department" character varying, "_Username" character varying DEFAULT NULL::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO public."Staff" ("First_Name", "Last_Name", "Job_Title", "Department", "Username")
	VALUES ("_First_Name", "_Last_Name", 'Staff', "_Department", "_Username");
END;$$;


ALTER FUNCTION public."registerStaff"("_First_Name" character varying, "_Last_Name" character varying, "_Department" character varying, "_Username" character varying) OWNER TO postgres;

--
-- Name: requestAppointment(character varying, timestamp without time zone, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."requestAppointment"("_Username" character varying, "_TimeStamp" timestamp without time zone, "_Reason" text) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE
	patient_id INTEGER;
BEGIN
	SELECT "Patient_ID" INTO patient_id FROM public."Patients" WHERE "Username" = "_Username";
	INSERT INTO public."Appointments" ("Patient_ID", "Date_Time", "Reason_For_Visit", "Status")
	VALUES (patient_id, "_TimeStamp", "_Reason", 'Pending');
END;$$;


ALTER FUNCTION public."requestAppointment"("_Username" character varying, "_TimeStamp" timestamp without time zone, "_Reason" text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Appointments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Appointments" (
    "Appointment_ID" integer NOT NULL,
    "Patient_ID" integer NOT NULL,
    "Doctor_ID" integer,
    "Date_Time" timestamp without time zone,
    "Reason_For_Visit" text,
    "Status" character varying DEFAULT 'Pending'::character varying
);


ALTER TABLE public."Appointments" OWNER TO postgres;

--
-- Name: Appointments_Appointment_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Appointments_Appointment_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Appointments_Appointment_ID_seq" OWNER TO postgres;

--
-- Name: Appointments_Appointment_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Appointments_Appointment_ID_seq" OWNED BY public."Appointments"."Appointment_ID";


--
-- Name: Doctors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Doctors" (
    "Staff_ID" integer NOT NULL,
    "Specialty" character varying(30)
);


ALTER TABLE public."Doctors" OWNER TO postgres;

--
-- Name: Medical Records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Medical Records" (
    "Record_ID" integer NOT NULL,
    "Patient_ID" integer NOT NULL,
    "Diagnosis" text,
    "Prescription" text,
    "Allergies" text,
    "Appointment_ID" integer
);


ALTER TABLE public."Medical Records" OWNER TO postgres;

--
-- Name: Medical Records_Record_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Medical Records_Record_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Medical Records_Record_ID_seq" OWNER TO postgres;

--
-- Name: Medical Records_Record_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Medical Records_Record_ID_seq" OWNED BY public."Medical Records"."Record_ID";


--
-- Name: Patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Patients" (
    "Patient_ID" integer NOT NULL,
    "First_Name" character varying(20) NOT NULL,
    "Last_Name" character varying(20) NOT NULL,
    "Date_of_Birth" date NOT NULL,
    "Gender" character varying(15),
    "Email" character varying(20) NOT NULL,
    "Phone" character varying(20),
    "Emergency_Phone" character varying(20),
    "Username" character varying(20)
);


ALTER TABLE public."Patients" OWNER TO postgres;

--
-- Name: Patients_Patient_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Patients_Patient_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Patients_Patient_ID_seq" OWNER TO postgres;

--
-- Name: Patients_Patient_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Patients_Patient_ID_seq" OWNED BY public."Patients"."Patient_ID";


--
-- Name: Staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Staff" (
    "Staff_ID" integer NOT NULL,
    "First_Name" character varying(15),
    "Last_Name" character varying(15),
    "Job_Title" character varying(20),
    "Department" character varying(20),
    "Username" character varying(20) NOT NULL
);


ALTER TABLE public."Staff" OWNER TO postgres;

--
-- Name: Staff_Staff_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Staff_Staff_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Staff_Staff_ID_seq" OWNER TO postgres;

--
-- Name: Staff_Staff_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Staff_Staff_ID_seq" OWNED BY public."Staff"."Staff_ID";


--
-- Name: doctorViewPatient; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."doctorViewPatient" AS
 SELECT "Patients"."Patient_ID",
    "Patients"."First_Name",
    "Patients"."Last_Name",
    "Patients"."Date_of_Birth",
    "Patients"."Gender"
   FROM public."Patients";


ALTER TABLE public."doctorViewPatient" OWNER TO postgres;

--
-- Name: Appointments Appointment_ID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Appointments" ALTER COLUMN "Appointment_ID" SET DEFAULT nextval('public."Appointments_Appointment_ID_seq"'::regclass);


--
-- Name: Medical Records Record_ID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Medical Records" ALTER COLUMN "Record_ID" SET DEFAULT nextval('public."Medical Records_Record_ID_seq"'::regclass);


--
-- Name: Patients Patient_ID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Patients" ALTER COLUMN "Patient_ID" SET DEFAULT nextval('public."Patients_Patient_ID_seq"'::regclass);


--
-- Name: Staff Staff_ID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Staff" ALTER COLUMN "Staff_ID" SET DEFAULT nextval('public."Staff_Staff_ID_seq"'::regclass);


--
-- Data for Name: Appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Appointments" ("Appointment_ID", "Patient_ID", "Doctor_ID", "Date_Time", "Reason_For_Visit", "Status") FROM stdin;
3	3	\N	2025-02-19 11:30:00	Sounds like Rowley Birkin	Pending
4	2	2	2025-02-20 12:00:00	Sensitive to sound	Approved
1	1	\N	2025-02-19 10:00:00	Need to sneeze but cant	Cancelled
2	2	1	2025-02-19 11:15:00	Heart palpatations	Completed
\.


--
-- Data for Name: Doctors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Doctors" ("Staff_ID", "Specialty") FROM stdin;
2	Cardiothoracic Surgery
3	Orthopedic Surgery
\.


--
-- Data for Name: Medical Records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Medical Records" ("Record_ID", "Patient_ID", "Diagnosis", "Prescription", "Allergies", "Appointment_ID") FROM stdin;
1	2	Heart Problems	Eat less cheese	Cheese	2
\.


--
-- Data for Name: Patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Patients" ("Patient_ID", "First_Name", "Last_Name", "Date_of_Birth", "Gender", "Email", "Phone", "Emergency_Phone", "Username") FROM stdin;
1	Henry	Mayo	1999-08-10	Male	Patient1@email.com	0555 555 5555	0555 555 5556	Patient1
2	Jeane	Barber	2002-03-03	Female	Patient2@email.com	0777 777 7777	0777 777 7778	Patient2
3	Toby	Hall	1983-02-07	Male	Patient3@email.com	0111 111 1111	0111 111 1112	Patient3
\.


--
-- Data for Name: Staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Staff" ("Staff_ID", "First_Name", "Last_Name", "Job_Title", "Department", "Username") FROM stdin;
1	Warren	Wilder	Staff	Emergency Response	Staff1
2	Max	Harm	Doctor	Cardiology	Doctor1
3	Vera	Chase	Doctor	Orthopedics	Doctor2
\.


--
-- Name: Appointments_Appointment_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Appointments_Appointment_ID_seq"', 4, true);


--
-- Name: Medical Records_Record_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Medical Records_Record_ID_seq"', 1, true);


--
-- Name: Patients_Patient_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Patients_Patient_ID_seq"', 3, true);


--
-- Name: Staff_Staff_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Staff_Staff_ID_seq"', 3, true);


--
-- Name: Appointments Appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Appointments"
    ADD CONSTRAINT "Appointments_pkey" PRIMARY KEY ("Appointment_ID");


--
-- Name: Doctors Doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Doctors"
    ADD CONSTRAINT "Doctors_pkey" PRIMARY KEY ("Staff_ID");


--
-- Name: Medical Records Medical Records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Medical Records"
    ADD CONSTRAINT "Medical Records_pkey" PRIMARY KEY ("Record_ID");


--
-- Name: Patients Patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Patients"
    ADD CONSTRAINT "Patients_pkey" PRIMARY KEY ("Patient_ID");


--
-- Name: Staff Staff_Username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Staff"
    ADD CONSTRAINT "Staff_Username_key" UNIQUE ("Username");


--
-- Name: Staff Staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Staff"
    ADD CONSTRAINT "Staff_pkey" PRIMARY KEY ("Staff_ID");


--
-- Name: Patients Username; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Patients"
    ADD CONSTRAINT "Username" UNIQUE ("Username");


--
-- Name: Medical Records Appointment_ID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Medical Records"
    ADD CONSTRAINT "Appointment_ID" FOREIGN KEY ("Appointment_ID") REFERENCES public."Appointments"("Appointment_ID") NOT VALID;


--
-- Name: Appointments Patient_ID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Appointments"
    ADD CONSTRAINT "Patient_ID" FOREIGN KEY ("Patient_ID") REFERENCES public."Patients"("Patient_ID");


--
-- Name: Medical Records Patient_ID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Medical Records"
    ADD CONSTRAINT "Patient_ID" FOREIGN KEY ("Patient_ID") REFERENCES public."Patients"("Patient_ID") NOT VALID;


--
-- Name: Doctors Staff_ID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Doctors"
    ADD CONSTRAINT "Staff_ID" FOREIGN KEY ("Staff_ID") REFERENCES public."Staff"("Staff_ID");


--
-- Name: Patients PatientView; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "PatientView" ON public."Patients" FOR SELECT TO "Patient" USING ((("Username")::text = CURRENT_USER));


--
-- Name: Patients; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."Patients" ENABLE ROW LEVEL SECURITY;

--
-- Name: FUNCTION "requestAppointment"("_Username" character varying, "_TimeStamp" timestamp without time zone, "_Reason" text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public."requestAppointment"("_Username" character varying, "_TimeStamp" timestamp without time zone, "_Reason" text) TO "Patient";


--
-- Name: TABLE "Patients"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Patients" TO "Patient";


--
-- Name: TABLE "doctorViewPatient"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."doctorViewPatient" TO "Doctor";


--
-- PostgreSQL database dump complete
--

