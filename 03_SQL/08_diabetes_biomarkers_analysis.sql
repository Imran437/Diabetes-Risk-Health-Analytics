-- Diabetes Biomarkers

-- Fasting Glucose — 60 to 172 mg/dL

WITH fasting_glucose_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN glucose_fasting < 70 THEN 'Low'
    WHEN glucose_fasting < 100 THEN 'Normal'
    WHEN glucose_fasting < 126 THEN 'Prediabetes Range'
    ELSE 'Diabetes Range'
END AS fasting_glucose_group
FROM diabetes_risk
)
SELECT
fasting_glucose_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM fasting_glucose_group_cte
GROUP BY fasting_glucose_group
ORDER BY diabetes_rate_pct DESC;


-- Postprandial Glucose — 70 to 287 mg/dL

WITH postprandial_glucose_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN glucose_postprandial < 140 THEN 'Normal'
    WHEN glucose_postprandial < 200 THEN 'Prediabetes Range'
    ELSE 'Diabetes Range'
END AS postprandial_glucose_group
FROM diabetes_risk
)
SELECT
postprandial_glucose_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM postprandial_glucose_group_cte
GROUP BY postprandial_glucose_group
ORDER BY diabetes_rate_pct DESC;


-- HbA1c — 4.00 to 9.80%



WITH hba1c_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN hba1c < 5.7 THEN '5.7'
    WHEN hba1c < 6.5 THEN '5.7-6.4'
    WHEN hba1c < 7.5 THEN '6.5-7.4'
    WHEN hba1c < 8.5 THEN '7.5-8.4'
    ELSE '>=8.5'
END AS hba1c_group
FROM diabetes_risk
)
SELECT
hba1c_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM hba1c_group_cte
GROUP BY hba1c_group
ORDER BY diabetes_rate_pct DESC;

-- or

WITH hba1c_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN hba1c < 5.7 THEN 'Normal'
    WHEN hba1c < 6.5 THEN 'Prediabetes Range'
    ELSE 'Diabetes Range'
END AS hba1c_group
FROM diabetes_risk
)
SELECT
hba1c_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM hba1c_group_cte
GROUP BY hba1c_group
ORDER BY diabetes_rate_pct DESC;


-- Insulin Level — 2.00 to 32.22

WITH insulin_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN insulin_level < 5.09 THEN 'Low'
    WHEN insulin_level < 8.79 THEN 'Moderate-Low'
    WHEN insulin_level < 12.45 THEN 'Moderate-High'
    ELSE 'High'
END AS insulin_group
FROM diabetes_risk
)
SELECT
insulin_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM insulin_group_cte
GROUP BY insulin_group
ORDER BY diabetes_rate_pct DESC;


