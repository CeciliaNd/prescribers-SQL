
--SELECT *
--FROM prescriber

-----1a
SELECT SUM(total_claim_count) AS claims, npi
FROM prescription 
GROUP BY npi
ORDER BY claims DESC
--1881634483: 99707



---1b
SELECT p1.npi, p2.nppes_provider_first_name AS first_name, p2.nppes_provider_last_org_name AS last_name, p2.specialty_description, SUM(p1.total_claim_count) AS claims
FROM prescription AS p1
LEFT JOIN prescriber AS p2
ON p1.npi = p2.npi
GROUP BY p1.npi,first_name, last_name, specialty_description
ORDER BY claims
DESC 
---Bruce Pendley with 99,707 claims

---2a
SELECT p2.specialty_description,SUM(p1.total_claim_count) AS claims
FROM prescription AS p1
LEFT JOIN prescriber AS p2
ON p1.npi = p2.npi
GROUP BY specialty_description
Order by claims DESC
-- Family Practice: 9,752,347

---2b
SELECT p2.specialty_description, SUM(p1.total_claim_count) AS claims
FROM prescription AS p1
LEFT JOIN prescriber AS p2
ON p1.npi = p2.npi
LEFT JOIN drug AS d
ON p1.drug_name = d.drug_name
WHERE d.opioid_drug_flag = 'Y'
GROUP BY p2.specialty_description
Order by sum(p1.total_claim_count) DESC 
ANSWER: NURSE PRACTITIONER: 900,845

--2c:
SELECT p2.specialty_description, SUM(p1.total_claim_count) AS claims
FROM prescriber as p2
FULL JOIN prescription as p1
ON p1.npi=p2.npi
GROUP BY specialty_description
HAVING SUM(p1.total_claim_count) IS NULL
--15

--3a
SELECT d.generic_name, SUM(p.total_drug_cost) AS total_cost
FROM drug AS d
LEFT JOIN prescription as p
ON d.drug_name = p.drug_name
group by d.generic_name
HAVING SUM(p.total_drug_cost) IS NOT NULL
ORDER BY total_cost DESC;
--Insulin Glargine, Hum.Rec.Anlog:104.264,066.35

---3b
SELECT d.generic_name, ROUND(sum(p.total_drug_cost)/sum(p.total_day_supply),2) AS daily_cost
FROM drug AS d
INNER JOIN prescription as p
ON d.drug_name = p.drug_name
group by generic_name
ORDER BY daily_cost DESC;
--C1 Esterase Inhibitor: $3495.22

---4a
/*SELECT drug_name, opioid_drug_flag, antibiotic_drug_flag,
CASE
WHEN opioid_drug_flag = 'Y' THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
ELSE 'neither'
END AS drug_type
FROM drug;*/

---4b
SELECT MONEY(SUM(total_drug_cost)),
CASE 
WHEN opioid_drug_flag = 'Y' THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
ELSE 'Neither' 
END AS drug_type
FROM drug
LEFT JOIN prescription
ON drug.drug_name = prescription.drug_name
GROUP BY drug_type;
--(neither), then opiods, then antibiotics

--5a
SELECT COUNT(DISTINCT cbsa)
FROM cbsa
LEFT JOIN fips_county
USING (fipscounty)
WHERE fips_county.state = 'TN'
--10

--5b
SELECT cbsaname, sum(population) AS total_population
FROM cbsa
INNER JOIN population
USING (fipscounty)
GROUP BY cbsaname
HAVING sum(population) IS NOT NULL
ORDER BY total_population DESC
--Nashville-Davidson_Murfreesboro-Franklin: 1,830,410

SELECT cbsaname, sum(population) AS total_population
FROM cbsa
INNER JOIN population
USING (fipscounty)
GROUP BY cbsaname
HAVING SUM(population) IS NOT NULL
ORDER BY total_population
--Morristown:116,352

--5c
SELECT f.county, f.state, p.population
FROM fips_county as f
INNER JOIN population as p
USING (fipscounty)
LEFT JOIN cbsa as c
USING (fipscounty)
WHERE c.cbsa IS NULL
ORDER BY population DESC;
--sevier: 95,523

--6a
SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >= 3000;

--6b
SELECT drug_name, total_claim_count, opioid_drug_flag
FROM prescription
LEFT JOIN drug
USING (drug_name)
WHERE total_claim_count >= 3000;

--6c
SELECT drug_name, total_claim_count, opioid_drug_flag, nppes_provider_first_name, nppes_provider_last_org_name
FROM prescription
LEFT JOIN drug
USING (drug_name)
LEFT JOIN prescriber
ON prescription.npi=prescriber.npi
WHERE total_claim_count >= 3000;

--7a
SELECT npi, drug_name
FROM prescriber
CROSS JOIN drug
WHERE specialty_description = 'Pain Management'
AND nppes_provider_city = 'Nashville'
AND opioid_drug_flag = 'Y';

--7b
SELECT prescriber.npi, drug_name, total_claim_count
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription
USING(npi, drug_name)
WHERE specialty_description = 'Pain Management'
AND nppes_provider_city = 'NASHVILLE'
AND opioid_drug_flag = 'Y'
ORDER BY drug_name;

--7c
SELECT prescriber.npi, drug_name, COALESCE(total_claim_count,0)
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription
USING(npi,drug_name)
WHERE specialty_description = 'Pain Management'
AND nppes_provider_city = 'NASHVILLE'
AND opioid_drug_flag = 'Y'
ORDER BY drug_name;

























