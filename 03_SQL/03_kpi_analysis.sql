-- KPIS

-- Total People

SELECT
COUNT(*) AS total_people
FROM diabetes_risk;

-- Diabetes case

SELECT
SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) AS diabetes_cases
FROM diabetes_risk;

-- Non-Diabetes Cases

SELECT
SUM(CASE WHEN diagnosed_diabetes = 0 THEN 1 ELSE 0 END) AS diabetes_cases
FROM diabetes_risk;


-- Diabetes prevalence

SELECT
    ROUND(
        100.0 * SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS diabetes_prevalence_pct
FROM diabetes_risk;

-- Average Risk Score, BMI, hbA1c, and fasting glucose

SELECT
    ROUND(AVG(diabetes_risk_score), 2) AS avg_risk_score,
    ROUND(AVG(bmi), 2) AS avg_bmi,
    ROUND(AVG(hba1c), 2) AS avg_hba1c,
    ROUND(AVG(glucose_fasting), 2) AS avg_fasting_glucose
FROM diabetes_risk;