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


CREATE TABLE Interest_rate(
    Date DATE,
    Rate REAL
);
COPY Interest_rates
FROM 'C:/VS Code/Undergraduate_unemployment/Interest_rate.csv'
WITH (FORMAT csv, HEADER true);

CREATE TABLE CPI(
    Date DATE,
    CPI REAL
);
COPY CPI
FROM 'C:/VS Code/Undergraduate_unemployment/CPI.csv'
WITH (FORMAT csv, HEADER true);


