
--SELECT *
--FROM prescriber

-----1a
/*SELECT max(total_claim_count) AS total_claim_count, max(npi) AS npi
FROM prescription
Answer : Total_claim_count:4538 NPI:1992999791*/

---1b
SELECT max(total_claim_count) AS total_claim_count, max(npi) AS npi nppes_provider_first_name AS first_name, nppes_provider_last_org_name AS last_name, specialty_description
FROM prescription
INNER JOIN prescriber
ON npi.prescriber = npi.prescription;




















