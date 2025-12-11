SELECT 
  age_group,
  AVG(TOTAL_CLAIM_COST) AS avg_claim_cost
FROM
 (
 SELECT 
   CASE
      WHEN TIMESTAMPDIFF(YEAR, BIRTHDATE, CURDATE()) < 18 THEN '0-17'
      WHEN TIMESTAMPDIFF(YEAR, BIRTHDATE, CURDATE()) BETWEEN 18 AND 40 THEN '18-40'
	  WHEN TIMESTAMPDIFF(YEAR, BIRTHDATE, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
      ELSE '60+'
    END AS age_group,
    e.TOTAL_CLAIM_COST
     FROM patients p
     JOIN encounters e ON p.Id = e.PATIENT
     ) AS t
     GROUP BY age_group;

SELECT
  DESCRIPTION,
  AVG(BASE_COST) AS avg_cost
FROM procedures
GROUP BY DESCRIPTION
ORDER BY avg_cost DESC;  

SELECT 
  pay.NAME AS payer,
  AVG(e.PAYER_COVERAGE) AS avg_coverage
FROM encounters e
JOIN payers pay ON e.PAYER = pay.Id
GROUP BY pay.NAME
ORDER BY avg_coverage DESC;  