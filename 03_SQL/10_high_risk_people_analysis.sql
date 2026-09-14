-- High-Risk People



-- Risk Score Distribution


SELECT
    MIN(diabetes_risk_score) AS min_risk_score,
    ROUND(AVG(diabetes_risk_score), 2) AS avg_risk_score,
    PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY diabetes_risk_score) AS median_risk_score,
    MAX(diabetes_risk_score) AS max_risk_score
FROM diabetes_risk;

-- people with high risk but no diagnosis
-- high diabetes_risk_score
-- but diagnosed_diabetes = 0

SELECT
    COUNT(*) AS high_risk_undiagnosed
FROM diabetes_risk
WHERE diabetes_risk_score >= 40
  AND diagnosed_diabetes = 0;


-- Calculate the percentage

SELECT
    COUNT(*) AS high_risk_undiagnosed,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM diabetes_risk),
        2
    ) AS pct_of_total_population
FROM diabetes_risk
WHERE diabetes_risk_score >= 40
  AND diagnosed_diabetes = 0;

-- Profile high-risk people

SELECT
    COUNT(*) AS high_risk_undiagnosed,
    ROUND(AVG(age), 1) AS avg_age,
    ROUND(AVG(bmi), 2) AS avg_bmi,
    ROUND(AVG(glucose_fasting), 2) AS avg_fasting_glucose,
    ROUND(AVG(glucose_postprandial), 2) AS avg_postprandial_glucose,
    ROUND(AVG(hba1c), 2) AS avg_hba1c,
    ROUND(AVG(diabetes_risk_score), 2) AS avg_risk_score
FROM diabetes_risk
WHERE diabetes_risk_score >= 40
  AND diagnosed_diabetes = 0;


-- Biggest high-risk segments


WITH high_risk AS (
    SELECT
        CASE
            WHEN age < 30 THEN 'Under 30'
            WHEN age < 45 THEN '30-44'
            WHEN age < 60 THEN '45-59'
            ELSE '60+'
        END AS age_group,
        diagnosed_diabetes
    FROM diabetes_risk
    WHERE diabetes_risk_score >= 40
      AND diagnosed_diabetes = 0
)
SELECT
    age_group,
    COUNT(*) AS high_risk_people
FROM high_risk
GROUP BY age_group
ORDER BY high_risk_people DESC;


-- Multiple Risk Factors

SELECT
    COUNT(*) AS high_risk_people
FROM diabetes_risk
WHERE diagnosed_diabetes = 0
  AND diabetes_risk_score >= 40
  AND hba1c >= 5.7
  AND glucose_fasting >= 100
  AND bmi >= 25;



-- Advanced High-Risk Analysis


-- Rank high-risk undiagnosed people

WITH high_risk AS (
    SELECT
        age,
        gender,
        bmi,
        hba1c,
        glucose_fasting,
        diabetes_risk_score,
        diagnosed_diabetes
    FROM diabetes_risk
    WHERE diabetes_risk_score >= 40
      AND diagnosed_diabetes = 0
),
ranked_people AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY diabetes_risk_score DESC
        ) AS risk_rank
    FROM high_risk
)
SELECT *
FROM ranked_people
ORDER BY risk_rank;


-- Top 10% high-risk undiagnosed population

WITH ranked_people AS (
    SELECT
        *,
        NTILE(10) OVER (
            ORDER BY diabetes_risk_score DESC
        ) AS risk_decile
    FROM diabetes_risk
    WHERE diagnosed_diabetes = 0
)
SELECT
    COUNT(*) AS top_10pct_high_risk
FROM ranked_people
WHERE risk_decile = 1;


-- Compare risk groups with diabetes rate

