-- Diabetes Stage Analysis


-- Diabetes Stage

SELECT
diabetes_stage,
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
GROUP BY diabetes_stage
ORDER BY diabetes_rate_pct DESC;

