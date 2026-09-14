-- Lifestyle Analysis


-- Smoking vs diabetes

SELECT
smoking_status,
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
GROUP BY smoking_status
ORDER BY diabetes_rate_pct DESC;


-- Physical activity vs diabetes

WITH activity_level_cte AS(
SELECT
diagnosed_diabetes,
CASE
WHEN physical_activity_minutes_per_week < 150 THEN 'Low'
WHEN physical_activity_minutes_per_week < 300 THEN 'Medium'
ELSE 'High'
END AS activity_level
FROM diabetes_risk
)
SELECT
activity_level,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM activity_level_cte
GROUP BY activity_level
ORDER BY diabetes_rate_pct DESC;

-- Diet vs Diabetes

WITH diet_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN diet_score < 4 THEN 'Poor Diet'
    WHEN diet_score < 7 THEN 'Moderate Diet'
    ELSE 'Healthy Diet'
END AS diet_group
FROM diabetes_risk
)
SELECT
diet_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM diet_group_cte
GROUP BY diet_group
ORDER BY diabetes_rate_pct DESC;


-- Alcohol vs Diabetes

WITH alcohol_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN alcohol_consumption_per_week = 0 THEN 'No Alcohol'
    WHEN alcohol_consumption_per_week < 4 THEN 'Low'
    WHEN alcohol_consumption_per_week < 8 THEN 'Moderate'
    ELSE 'High'
END AS alcohol_group
FROM diabetes_risk
)
SELECT
alcohol_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM alcohol_group_cte
GROUP BY alcohol_group
ORDER BY diabetes_rate_pct DESC;

-- Sleep vs Diabetes
WITH sleep_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN sleep_hours_per_day < 6 THEN 'Short Sleep'
    WHEN sleep_hours_per_day < 8 THEN 'Moderate Sleep'
    ELSE 'Long Sleep'
END AS sleep_group
FROM diabetes_risk
)
SELECT
sleep_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM sleep_group_cte
GROUP BY sleep_group
ORDER BY diabetes_rate_pct DESC;


-- Screen Time vs Diabetes

WITH screen_time_group_cte AS(
SELECT
diagnosed_diabetes,
CASE
    WHEN screen_time_hours_per_day < 2 THEN 'Low'
    WHEN screen_time_hours_per_day < 4 THEN 'Moderate'
    WHEN screen_time_hours_per_day < 6 THEN 'High'
    ELSE 'Very High'
END AS screen_time_group
FROM
diabetes_risk
)
SELECT
screen_time_group,
COUNT(*) AS total_people,
SUM(
    CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
) AS diabetes_cases,
ROUND(
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS diabetes_rate_pct
FROM screen_time_group_cte
GROUP BY screen_time_group
ORDER BY diabetes_rate_pct DESC;