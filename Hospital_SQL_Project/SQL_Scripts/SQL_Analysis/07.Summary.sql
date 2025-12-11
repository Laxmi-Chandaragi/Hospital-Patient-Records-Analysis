SELECT 
  p.FIRST,p.LAST,
  SUM(e.TOTAL_CLAIM_COST) AS total_spent
FROM encounters e
JOIN patients p ON e.PATIENT = p.Id
GROUP BY p.Id
ORDER BY total_spent DESC;  

SELECT 
  (SELECT COUNT(*) FROM patients) AS total_patients,
  (SELECT COUNT(*) FROM encounters) AS total_encounters,
  (SELECT COUNT(*) FROM procedures) AS total_procedures,
  (SELECT COUNT(*) FROM payers) AS total_payers;

SELECT 
   age,
   COUNT(*) AS encounter_count
FROM (
    SELECT 
       TIMESTAMPDIFF(YEAR, p.BIRTHDATE, CURDATE()) AS age,
       e.Id AS encounter_id
    FROM patients p
    JOIN encounters e ON e.PATIENT = p.Id
    ) AS t
GROUP BY age;    

