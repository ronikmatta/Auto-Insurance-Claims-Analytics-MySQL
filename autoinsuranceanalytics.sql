-- 1
USE insurance_analytics;

-- 2 
SELECT *
FROM autoclaims_cleaned
LIMIT 10;

-- 3
SELECT COUNT(*) AS total_records
FROM autoclaims_cleaned;

-- 4 no. of columns
SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='insurance_analytics'
AND TABLE_NAME='autoclaims_cleaned';

-- 5 duplicate policies checking
SELECT policy_number,
       COUNT(*) AS frequency
FROM autoclaims_cleaned
GROUP BY policy_number
HAVING COUNT(*)>1;
-- none so all policies are unique

-- 6 count unique policies
SELECT COUNT(DISTINCT policy_number) AS unique_policies
FROM autoclaims_cleaned;

-- 7 age distribution
SELECT
MIN(age) AS minimum_age,
MAX(age) AS maximum_age,
AVG(age) AS average_age
FROM autoclaims_cleaned;

-- 8 missing values
SELECT
SUM(age IS NULL) AS missing_age,
SUM(policy_number IS NULL) AS missing_policy_number,
SUM(policy_annual_premium IS NULL) AS missing_premium,
SUM(total_claim_amount IS NULL) AS missing_claim_amount
FROM autoclaims_cleaned;
-- as the data has already been cleaned in excel so all these values are zero

-- 9 incident types
SELECT DISTINCT incident_type
FROM autoclaims_cleaned;

-- 10 gender Distribution
SELECT gender,
       COUNT(*) AS total_customers
FROM autoclaims_cleaned
GROUP BY gender;

-- 11 gender %
SELECT gender,
       COUNT(*) AS total_customers,
       ROUND(COUNT(*) * 100.0 /
       (SELECT COUNT(*) FROM autoclaims_cleaned),2) AS percentage
FROM autoclaims_cleaned
GROUP BY gender;

-- 12 education level distribution
SELECT insured_education_level,
       COUNT(*) AS total_customers
FROM autoclaims_cleaned
GROUP BY insured_education_level
ORDER BY total_customers DESC;

-- 13 occupation distr
SELECT insured_occupation,
       COUNT(*) AS total_customers
FROM autoclaims_cleaned
GROUP BY insured_occupation
ORDER BY total_customers DESC;

-- 14 relationship status
SELECT insured_relationship,
       COUNT(*) AS total_customers
FROM autoclaims_cleaned
GROUP BY insured_relationship
ORDER BY total_customers DESC;

-- 15 state distribution
SELECT policy_state,
       COUNT(*) AS total_policies
FROM autoclaims_cleaned
GROUP BY policy_state
ORDER BY total_policies DESC;

-- 16 avg age of customers and youngest and oldest
SELECT ROUND(AVG(age),2) AS average_age,
MIN(age) AS youngest_customer,
MAX(age) AS oldest_customer
FROM autoclaims_cleaned;

-- 17 list of customers older than average
SELECT policy_number,
       age
FROM autoclaims_cleaned
WHERE age >
(
SELECT AVG(age)
FROM autoclaims_cleaned
)

-- 18 no. of customers older than average
with cte1 as 
(SELECT policy_number,
       age
FROM autoclaims_cleaned
WHERE age >
(
SELECT AVG(age)
FROM autoclaims_cleaned
))
select count(policy_number)
from cte1;

-- 19 age groups 
SELECT
CASE
WHEN age < 30 THEN 'Young'
WHEN age BETWEEN 30 AND 50 THEN 'Middle Age'
ELSE 'Senior'
END AS age_group,

COUNT(*) AS total_customers

FROM autoclaims_cleaned

GROUP BY age_group

ORDER BY total_customers DESC;

-- 20 premium statistics
SELECT
MIN(policy_annual_premium) AS minimum_premium,
MAX(policy_annual_premium) AS maximum_premium,
ROUND(AVG(policy_annual_premium),2) AS average_premium
FROM autoclaims_cleaned;

-- 21 top 10 highest premium policies
SELECT policy_number,
       age,
       insured_occupation,
       policy_annual_premium
FROM autoclaims_cleaned
ORDER BY policy_annual_premium DESC
LIMIT 10;

-- 22 avg prem by state 
SELECT policy_state,
       ROUND(AVG(policy_annual_premium),2) AS average_premium
FROM autoclaims_cleaned
GROUP BY policy_state
ORDER BY average_premium DESC;

-- 23 avg prem by occupation
SELECT insured_occupation,
       ROUND(AVG(policy_annual_premium),2) AS average_premium
FROM autoclaims_cleaned
GROUP BY insured_occupation
ORDER BY average_premium DESC;

-- 24 avg prem by ecuation level
SELECT insured_education_level,
       ROUND(AVG(policy_annual_premium),2) AS average_premium
FROM autoclaims_cleaned
GROUP BY insured_education_level
ORDER BY average_premium DESC;

-- 25 prem distr by gender
SELECT gender,
       COUNT(*) AS total_customers,
       ROUND(AVG(policy_annual_premium),2) AS average_premium
FROM autoclaims_cleaned
GROUP BY gender;

-- 26 premium categories
SELECT
CASE

