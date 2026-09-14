-- Health Analysis

-- BMI vs diabetes


WITH bmi_category_cte AS(
SELECT
diagnosed_diabetes,
CASE
WHEN bmi < 18.5 THEN 'Underweight'
WHEN bmi < 25 THEN 'Normal'
WHEN bmi < 30 THEN 'Overweight'
ELSE 'Obese'
END AS bmi_category
FROM diabetes_risk
)
SELECT
bmi_category,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM bmi_category_cte
GROUP BY bmi_category
ORDER BY diabetes_rate_pct DESC;



-- Waist-to-hip ratio vs Diabetes

WITH whr_group_cte AS(
    SELECT
    diagnosed_diabetes,
    CASE
    WHEN gender = 'Male' AND waist_to_hip_ratio < 0.90 THEN 'Lower Risk'
    WHEN gender = 'Male' AND waist_to_hip_ratio >= 0.90 THEN 'Higher Risk'
    WHEN gender = 'Female' AND waist_to_hip_ratio < 0.85 THEN 'Lower Risk'
    WHEN gender = 'Female' AND waist_to_hip_ratio >= 0.85 THEN 'Higher Risk'
    ELSE 'Not Classified'
END AS whr_group
    FROM diabetes_risk
)
SELECT
whr_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM whr_group_cte
GROUP BY whr_group
ORDER BY diabetes_rate_pct DESC;


-- Blood Pressure vs Diabetes

-- Systolic BP

WITH systolic_bp_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN systolic_bp < 120 THEN 'Normal'
    WHEN systolic_bp < 130 THEN 'Elevated'
    WHEN systolic_bp < 140 THEN 'High Stage 1'
    ELSE 'High Stage 2'
END AS systolic_bp_group
FROM diabetes_risk
)
SELECT
systolic_bp_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM systolic_bp_group_cte
GROUP BY systolic_bp_group
ORDER BY diabetes_rate_pct DESC;


-- Diastolic BP

WITH diastolic_bp_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN diastolic_bp < 80 THEN 'Normal'
    WHEN diastolic_bp < 90 THEN 'High Stage 1'
    ELSE 'High Stage 2'
END AS diastolic_bp_group
FROM diabetes_risk
)
SELECT
diastolic_bp_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM diastolic_bp_group_cte
GROUP BY diastolic_bp_group
ORDER BY diabetes_rate_pct DESC;


-- Cholesterol


WITH cholesterol_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN cholesterol_total < 200 THEN 'Desirable'
    WHEN cholesterol_total < 240 THEN 'Borderline High'
    ELSE 'High'
END AS cholesterol_group
FROM diabetes_risk
)
SELECT
cholesterol_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM cholesterol_group_cte
GROUP BY cholesterol_group
ORDER BY diabetes_rate_pct DESC;


-- Triglycerides

WITH triglycerides_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN triglycerides < 150 THEN 'Normal'
    WHEN triglycerides < 200 THEN 'Borderline High'
    WHEN triglycerides < 500 THEN 'High'
    ELSE 'Very High'
END AS triglycerides_group
FROM diabetes_risk
)
SELECT
triglycerides_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM triglycerides_group_cte
GROUP BY triglycerides_group
ORDER BY diabetes_rate_pct DESC;