WITH risk_groups AS (
    SELECT
        diagnosed_diabetes,
        diabetes_risk_score,
        NTILE(4) OVER (
            ORDER BY diabetes_risk_score
        ) AS risk_quartile
    FROM diabetes_risk
)
SELECT
    risk_quartile,
    COUNT(*) AS total_people,
    SUM(CASE
        WHEN diagnosed_diabetes = 1 THEN 1
        ELSE 0
    END) AS diabetes_cases,
    ROUND(
        SUM(CASE
            WHEN diagnosed_diabetes = 1 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS diabetes_rate_pct
FROM risk_groups
GROUP BY risk_quartile
ORDER BY risk_quartile;


-- Risk score vs actual diagnosis

SELECT
    diagnosed_diabetes,
    COUNT(*) AS total_people,
    ROUND(AVG(diabetes_risk_score), 2) AS avg_risk_score,
    ROUND(AVG(hba1c), 2) AS avg_hba1c,
    ROUND(AVG(glucose_fasting), 2) AS avg_fasting_glucose,
    ROUND(AVG(bmi), 2) AS avg_bmi
FROM diabetes_risk
GROUP BY diagnosed_diabetes;



-- Multi-risk-factor analysis

WITH risk_factors AS (
    SELECT
        diagnosed_diabetes,
        diabetes_risk_score,

        (
            CASE WHEN bmi >= 25 THEN 1 ELSE 0 END +
            CASE WHEN hba1c >= 5.7 THEN 1 ELSE 0 END +
            CASE WHEN glucose_fasting >= 100 THEN 1 ELSE 0 END +
            CASE WHEN hypertension_history = 1 THEN 1 ELSE 0 END +
            CASE WHEN family_history_diabetes = 1 THEN 1 ELSE 0 END
        ) AS risk_factor_count

    FROM diabetes_risk
)
SELECT
    risk_factor_count,
    COUNT(*) AS total_people,
    SUM(
        CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
    ) AS diabetes_cases,
    ROUND(
        SUM(
            CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
        ) * 100.0 / COUNT(*),
        2
    ) AS diabetes_rate_pct
FROM risk_factors
GROUP BY risk_factor_count
ORDER BY risk_factor_count;


-- High-risk segment ranking

WITH segments AS (
    SELECT
        CASE
            WHEN age < 30 THEN 'Under 30'
            WHEN age < 45 THEN '30-44'
            WHEN age < 60 THEN '45-59'
            ELSE '60+'
        END AS age_group,

        CASE
            WHEN bmi < 18.5 THEN 'Underweight'
            WHEN bmi < 25 THEN 'Normal'
            WHEN bmi < 30 THEN 'Overweight'
            ELSE 'Obese'
        END AS bmi_group,

        diagnosed_diabetes
    FROM diabetes_risk
)
SELECT
    age_group,
    bmi_group,
    COUNT(*) AS total_people,
    SUM(
        CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
    ) AS diabetes_cases,
    ROUND(
        SUM(
            CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END
        ) * 100.0 / COUNT(*),
        2
    ) AS diabetes_rate_pct
FROM segments
GROUP BY age_group, bmi_group
HAVING COUNT(*) >= 100
ORDER BY diabetes_rate_pct DESC;


-- Rank risk factors by diabetes rate

SELECT
    'Family History' AS risk_factor,
    ROUND(
        SUM(CASE
            WHEN family_history_diabetes = 1
             AND diagnosed_diabetes = 1
            THEN 1 ELSE 0
        END) * 100.0
        /
        NULLIF(SUM(CASE
            WHEN family_history_diabetes = 1
            THEN 1 ELSE 0
        END), 0),
        2
    ) AS diabetes_rate_pct
FROM diabetes_risk

UNION ALL

SELECT
    'Hypertension',
    ROUND(
        SUM(CASE
            WHEN hypertension_history = 1
             AND diagnosed_diabetes = 1
            THEN 1 ELSE 0
        END) * 100.0
        /
        NULLIF(SUM(CASE
            WHEN hypertension_history = 1
            THEN 1 ELSE 0
        END), 0),
        2
    )
FROM diabetes_risk;