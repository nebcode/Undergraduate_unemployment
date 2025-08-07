DROP TABLE test_connection;

CREATE TABLE unemployed (
    Date DATE,
    Young_workers REAL,
    All_workers REAL,
    Recent_graduates REAL,
    College_graduates REAL
);
COPY unemployed 
FROM 'C:/VS Code/Undergraduate_unemployment/unemployed.csv'
WITH (FORMAT csv, HEADER true);

CREATE TABLE wages(
    Date DATE,
    Bachelors_25th_percentile TEXT,
    Bachelors_median TEXT,
    Bachelors_75th_percentile TEXT,
    High_school_median TEXT
); 
-- Note: Text columns still need to be converted to numeric types
COPY wages
FROM 'C:/VS Code/Undergraduate_unemployment/wages.csv'
WITH (FORMAT csv, HEADER true);


CREATE TABLE underemployed(
    Date DATE,
    Recent_graduates REAL,
    College_graduates REAL
);
COPY underemployed
FROM 'C:/VS Code/Undergraduate_unemployment/underemployed.csv'
WITH (FORMAT csv, HEADER true);

CREATE TABLE outcomes(
    Major TEXT,
    Unemployment_rate REAL,
    Underemployment_rate REAL,
    Median_Wage_Early_Career TEXT,
    Median_Wage_Mid_Career TEXT,
    Percentage_with_graduate_degree REAL
); 
-- Note: Text columns still need to be converted to numeric types
COPY outcomes
FROM 'C:/VS Code/Undergraduate_unemployment/outcomes_by_major.csv'
WITH (FORMAT csv, HEADER true);
SELECT * FROM outcomes;

CREATE TABLE Interest_rate(
    Date DATE,
    Rate REAL
);
COPY Interest_rate
FROM 'C:/VS Code/Undergraduate_unemployment/Interest_rate.csv'
WITH (FORMAT csv, HEADER true);
SELECT * FROM Interest_rate;

CREATE TABLE CPI(
    Date DATE,
    CPI REAL
);
COPY CPI
FROM 'C:/VS Code/Undergraduate_unemployment/CPI.csv'
WITH (FORMAT csv, HEADER true);


CREATE TABLE CFNAI(
    Date DATE,
    CFNAI REAL
);
COPY CFNAI
FROM 'C:/VS Code/Undergraduate_unemployment/CFNAI.csv'
WITH (FORMAT csv, HEADER true);
SELECT * FROM CFNAI;

SELECT 
    u.Date,
    u.Young_workers,
    u.All_workers,
    u.Recent_graduates,
    u.College_graduates,
    ir.Rate AS Interest_Rate,
    c.CPI,
    cf.CFNAI
FROM unemployed u
JOIN Interest_rate ir ON u.Date = ir.Date
JOIN CPI c ON u.Date = c.Date
JOIN CFNAI cf ON u.Date = cf.Date;
-- This query combines unemployment data with interest rates, CPI, and CFNAI for comprehensive analysis.

CREATE TABLE jobs(
    Date DATE,
    Total_jobs REAL,
    Unemployed REAL,
    Job_openings REAL
);

DROP TABLE IF EXISTS jobs;


CREATE TABLE jobs (
    Year Text,
    Jan INT,
    Feb INT,
    Mar INT,
    Apr INT,
    May INT,
    Jun INT,
    Jul INT,
    Aug INT,
    Sep INT,
    Oct INT,
    Nov INT,
    Dec INT
);

COPY jobs
FROM 'C:/VS Code/Undergraduate_unemployment/Jobs.csv'
WITH (FORMAT csv, HEADER true);

-- Create a new table to store the monthly job data with the first 11 rows from the original jobs table
CREATE TABLE monthly_jobs AS jobs;

CREATE TABLE demand AS
SELECT 
    unemployed.Date,
    unemployed.Young_workers,
    unemployed.All_workers,
    unemployed.Recent_graduates,
    unemployed.College_graduates,
    CPI.cpi,
    Interest_rate.rate,
    CFNAI.cfnai
FROM unemployed
JOIN CPI ON unemployed.Date = CPI.Date
JOIN Interest_rate ON unemployed.Date = Interest_rate.Date
JOIN CFNAI ON unemployed.Date = CFNAI.Date;

ALTER TABLE demand
DROP COLUMN young_workers,
DROP COLUMN college_graduates;

SELECT * FROM demand;
