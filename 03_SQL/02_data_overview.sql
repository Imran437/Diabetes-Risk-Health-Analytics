-- Data Overview

SELECT * 
FROM diabetes_risk
LIMIT 10;


-- Check total number of rows

SELECT
COUNT(*) AS total_rows
FROM diabetes_risk;

-- Check total rows and unique age

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT age) AS unique_rows
FROM diabetes_risk;


-- Check null values in important column

SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN bmi IS NULL THEN 1 ELSE 0 END) AS missing_bmi,
    SUM(CASE WHEN hba1c IS NULL THEN 1 ELSE 0 END) AS missing_hba1c
FROM diabetes_risk;