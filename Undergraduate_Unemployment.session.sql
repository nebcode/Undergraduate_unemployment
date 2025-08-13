DROP TABLE Interest_rates;

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

CREATE TABLE monthly_jobs AS
SELECT 
    TO_DATE(Year || '-' || month_num, 'YYYY-MM') AS date,
    jobs AS jobs
FROM (
    SELECT Year, '01' AS month_num, Jan AS jobs FROM jobs
    UNION ALL
    SELECT Year, '02', Feb FROM jobs
    UNION ALL
    SELECT Year, '03', Mar FROM jobs
    UNION ALL
    SELECT Year, '04', Apr FROM jobs
    UNION ALL
    SELECT Year, '05', May FROM jobs
    UNION ALL
    SELECT Year, '06', Jun FROM jobs
    UNION ALL
    SELECT Year, '07', Jul FROM jobs
    UNION ALL
    SELECT Year, '08', Aug FROM jobs
    UNION ALL
    SELECT Year, '09', Sep FROM jobs
    UNION ALL
    SELECT Year, '10', Oct FROM jobs
    UNION ALL
    SELECT Year, '11', Nov FROM jobs
    UNION ALL
    SELECT Year, '12', Dec FROM jobs
) AS monthly_jobs
ORDER BY date;



CREATE TABLE LSI AS
SELECT 
    underemployed.Date,
    underemployed.recent_graduates,
    monthly_jobs.jobs
FROM underemployed
JOIN monthly_jobs ON underemployed.Date = monthly_jobs.Date;



CREATE TABLE u3(
    Date DATE,
    U3 REAL
);
COPY u3
FROM 'C:/VS Code/Undergraduate_unemployment/u3.csv'
WITH (FORMAT csv, HEADER true);

CREATE TABLE u6(
    Date DATE,
    U6 REAL
);
COPY u6
FROM 'C:/VS Code/Undergraduate_unemployment/u6.csv'
WITH (FORMAT csv, HEADER true);

CREATE TABLE u3_u6 AS
SELECT 
    u3.Date,
    u3.U3,
    u6.U6
FROM u3
JOIN u6 ON u3.Date = u6.Date;


ALTER TABLE LSI
ADD COLUMN lsi NUMERIC;
UPDATE LSI
SET lsi = (recent_graduates::NUMERIC / jobs) * 100;

SELECT * FROM LSI;



COPY demand TO 'C:/VS Code/Undergraduate_unemployment/final_tables/demand.csv' WITH (FORMAT CSV, HEADER);
COPY LSI TO 'C:/VS Code/Undergraduate_unemployment/final_tables/LSI.csv' WITH (FORMAT CSV, HEADER);
COPY u3_u6 TO 'C:/VS Code/Undergraduate_unemployment/final_tables/u3_u6.csv' WITH (FORMAT CSV, HEADER);

