-- Create the database for data 

CREATE DATABASE diabetes_risk_db;
 

-- Create the table for the diabetes data

CREATE TABLE diabetes_risk(
age INT,
gender VARCHAR(10),
ethnicity VARCHAR(20),
education_level VARCHAR(30),
income_level VARCHAR(30),
employment_status VARCHAR(20),
smoking_status VARCHAR(20),
alcohol_consumption_per_week INT,
physical_activity_minutes_per_week INT,
diet_score DECIMAL(5,2),
sleep_hours_per_day DECIMAL(5,2),
screen_time_hours_per_day DECIMAL(5,2),
family_history_diabetes INT,
hypertension_history INT,
cardiovascular_history INT,
bmi DECIMAL(5,2),
waist_to_hip_ratio DECIMAL(5,2),
systolic_bp INT,
diastolic_bp INT,
heart_rate INT,
cholesterol_total INT,
hdl_cholesterol INT,
ldl_cholesterol INT,
triglycerides INT,
glucose_fasting INT,
glucose_postprandial INT,
insulin_level DECIMAL(5,2),
hba1c DECIMAL(5,2),
diabetes_risk_score DECIMAL(5,2),
diabetes_stage VARCHAR(30),
diagnosed_diabetes INT
);

-- import the data

COPY diabetes_risk
FROM 'C:/Work/Projects/Diabetes-Data-Analysis/01_Data/diabetes_dataset_clean.csv'
DELIMITER ','
CSV HEADER;

-- Check the rows

SELECT * FROM diabetes_risk
LIMIT 10;

-- Check total number of rows 

SELECT COUNT(*) AS total_rows
FROM diabetes_risk;

-- 100000 so all rows imported successfully.

-- Check total rows and unique age
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT age) AS distinct_ages
FROM diabetes_risk;

