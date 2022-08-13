
--SELECT *
--FROM prescriber

-----1a
/*SELECT
p1.total_claim_count, p1.npi
FROM prescription AS p1 
JOIN prescriber AS p2
GROUP BY p1




----Answer : Total_claim_count:4538 NPI:1992999791*/



---1b
/*SELECT p1.npi, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, total_claim_count
FROM prescription AS p1
LEFT JOIN prescriber AS p2
ON p1.npi = p2.npi
GROUP BY p1.npi, p2.nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, total_claim_count
ORDER BY total_claim_count 
DESC 
Answer: David Coffey, Family Practice, 4538 */

---2a
/*SELECT p2.specialty_description,SUM(total_claim_count) AS total_claim
FROM prescription AS p1
LEFT JOIN prescriber AS p2
ON p1.npi = p2.npi
GROUP BY  p2.specialty_description
Order by total_claim DESC*/

---2b
/*SELECT p2.specialty_description,SUM(p1.total_claim_count)
FROM prescription AS p1
LEFT JOIN prescriber AS p2
ON p1.npi = p2.npi
LEFT JOIN drug AS d
ON p1.drug_name = d.drug_name
WHERE d.opioid_drug_flag = 'Y'
GROUP BY p2.specialty_description
Order by sum(p1.total_claim_count) DESC 
ANSWER: NURSE PRACTITIONER*/

--3a
/*SELECT d.drug_name, SUM(p1.total_drug_cost)
FROM prescription AS p1
LEFT JOIN drug as d
ON d.drug_name = p1.drug_name
group by d.drug_name, p1.total_drug_cost
ORDER BY p1.total_drug_cost DESC;*/

---3b
/*SELECT d.generic_name, SUM(p1.total_drug_cost/ p1.total_day_supply) AS daily_drug_cost
FROM prescription AS p1
LEFT JOIN drug as d
ON d.drug_name = p1.drug_name
group by d.generic_name
ORDER BY daily_drug_cost DESC;*/

---4a
SELECT drug_name,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
ELSE 'Neither' END AS drug_type
FROM drug;


























