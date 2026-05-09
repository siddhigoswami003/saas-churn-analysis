-- ============================================================
-- PROJECT: SaaS Customer Churn Analysis
-- Dataset: IBM Telco Customer Churn (7,043 customers)
-- Tool: SQLite / DB Browser for SQLite
-- Author: Siddhi Goswami
-- Date: May 2026
-- ============================================================
-- BUSINESS CONTEXT:
-- This analysis investigates customer churn at a telecom/SaaS
-- company to identify the highest-risk customer segments,
-- quantify the annual revenue impact, and produce actionable
-- retention recommendations for stakeholders.
-- ============================================================


-- ============================================================
-- QUERY 1: Overall Churn Rate
-- ============================================================
-- Business Question: What is the baseline churn rate?
-- How severe is the churn problem at an aggregate level?
-- Key Finding: 26.54% overall churn rate across 7,043 customers
-- -- nearly 4x the industry benchmark of 5-7% for SaaS companies.
-- 1,869 customers have churned.
-- ============================================================

SELECT 
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as churn_rate_pct
FROM customers;


-- ============================================================
-- QUERY 2: Churn Rate by Contract Type
-- ============================================================
-- Business Question: Does contract type predict churn?
-- Which contract type represents the highest retention risk?
-- Key Finding: Month-to-month customers churn at 42.71% --
-- 15x the rate of two-year contract customers at 2.83%.
-- With 3,875 customers on month-to-month contracts, this is
-- the single largest and most actionable churn driver.
-- ============================================================

SELECT 
    Contract,
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as churn_rate_pct
FROM customers
GROUP BY Contract
ORDER BY churn_rate_pct DESC;


-- ============================================================
-- QUERY 3: Churn Rate by Customer Tenure Cohort
-- ============================================================
-- Business Question: When in the customer lifecycle does churn
-- occur most frequently? What is the highest-risk time window?
-- Key Finding: 52.94% of customers churn within their first
-- 6 months -- more than 1 in 2 new customers leave before
-- completing half a year. Churn improves consistently with
-- tenure, dropping to 9.51% for customers 49+ months.
-- The first 6 months are the critical intervention window.
-- ============================================================

SELECT 
    CASE 
        WHEN tenure <= 6  THEN '01: 0-6 Months'
        WHEN tenure <= 12 THEN '02: 7-12 Months'
        WHEN tenure <= 24 THEN '03: 13-24 Months'
        WHEN tenure <= 36 THEN '04: 25-36 Months'
        WHEN tenure <= 48 THEN '05: 37-48 Months'
        ELSE                   '06: 49+ Months'
    END as tenure_group,
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as churn_rate_pct
FROM customers
GROUP BY tenure_group
ORDER BY tenure_group ASC;


-- ============================================================
-- QUERY 4: Churn Rate by Internet Service Type
-- ============================================================
-- Business Question: Does the type of service a customer
-- subscribes to affect their likelihood of churning?
-- Key Finding: Fiber optic customers -- the premium service --
-- churn at 41.89%, more than double DSL at 18.96% and nearly
-- 6x customers with no internet service at 7.4%. This
-- counterintuitive finding suggests an expectation-delivery
-- gap: customers paying the most are the least satisfied.
-- ============================================================

SELECT 
    InternetService,
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as churn_rate_pct
FROM customers
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;


-- ============================================================
-- QUERY 5: Churn Rate by Payment Method
-- ============================================================
-- Business Question: Does payment method serve as a proxy
-- for customer engagement and churn risk?
-- Key Finding: Electronic check customers churn at 45.29% --
-- 3x the rate of automatic payment customers at 15-17%.
-- Manual payment behavior signals disengagement. With 2,365
-- electronic check customers -- the largest payment segment --
-- an auto-pay enrollment campaign is a high-priority action.
-- ============================================================

SELECT 
    PaymentMethod,
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as churn_rate_pct
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;


-- ============================================================
-- QUERY 6: Annual Revenue Lost to Churn
-- ============================================================
-- Business Question: What is the total financial impact of
-- churn? How much revenue is the company losing annually?
-- Key Finding: The company loses $139,130.85 per month and
-- $1,669,570.20 per year to churn. The average churned
-- customer was paying $74.44 per month -- $893.28 annually.
-- This dollar figure establishes the ROI case for any
-- retention program investment.
-- ============================================================

SELECT 
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2) as monthly_revenue_lost,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) * 12, 2) as annual_revenue_lost,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END), 2) as avg_churned_customer_monthly_charge
FROM customers;


-- ============================================================
-- QUERY 7: Churn Rate by Combined Risk Factor Profile
-- ============================================================
-- Business Question: Which combination of contract type,
-- payment method, and internet service produces the highest
-- churn risk? Where is churn risk most concentrated?
-- Key Finding: Month-to-month + Electronic check + Fiber optic
-- is the highest-risk profile at 60.37% churn across 1,307
-- customers. All top 5 highest-churn combinations involve
-- fiber optic, confirming it as a systemic service issue.
-- The HAVING clause filters to groups of 30+ customers
-- to ensure statistical significance.
-- ============================================================

