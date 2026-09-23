

SELECT * FROM hospital.Dim_Patient


-- Data Cleaning (Patient Table)
---- Removed patient rows where FirstName is missing
---- Standardized FirstName and LastName to proper case and create a new FullName column
---- Gender values changed from Male or Female into M or F
---- Split CityStateCountry into City, State, and Country columns


-- DELETE FROM hospital.Dim_Patient where firstname is null

-- Alter table hospital.Dim_Patient add FullName varchar(100)

--UPDATE hospital.Dim_Patient
--SET firstname = UPPER(LEFT(TRIM(firstname), 1)) + LOWER(RIGHT(TRIM(firstname), LEN(firstname) - 1)),
--lastname = UPPER(LEFT(TRIM(lastname), 1)) + LOWER(RIGHT(TRIM(lastname), LEN(lastname) - 1))


--UPDATE hospital.Dim_Patient
--set fullname = firstname + ' ' + lastname

--UPDATE hospital.Dim_Patient
--set Gender = 'M'
--where Gender = 'Male'

--UPDATE hospital.Dim_Patient
--set Gender = 'F'
--where Gender = 'Female'

SELECT 
    FullName,
    gender,
    PARSENAME(REPLACE(citystatecountry, ', ', '.'), 1) as country,
    PARSENAME(REPLACE(citystatecountry, ', ', '.'), 2) as state,
    PARSENAME(REPLACE(citystatecountry, ', ', '.'), 3) as city
FROM hospital.Dim_Patient;


-----------------------------------------------------------------------------------------------------------

-- Data Cleaning (Department Table)
---- Remove departments where DepartmentCategory is missing
---- Drop HOD and DepartmentName columns
---- Use Specialization as DepartmentName column


-- Delete from hospital.Dim_Department where DepartmentCategory is null

-- Alter table hospital.Dim_Department drop column DepartmentName

-- Alter table hospital.Dim_Department drop column HOD

-- EXEC sp_rename 'hospital.Dim_Department.Specialization', 'DepartmentName', 'COLUMN';

SELECT 
    *
FROM hospital.Dim_Department;



-----------------------------------------------------------------------------------------------------------

-- Data Cleaning (Patient Visits Table)
---- Merged all yearly visit tables (2020–2025) into one consolidated PatientVisits table

--CREATE TABLE hospital.PatientVisits (
--  VisitID         VARCHAR(20) PRIMARY KEY,
--  PatientID       VARCHAR(20),
--  DoctorID        VARCHAR(20),
--  DepartmentID    VARCHAR(20),
--  DiagnosisID     VARCHAR(20),
--  TreatmentID     VARCHAR(20),
--  PaymentMethodID VARCHAR(20),
--  VisitDate       DATE,
--  VisitTime       TIME,
--  DischargeDate   DATE,
--  BillAmount      DECIMAL(18,2),
--  InsuranceAmount DECIMAL(18,2),
--  SatisfactionScore INT,
--  WaitTimeMinutes INT
--  -- Optional: add FOREIGN KEYs here if you want to point to clean dimensions later
--  FOREIGN KEY (PatientID)       REFERENCES hospital.Dim_Patient(PatientID),
--  FOREIGN KEY (DoctorID)        REFERENCES hospital.Dim_Doctor(DoctorID),
--  FOREIGN KEY (DepartmentID)    REFERENCES hospital.Dim_Department(DepartmentID),
--  FOREIGN KEY (DiagnosisID)     REFERENCES hospital.Dim_Diagnosis(DiagnosisID),
--  FOREIGN KEY (TreatmentID)     REFERENCES hospital.Dim_Treatment(TreatmentID),
--  FOREIGN KEY (PaymentMethodID) REFERENCES hospital.Dim_PaymentMethod(PaymentMethodID)
--);

--INSERT INTO hospital.PatientVisits
--SELECT * FROM Hospital.PatientVisits_2020_2021
--union all
--SELECT * FROM Hospital.PatientVisits_2022_2023
--union all
--SELECT * FROM Hospital.PatientVisits_2024
--union all
--SELECT * FROM Hospital.PatientVisits_2025


Select * from Hospital.PatientVisits
