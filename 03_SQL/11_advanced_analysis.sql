-- Advanced Analysis

-- Diabetes rate by multiple dimensions

WITH age_gender AS (
    SELECT
        CASE
            WHEN age < 30 THEN 'Under 30'
            WHEN age < 45 THEN '30-44'
            WHEN age < 60 THEN '45-59'
            ELSE '60+'
        END AS age_group,
        gender,
        diagnosed_diabetes
    FROM diabetes_risk
)
SELECT
    age_group,
    gender,
    COUNT(*) AS total_people,
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) AS diabetes_cases,
    ROUND(
        SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS diabetes_rate_pct
FROM age_gender
GROUP BY age_group, gender
ORDER BY diabetes_rate_pct DESC;


-- Risk-factor count vs diabetes

WITH risk_analysis AS (
    SELECT
        diagnosed_diabetes,
        (
            CASE WHEN bmi >= 25 THEN 1 ELSE 0 END +
            CASE WHEN waist_to_hip_ratio >=
                CASE
                    WHEN gender = 'Male' THEN 0.90
                    WHEN gender = 'Female' THEN 0.85
                    ELSE 999
                END
            THEN 1 ELSE 0 END +
            CASE WHEN glucose_fasting >= 100 THEN 1 ELSE 0 END +
            CASE WHEN hba1c >= 5.7 THEN 1 ELSE 0 END +
            CASE WHEN hypertension_history = 1 THEN 1 ELSE 0 END +
            CASE WHEN family_history_diabetes = 1 THEN 1 ELSE 0 END
        ) AS risk_factor_count
    FROM diabetes_risk
)
SELECT
    risk_factor_count,
    COUNT(*) AS total_people,
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) AS diabetes_cases,
    ROUND(
        SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS diabetes_rate_pct
FROM risk_analysis
GROUP BY risk_factor_count
ORDER BY risk_factor_count;


-- Risk-score quartile analysis

WITH quartile_values AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY diabetes_risk_score) AS q1,
        PERCENTILE_CONT(0.50)
            WITHIN GROUP (ORDER BY diabetes_risk_score) AS q2,
        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY diabetes_risk_score) AS q3
    FROM diabetes_risk
),
risk_quartiles AS (
    SELECT
        d.diagnosed_diabetes,
        d.diabetes_risk_score,
        CASE
            WHEN d.diabetes_risk_score <= q.q1 THEN 1
            WHEN d.diabetes_risk_score <= q.q2 THEN 2
            WHEN d.diabetes_risk_score <= q.q3 THEN 3
            ELSE 4
        END AS risk_quartile
    FROM diabetes_risk d
    CROSS JOIN quartile_values q
)
SELECT
    risk_quartile,
    COUNT(*) AS total_people,
    ROUND(AVG(diabetes_risk_score), 2) AS avg_risk_score,
    SUM(
        CASE
            WHEN diagnosed_diabetes = 1 THEN 1
            ELSE 0
        END
    ) AS diabetes_cases,
    ROUND(
        SUM(
            CASE
                WHEN diagnosed_diabetes = 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS diabetes_rate_pct
FROM risk_quartiles
GROUP BY risk_quartile
ORDER BY risk_quartile;



-- Lifestyle risk analysis

WITH activity_groups AS (
    SELECT
        diagnosed_diabetes,
        CASE
            WHEN physical_activity_minutes_per_week < 150 THEN 'Low Activity'
            WHEN physical_activity_minutes_per_week < 300 THEN 'Moderate Activity'
            ELSE 'High Activity'
        END AS activity_group
    FROM diabetes_risk
)
SELECT
    activity_group,
    COUNT(*) AS total_people,
    SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END) AS diabetes_cases,
    ROUND(
        SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS diabetes_rate_pct
FROM activity_groups
GROUP BY activity_group
ORDER BY diabetes_rate_pct DESC;


-- Metabolic profile by diabetes status

SELECT
    diagnosed_diabetes,
    COUNT(*) AS total_people,
    ROUND(AVG(age), 2) AS avg_age,
    ROUND(AVG(bmi), 2) AS avg_bmi,
    ROUND(AVG(waist_to_hip_ratio), 2) AS avg_whr,
    ROUND(AVG(systolic_bp), 2) AS avg_systolic_bp,
    ROUND(AVG(diastolic_bp), 2) AS avg_diastolic_bp,
    ROUND(AVG(glucose_fasting), 2) AS avg_fasting_glucose,
    ROUND(AVG(glucose_postprandial), 2) AS avg_postprandial_glucose,
    ROUND(AVG(hba1c), 2) AS avg_hba1c,
    ROUND(AVG(insulin_level), 2) AS avg_insulin,
    ROUND(AVG(diabetes_risk_score), 2) AS avg_risk_score
FROM diabetes_risk
GROUP BY diagnosed_diabetes;



-- Diabetes stage analysis

SELECT
    diabetes_stage,
    COUNT(*) AS total_people,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM diabetes_risk),
        2
    ) AS population_pct,
    ROUND(
        SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS diabetes_rate_pct
FROM diabetes_risk
GROUP BY diabetes_stage
ORDER BY total_people DESC;



-- Top demographic/lifestyle segments

WITH segments AS (
    SELECT
        gender,
        smoking_status,
        diagnosed_diabetes
    FROM diabetes_risk
),
segment_rates AS (
    SELECT
        gender,
        smoking_status,
        COUNT(*) AS total_people,
        ROUND(
            SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END)
            * 100.0 / COUNT(*), 2
        ) AS diabetes_rate_pct
    FROM segments
    GROUP BY gender, smoking_status
    HAVING COUNT(*) >= 100
)
SELECT
    *,
    RANK() OVER (
        ORDER BY diabetes_rate_pct DESC
    ) AS segment_rank
FROM segment_rates
ORDER BY segment_rank;



-- Identify discordant/high-priority cases

SELECT
    age,
    gender,
    bmi,
    glucose_fasting,
    hba1c,
    diabetes_risk_score,
    diagnosed_diabetes
FROM diabetes_risk
WHERE diagnosed_diabetes = 0
ORDER BY diabetes_risk_score DESC
LIMIT 20;


-- Compare risk score with biomarkers

SELECT
    CASE
        WHEN hba1c < 5.7 THEN 'Normal'
        WHEN hba1c < 6.5 THEN 'Prediabetes Range'
        ELSE 'Diabetes Range'
    END AS hba1c_group,
    COUNT(*) AS total_people,
    ROUND(AVG(diabetes_risk_score), 2) AS avg_risk_score,
    ROUND(
        SUM(CASE WHEN diagnosed_diabetes = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS diabetes_rate_pct
FROM diabetes_risk
GROUP BY hba1c_group
ORDER BY avg_risk_score DESC;


-- Correlation analysis

SELECT
    ROUND(CORR(bmi, diabetes_risk_score)::numeric, 3) AS bmi_risk_corr,
    ROUND(CORR(glucose_fasting, diabetes_risk_score)::numeric, 3) AS fasting_glucose_risk_corr,
    ROUND(CORR(hba1c, diabetes_risk_score)::numeric, 3) AS hba1c_risk_corr,
    ROUND(CORR(physical_activity_minutes_per_week, diabetes_risk_score)::numeric, 3) AS activity_risk_corr
FROM diabetes_risk;