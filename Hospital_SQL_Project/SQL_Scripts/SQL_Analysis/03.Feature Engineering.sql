SELECT p.*,
       TIMESTAMPDIFF(YEAR, p.BIRTHDATE, CURDATE()) AS age
FROM patients p;   

SELECT Id,
      CONCAT(FIRST, ' ' ,LAST ) AS full_name
FROM patients;    

SELECT Id,
       TIMESTAMPDIFF(HOUR, START, STOP) AS encounter_duration_hours
FROM encounters; 