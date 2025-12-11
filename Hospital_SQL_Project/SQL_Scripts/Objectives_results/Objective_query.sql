SELECT 
    YEAR(START) AS year,
    COUNT(*) AS total_encounters
FROM encounters
GROUP BY YEAR(START)
ORDER BY year;

SELECT
    YEAR(START) AS year,
    ENCOUNTERCLASS,
    COUNT(*) AS count_encounters,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY YEAR(START)),
        2
    ) AS percentage
FROM encounters
GROUP BY YEAR(START), ENCOUNTERCLASS
ORDER BY year, percentage DESC;

SELECT 
    SUM(CASE WHEN TIMESTAMPDIFF(HOUR, START, STOP) > 24 THEN 1 END) AS over_24_hours,
    SUM(CASE WHEN TIMESTAMPDIFF(HOUR, START, STOP) <= 24 THEN 1 END) AS under_24_hours,
    ROUND(
        SUM(CASE WHEN TIMESTAMPDIFF(HOUR, START, STOP) > 24 THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS pct_over_24,
    ROUND(
        SUM(CASE WHEN TIMESTAMPDIFF(HOUR, START, STOP) <= 24 THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS pct_under_24
FROM encounters;

SELECT
    COUNT(*) AS zero_coverage_encounters,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM encounters), 2) AS pct_zero_coverage
FROM encounters
WHERE PAYER_COVERAGE = 0 OR PAYER_COVERAGE IS NULL;

SELECT
    CODE,
    DESCRIPTION,
    COUNT(*) AS procedure_count,
    ROUND(AVG(BASE_COST), 2) AS avg_base_cost
FROM procedures
GROUP BY code, description
ORDER BY procedure_count DESC
LIMIT 10;

SELECT
    CODE,
    DESCRIPTION,
    ROUND(AVG(BASE_COST), 2) AS avg_base_cost,
    COUNT(*) AS occurrences
FROM procedures
GROUP BY code, description
ORDER BY avg_base_cost DESC
LIMIT 10;

SELECT
    p.NAME AS payer_name,
    ROUND(AVG(e.TOTAL_CLAIM_COST), 2) AS avg_claim_cost
FROM encounters e
JOIN payers p ON e.PAYER = p.Id
GROUP BY p.NAME
ORDER BY avg_claim_cost DESC;

SELECT
    YEAR(START) AS year,
    QUARTER(START) AS quarter,
    COUNT(DISTINCT PATIENT) AS unique_patients
FROM encounters
GROUP BY YEAR(START), QUARTER(START)
ORDER BY year, quarter;


WITH sorted AS (
    SELECT 
        PATIENT,
        START,
        LAG(START) OVER (PARTITION BY PATIENT ORDER BY START) AS prev_start
    FROM encounters
),
readmit AS (
    SELECT 
        PATIENT,
        COUNT(*) AS readmission_count
    FROM sorted
    WHERE prev_start IS NOT NULL
      AND DATEDIFF(START, prev_start) <= 30
    GROUP BY PATIENT
)
SELECT 
    p.Id AS patient_id,
    p.FIRST,
    p.LAST,
    r.readmission_count
FROM readmit r
JOIN patients p ON p.Id = r.PATIENT
ORDER BY r.readmission_count DESC
LIMIT 10;





