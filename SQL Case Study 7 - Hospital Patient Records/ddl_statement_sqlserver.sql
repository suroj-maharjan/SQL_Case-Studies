CREATE TABLE hospital_db.payers (
    Id CHAR(36) PRIMARY KEY,
    NAME VARCHAR(100),
    ADDRESS VARCHAR(255),
    CITY VARCHAR(100),
    STATE_HEADQUARTERED CHAR(2),
    ZIP VARCHAR(10),
    PHONE VARCHAR(20)
);



CREATE TABLE hospital_db.patients (
    Id CHAR(36) PRIMARY KEY,
    BIRTHDATE DATE,
    DEATHDATE DATE,
    PREFIX VARCHAR(10),
    FIRST VARCHAR(100),
    LAST VARCHAR(100),
    SUFFIX VARCHAR(10),
    MAIDEN VARCHAR(100),
    MARITAL CHAR(1),
    RACE VARCHAR(50),
    ETHNICITY VARCHAR(50),
    GENDER CHAR(1),
    BIRTHPLACE VARCHAR(255),
    ADDRESS VARCHAR(255),
    CITY VARCHAR(100),
    STATE VARCHAR(100),
    COUNTY VARCHAR(100),
    ZIP VARCHAR(10),
    LAT FLOAT,
    LON FLOAT
);

CREATE TABLE hospital_db."procedures" (
    START DATETIME,
    STOP DATETIME,
    PATIENT CHAR(36),
    ENCOUNTER CHAR(36),
    CODE VARCHAR(20),
    DESCRIPTION VARCHAR(255),
    BASE_COST INT,
    REASONCODE VARCHAR(20),
    REASONDESCRIPTION VARCHAR(255)
);

CREATE TABLE hospital_db.encounters (
  Id CHAR(36) PRIMARY KEY,
  START DATETIME NOT NULL,
  STOP DATETIME NOT NULL,
  PATIENT CHAR(36) NOT NULL,
  ORGANIZATION CHAR(36) NOT NULL,
  PAYER CHAR(36) NOT NULL,
  ENCOUNTERCLASS VARCHAR(50),
  CODE VARCHAR(20),
  DESCRIPTION VARCHAR(255),
  BASE_ENCOUNTER_COST DECIMAL(10,2),
  TOTAL_CLAIM_COST DECIMAL(10,2),
  PAYER_COVERAGE DECIMAL(10,2),
  REASONCODE VARCHAR(20),
  REASONDESCRIPTION VARCHAR(255)
);


--------------------------------------------------------------------------
-------------BULK INSERT----------------

BULK INSERT hospital_db.patients
FROM 'E:\SQL\Hospital Patient Records\patients.csv'
WITH (
    FIRSTROW = 2,                    -- Skip header row
    FIELDTERMINATOR = ',',          -- Comma-separated values
    ROWTERMINATOR = '0x0a',           -- Line break   '\n'
    --CODEPAGE = '65001',             -- UTF-8 (use 'ACP' for ANSI)
    --KEEPNULLS,                      -- Keep NULLs if present
    TABLOCK                         -- For faster insert
);


BULK INSERT hospital_db.payers
FROM 'E:\SQL\Hospital Patient Records\payers.csv'
WITH (
    FIRSTROW = 2,                    -- Skip header row
    FIELDTERMINATOR = ',',          -- Comma-separated values
    ROWTERMINATOR = '0x0a',           -- Line break   '\n'
    --CODEPAGE = '65001',             -- UTF-8 (use 'ACP' for ANSI)
    --KEEPNULLS,                      -- Keep NULLs if present
    TABLOCK                         -- For faster insert
);


BULK INSERT hospital_db."procedures"
FROM 'E:\SQL\Hospital Patient Records\procedures.csv'
WITH (
    FIRSTROW = 2,                    -- Skip header row
    FIELDTERMINATOR = ',',          -- Comma-separated values
    ROWTERMINATOR = '0x0a',           -- Line break   '\n'
    --CODEPAGE = '65001',             -- UTF-8 (use 'ACP' for ANSI)
    --KEEPNULLS,                      -- Keep NULLs if present
    TABLOCK                         -- For faster insert
);



BULK INSERT hospital_db.encounters
FROM 'E:\SQL\Hospital Patient Records\encounters.csv'
WITH (
    FIRSTROW = 2,                    -- Skip header row
    FIELDTERMINATOR = ',',          -- Comma-separated values
    ROWTERMINATOR = '0x0a',           -- Line break   '\n'
    --CODEPAGE = '65001',             -- UTF-8 (use 'ACP' for ANSI)
    --KEEPNULLS,                      -- Keep NULLs if present
    TABLOCK                         -- For faster insert
);