SELECT 
    Contract,
    PaymentMethod,
    InternetService,
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2) as avg_monthly_charge
FROM customers
GROUP BY Contract, PaymentMethod, InternetService
HAVING COUNT(*) > 30
ORDER BY churn_rate_pct DESC
LIMIT 10;


-- ============================================================
-- QUERY 8: Churn Rate by Senior Citizen Status
-- ============================================================
-- Business Question: Are senior customers disproportionately
-- at risk of churning compared to non-senior customers?
-- Key Finding: Senior customers churn at 41.68% -- nearly
-- double the 23.61% rate for non-senior customers -- while
-- paying $79.82/month vs $61.85 for non-seniors. Despite
-- representing only 16% of the customer base, senior churn
-- accounts for approximately $455,757 in annual revenue loss
-- -- 27% of total churn loss. A dedicated senior success
-- program is warranted.
-- ============================================================

SELECT 
    CASE WHEN SeniorCitizen = 1 THEN 'Senior' ELSE 'Non-Senior' END as customer_segment,
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2) as avg_monthly_charge
FROM customers
GROUP BY SeniorCitizen
ORDER BY churn_rate_pct DESC;


-- ============================================================
-- QUERY 9: Revenue at Risk by Customer Value Segment
-- ============================================================
-- Business Question: Which customer value tier represents
-- the greatest revenue risk from churn? Where should
-- retention investment be prioritized for maximum ROI?
-- Key Finding: High-value customers ($70+/month) account for
-- $1,355,772 -- 81% -- of total annual churn revenue loss,
-- despite churning at 35.48%. Retention spend should be
-- overwhelmingly concentrated on this segment. Saving 15%
-- of high-value churners recovers $203,366 annually --
-- more than 3x the total revenue at risk from low-value
-- customers.
-- ============================================================

SELECT 
    CASE 
        WHEN MonthlyCharges >= 70 THEN 'High Value ($70+/month)'
        WHEN MonthlyCharges >= 40 THEN 'Mid Value ($40-69/month)'
        ELSE 'Low Value (Under $40/month)'
    END as value_segment,
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as churn_rate_pct,
    ROUND(AVG(MonthlyCharges), 2) as avg_monthly_charge,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) * 12, 2) as annual_revenue_at_risk
FROM customers
GROUP BY value_segment
ORDER BY avg_monthly_charge DESC;


-- ============================================================
-- QUERY 10: Multi-Factor Customer Risk Scoring Model (CTE)
-- ============================================================
-- Business Question: Can we build a validated risk model that
-- combines multiple churn predictors to score and tier every
-- customer by churn probability?
-- Approach: Two chained CTEs. The first CTE assigns individual
-- risk scores to each customer based on contract type (0-3),
-- payment method (0-2), and tenure (0-3) -- weighted by the
-- churn rates identified in Queries 2, 3, and 5. The second
-- CTE converts total scores into High/Medium/Low risk tiers.
-- The final SELECT validates the model by confirming that
-- High Risk customers actually churn at dramatically higher
-- rates than Low Risk customers.
-- Key Finding: High Risk customers churn at 49.64% -- nearly
-- 10x the 5.1% rate of Low Risk customers. Model validated.
-- $1,164,861 in annual revenue is lost from the High Risk
-- tier alone. 1,384 currently active High Risk customers
-- represent $940,218 in revenue to protect proactively.
-- ============================================================

WITH customer_risk_scores AS (
    SELECT
        customerID,
        Churn,
        MonthlyCharges,
        Contract,
        PaymentMethod,
        tenure,
        CASE
            WHEN Contract = 'Month-to-month' THEN 3
            WHEN Contract = 'One year' THEN 1
            ELSE 0
        END as contract_risk_score,
        CASE
            WHEN PaymentMethod = 'Electronic check' THEN 2
            ELSE 0
        END as payment_risk_score,
        CASE
            WHEN tenure <= 12 THEN 3
            WHEN tenure <= 24 THEN 2
            WHEN tenure <= 48 THEN 1
            ELSE 0
        END as tenure_risk_score
    FROM customers
),

customer_risk_tiers AS (
    SELECT
        customerID,
        Churn,
        MonthlyCharges,
        Contract,
        PaymentMethod,
        tenure,
        (contract_risk_score + payment_risk_score + tenure_risk_score) as total_risk_score,
        CASE
            WHEN (contract_risk_score + payment_risk_score + tenure_risk_score) >= 6 THEN 'High Risk'
            WHEN (contract_risk_score + payment_risk_score + tenure_risk_score) >= 3 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END as risk_tier
    FROM customer_risk_scores
)

SELECT
    risk_tier,
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as actually_churned,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as churn_rate_pct,
    ROUND(SUM(MonthlyCharges) * 12, 2) as annual_revenue_in_tier,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) * 12, 2) as annual_revenue_lost
FROM customer_risk_tiers
GROUP BY risk_tier
ORDER BY churn_rate_pct DESC;


