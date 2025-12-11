SELECT 
   e.Id AS encounter_id,
   p.Id AS patient_id,
   p.FIRST,
   p.LAST,
   TIMESTAMPDIFF(YEAR, p.BIRTHDATE, CURDATE()) AS age,
   e.START,
   e.STOP,
   e.TOTAL_CLAIM_COST
FROM encounters e
JOIN patients p ON e.PATIENT = p.Id;   

SELECT 
  pr.CODE,
  pr.DESCRIPTION,
  p.FIRST,
  p.LAST,
  TIMESTAMPDIFF(YEAR, p.BIRTHDATE, CURDATE()) AS age
FROM procedures pr
JOIN patients p ON pr.PATIENT = p.Id;  

SELECT 
    e.Id AS encounter_id,
    pay.NAME AS payer_name,
    e.TOTAL_CLAIM_COST,
    e.PAYER_COVERAGE
FROM encounters e
JOIN payers pay ON e.PAYER = pay.Id;