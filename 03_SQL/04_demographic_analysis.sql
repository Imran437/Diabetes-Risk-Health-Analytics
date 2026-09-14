-- Demographics Analysis

-- Age Group vs Diabetes


WITH age_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
WHEN age < 30 THEN 'Under 30'
WHEN age < 45 THEN '30-44'
WHEN age < 60 THEN '45-59'
ELSE '60+'
END AS age_group
FROM diabetes_risk
)
SELECT
age_group, 
COUNT(*) AS total_people,
    SUM(
        CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
    ) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM age_group_cte
GROUP BY age_group
ORDER BY diabetes_rate_pct DESC;


-- Gender vs diabetes

SELECT
gender,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM diabetes_risk
GROUP BY gender
ORDER BY diabetes_rate_pct DESC;


-- Ethnicity vs Diabetes

SELECT
ethnicity,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM diabetes_risk
GROUP BY ethnicity
ORDER BY diabetes_rate_pct DESC;


-- Employement Status vs Diabetes

SELECT
employment_status,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM diabetes_risk
GROUP BY employment_status
ORDER BY diabetes_rate_pct DESC;


-- Income Level vs Diabetes

SELECT
income_level,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM diabetes_risk
GROUP BY income_level
ORDER BY diabetes_rate_pct DESC;


-- Education Level vs Diabetes

SELECT
education_level,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM diabetes_risk
GROUP BY education_level
ORDER BY diabetes_rate_pct DESC;