-- ============================================================
-- QUERY 11: Churn Trend Analysis by Tenure Using LAG (CTE + Window Function)
-- ============================================================
-- Business Question: How does churn rate change as customers
-- age? What is the rate of improvement across tenure cohorts
-- and where is the most critical transition point?
-- Approach: One CTE calculates churn rate per tenure cohort.
-- The final SELECT applies the LAG window function to compare
-- each cohort's churn rate to the previous cohort, producing
-- a period-over-period change and trend direction label.
-- LAG(churn_rate_pct, 1, 0) OVER (ORDER BY tenure_group)
-- looks back one row in chronological order to retrieve the
-- previous cohort's churn rate for comparison.
-- Key Finding: The single largest churn improvement occurs
-- between months 0-6 and months 7-12 -- a drop of 17.05
-- percentage points. Customers who survive the first 6 months
-- show dramatically improved retention at every subsequent
-- period. All retention investment should be front-loaded
-- into the first 6 months of the customer lifecycle.
-- ============================================================

WITH tenure_churn_rates AS (
    SELECT
        CASE
            WHEN tenure <= 6  THEN '01: 0-6 Months'
            WHEN tenure <= 12 THEN '02: 7-12 Months'
            WHEN tenure <= 24 THEN '03: 13-24 Months'
            WHEN tenure <= 36 THEN '04: 25-36 Months'
            WHEN tenure <= 48 THEN '05: 37-48 Months'
            ELSE                   '06: 49+ Months'
        END as tenure_group,
        COUNT(*) as total_customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned_customers,
        ROUND(
            100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2) as churn_rate_pct
    FROM customers
    GROUP BY tenure_group
)

SELECT
    tenure_group,
    total_customers,
    churned_customers,
    churn_rate_pct,
    LAG(churn_rate_pct, 1, 0) OVER (ORDER BY tenure_group) as previous_group_churn_rate,
    ROUND(
        churn_rate_pct - LAG(churn_rate_pct, 1, 0) OVER (ORDER BY tenure_group),
    2) as churn_rate_change,
    CASE
        WHEN churn_rate_pct < LAG(churn_rate_pct, 1, 0) OVER (ORDER BY tenure_group)
            THEN 'Improving'
        WHEN churn_rate_pct > LAG(churn_rate_pct, 1, 0) OVER (ORDER BY tenure_group)
            THEN 'Worsening'
        ELSE 'No Change'
    END as trend
FROM tenure_churn_rates
ORDER BY tenure_group;


-- ============================================================
-- QUERY 12: High-Value At-Risk Customer Priority List (CTE + Window Function)
-- ============================================================
-- Business Question: Which specific currently active customers
-- represent the highest revenue at risk and should be
-- contacted first by the retention team? What specific
-- intervention should each customer receive?
-- Approach: Two chained CTEs. The first CTE isolates active
-- high-value at-risk customers: not yet churned, month-to-
-- month contract, tenure 24 months or less, monthly charge
-- $60 or more. The second CTE applies two ROW_NUMBER window
-- functions -- one ranking within internet service type using
-- PARTITION BY, one ranking overall -- to prioritize customers
-- by revenue value. The final SELECT assigns a specific
-- recommended action to each customer based on their
-- individual risk profile combination.
-- Key Finding: The top 20 highest-value at-risk customers are
-- exclusively fiber optic subscribers -- validating fiber
-- optic as the central driver of high-value customer churn.
-- Each customer receives a tailored retention action rather
-- than a generic intervention, enabling precise and efficient
-- outreach by the customer success team.
-- ============================================================

WITH high_value_customers AS (
    SELECT
        customerID,
        Contract,
        tenure,
        MonthlyCharges,
        PaymentMethod,
        InternetService,
        Churn,
        ROUND(MonthlyCharges * 12, 2) as estimated_annual_value
    FROM customers
    WHERE Churn = 'No'
      AND Contract = 'Month-to-month'
      AND tenure <= 24
      AND MonthlyCharges >= 60
),

ranked_customers AS (
    SELECT
        customerID,
        Contract,
        tenure,
        MonthlyCharges,
        estimated_annual_value,
        PaymentMethod,
        InternetService,
        ROW_NUMBER() OVER (
            PARTITION BY InternetService
            ORDER BY MonthlyCharges DESC
        ) as rank_within_service_type,
        ROW_NUMBER() OVER (
            ORDER BY MonthlyCharges DESC
        ) as overall_rank
    FROM high_value_customers
)

SELECT
    overall_rank,
    customerID,
    InternetService,
    rank_within_service_type,
    Contract,
    tenure as months_as_customer,
    MonthlyCharges as monthly_charge,
    estimated_annual_value,
    PaymentMethod,
    CASE
        WHEN PaymentMethod = 'Electronic check' AND tenure <= 12
            THEN 'PRIORITY: Offer auto-pay discount + annual contract upgrade'
        WHEN PaymentMethod = 'Electronic check'
            THEN 'Offer auto-pay enrollment incentive'
        WHEN tenure <= 12
            THEN 'Enroll in onboarding touchpoint program'
        ELSE 'Offer annual contract discount'
    END as recommended_action
FROM ranked_customers
WHERE overall_rank <= 20
ORDER BY overall_rank;