WHEN policy_annual_premium < 1000 THEN 'Low Premium'

WHEN policy_annual_premium BETWEEN 1000 AND 1500 THEN 'Medium Premium'

ELSE 'High Premium'

END AS premium_category,

COUNT(*) AS total_policies

FROM autoclaims_cleaned

GROUP BY premium_category

ORDER BY total_policies DESC;

-- 27 customers paying above avg prem
SELECT
policy_number,
insured_occupation,
policy_annual_premium

FROM autoclaims_cleaned

WHERE policy_annual_premium >

(
SELECT AVG(policy_annual_premium)
FROM autoclaims_cleaned
)

ORDER BY policy_annual_premium DESC;

-- 28 no. of customers paying above ag prem
with cte2 
as 
(
SELECT
policy_number,
insured_occupation,
policy_annual_premium

FROM autoclaims_cleaned

WHERE policy_annual_premium >

(
SELECT AVG(policy_annual_premium)
FROM autoclaims_cleaned
)

ORDER BY policy_annual_premium DESC
)
select count(policy_number)
from cte2;

-- 29 deductible analysis
SELECT
policy_deductable,
COUNT(*) AS total_policies
FROM autoclaims_cleaned
GROUP BY policy_deductable
ORDER BY total_policies DESC;

-- 30 claim statistics
SELECT
MIN(total_claim_amount) AS minimum_claim,
MAX(total_claim_amount) AS maximum_claim,
ROUND(AVG(total_claim_amount),2) AS average_claim
FROM autoclaims_cleaned;

-- 31 top 10 highest claims
SELECT
policy_number,
insured_occupation,
incident_type,
total_claim_amount
FROM autoclaims_cleaned
ORDER BY total_claim_amount DESC
LIMIT 10;

-- 32 avg claim by state
SELECT
incident_state,
ROUND(AVG(total_claim_amount),2) AS average_claim
FROM autoclaims_cleaned
GROUP BY incident_state
ORDER BY average_claim DESC;

-- 33 avg claim by occupation
SELECT
insured_occupation,
ROUND(AVG(total_claim_amount),2) AS average_claim
FROM autoclaims_cleaned
GROUP BY insured_occupation
ORDER BY average_claim DESC;

-- 34 incident severity and claim
SELECT
incident_severity,
COUNT(*) AS total_claims,
ROUND(AVG(total_claim_amount),2) AS average_claim
FROM autoclaims_cleaned
GROUP BY incident_severity
ORDER BY average_claim DESC;

-- 35 fraud distribution and %
SELECT
fraud_reported,
COUNT(*) AS total_cases,
ROUND(
COUNT(*)*100.0/
(SELECT COUNT(*) FROM autoclaims_cleaned),
2
) AS percentage
FROM autoclaims_cleaned
GROUP BY fraud_reported;

-- 36 fraud by inccident type
SELECT
incident_type,
COUNT(*) AS total_cases
FROM autoclaims_cleaned
WHERE fraud_reported='Y'
GROUP BY incident_type
ORDER BY total_cases DESC;

-- 37 fraud by incident severity
SELECT
incident_severity,
COUNT(*) AS fraudulent_claims
FROM autoclaims_cleaned
WHERE fraud_reported='Y'
GROUP BY incident_severity
ORDER BY fraudulent_claims DESC;

-- 38 avg claim for fraudalent and real claims
SELECT
fraud_reported,
ROUND(AVG(total_claim_amount),2) AS average_claim
FROM autoclaims_cleaned
GROUP BY fraud_reported;

 -- policy summary using view fn
CREATE VIEW policy_summary AS

SELECT
policy_number,
gender,
age,
insured_occupation,
policy_state,
policy_annual_premium,
total_claim_amount,
fraud_reported

FROM autoclaims_cleaned;

SELECT *
FROM policy_summary;

-- age group which has the highest claim amt 
WITH age_groups AS
(
SELECT
CASE
WHEN age <30 THEN 'Young'
WHEN age BETWEEN 30 AND 50 THEN 'Middle Age'
ELSE 'Senior'
END AS age_group,
total_claim_amount
FROM autoclaims_cleaned
)
SELECT
age_group,
ROUND(AVG(total_claim_amount),2) AS average_claim
FROM age_groups
GROUP BY age_group
ORDER BY average_claim DESC;

-- ranking policy holders
SELECT
policy_number,
incident_state,
total_claim_amount,
RANK() OVER
(
ORDER BY total_claim_amount DESC
)
AS claim_rank
FROM autoclaims_cleaned;

-- ranking states partitioned by state 
SELECT
policy_number,
incident_state,
total_claim_amount,
RANK() OVER
(
PARTITION BY incident_state
ORDER BY total_claim_amount DESC
)
AS state_rank
FROM autoclaims_cleaned;

-- stored procedure, all claims above 80000
DELIMITER //
CREATE PROCEDURE GetHighClaims
(
IN claim_limit DECIMAL(10,2)
)
BEGIN
SELECT
policy_number,
insured_occupation,
total_claim_amount
FROM autoclaims_cleaned
WHERE total_claim_amount >= claim_limit
ORDER BY total_claim_amount DESC;
END //
DELIMITER ;

CALL GetHighClaims(80000);
 