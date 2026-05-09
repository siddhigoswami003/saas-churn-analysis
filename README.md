# SaaS Customer Churn Analysis — Retention Risk & Revenue Impact

> **This telecom company is losing $1,669,570 annually to preventable customer churn — nearly 4x the industry benchmark. This analysis identifies who is leaving, why, and exactly what to do about it.**

---

## Business Context

A B2B SaaS telecommunications company is losing $1,669,570 annually to preventable customer churn. At a 26.54% overall churn rate — nearly 4x the industry benchmark of 5-7% for SaaS businesses — the company is churning roughly 1 in 4 customers every year.

This analysis identifies the highest-risk customer segments, quantifies the revenue impact of each risk factor, validates a multi-factor churn risk model across 7,043 customers, and produces a prioritized set of retention recommendations with projected revenue recovery estimates.

---

## My Role

I acted as the lead business analyst on this project: independently scoped the business problem, designed the analytical framework, wrote all SQL queries, built and published the Tableau dashboard, and produced this stakeholder-ready README and executive summary. All analysis was conducted without direction — from problem identification through recommendation delivery.

---

## Tools Used

- **SQL** (SQLite / DB Browser for SQLite) — data analysis and querying
- **Tableau Public** — dashboard design and visualization
- **Microsoft Excel** — data validation

---

## Dataset

- **Source:** IBM Telco Customer Churn Dataset via Kaggle
- **Size:** 7,043 customer records
- **Variables:** 21 columns including demographics, service subscriptions, contract details, payment method, tenure, monthly charges, and churn outcome
- **Time period:** Cross-sectional snapshot

---

## Key Findings

**1. Overall Churn Rate: 26.54%**
1,869 customers lost annually, generating $1,669,570 in revenue loss at an average of $74.44 per churned customer per month — nearly 4x the SaaS industry benchmark of 5-7%.

**2. Contract Type Is the Strongest Predictor**
Month-to-month customers churn at 42.71% — 15x the rate of two-year contract customers at 2.83%. With 3,875 customers on month-to-month contracts, this is the single largest and most actionable churn driver in the business.

**3. The First 6 Months Are the Critical Intervention Window**
52.94% of customers churn within their first 6 months — more than 1 in 2 new customers leave before completing half a year. A LAG window function trend analysis confirmed the steepest improvement occurs between months 0-6 and 7-12 — a 17.05 percentage point drop — identifying the first 6 months as the highest-priority retention window.

**4. Fiber Optic Is a Systemic Problem**
Fiber optic customers churn at 41.89% — more than double the DSL rate of 18.96% — despite being the premium, highest-priced service. All top 5 highest-churn customer profiles involve fiber optic internet, confirming a service expectation-delivery gap independent of contract type or payment method.

**5. Payment Method Signals Disengagement**
Electronic check customers churn at 45.29% — 3x the rate of automatic payment customers at 15-17%. With 2,365 electronic check customers representing the largest payment segment, manual payment behavior is a reliable proxy for customer disengagement.

**6. High-Value Customers Carry 81% of Revenue Risk**
Customers paying $70+ per month churn at 35.48% and account for $1,355,772 — 81% — of total annual churn revenue loss. Retention investment concentrated on this segment produces the highest ROI per dollar spent.

**7. Risk Model Validated**
A multi-factor risk scoring model built using chained CTEs — weighting contract type, payment method, and tenure — confirmed that High Risk customers churn at 49.64% — nearly 10x the 5.1% rate of Low Risk customers. 1,384 currently active High Risk customers represent $940,218 in revenue to protect proactively before they churn.

**8. Highest-Risk Profile Identified**
Month-to-month + Electronic check + Fiber optic customers churn at 60.37% across 1,307 customers — representing approximately $824,600 in annual revenue loss from a single customer profile combination.

---

## Recommendations

**1. Launch a Contract Upgrade Campaign (Highest Priority)**
- **Target:** All month-to-month customers in their first 90 days of tenure
- **Action:** Offer a 10-15% discount to switch from month-to-month to an annual contract
- **Rationale:** Month-to-month customers churn at 42.71% vs 2.83% for two-year customers. Converting even 10% of month-to-month customers to annual contracts removes 387 customers from the highest-risk category

**2. Implement an Auto-Pay Enrollment Incentive**
- **Target:** All electronic check customers, prioritizing those with tenure under 24 months
- **Action:** Offer a one-time bill credit ($10-20) for customers who switch from electronic check to any automatic payment method
- **Rationale:** Electronic check customers churn at 45.29% vs 15-17% for automatic payment customers. Auto-pay enrollment reduces friction and increases passive commitment to the service

**3. Build a Fiber Optic Onboarding Program**
- **Target:** All new fiber optic customers in their first 90 days
- **Action:** Implement structured 30/60/90-day check-in calls, proactive technical support outreach, and satisfaction surveys at each milestone
- **Rationale:** Fiber optic customers churn at 41.89% despite paying premium prices, suggesting an expectation-delivery gap at signup. Early intervention before dissatisfaction crystallizes is significantly cheaper than win-back campaigns after churn

**4. Prioritize Retention Spend on High-Value Customers**
- **Target:** Customers paying $70+ per month on month-to-month contracts with tenure under 24 months
- **Action:** Assign dedicated customer success coverage to the top 100 highest-value at-risk customers identified in the SQL priority list
- **Rationale:** High-value customers represent 81% of total annual revenue at risk. The SQL analysis produced a ranked priority list of at-risk customers with individual recommended actions for each

---

## Projected Business Impact

A combined retention program targeting the four recommendations above is projected to reduce churn by 20-30%, recovering:

| Scenario | Churn Reduction | Annual Revenue Recovered |
|---|---|---|
| Conservative | 20% improvement | $333,914 |
| Moderate | 30% improvement | $500,871 |

**Program ROI:** Industry standard retention program costs range from $50,000-150,000 annually for a company of this size — against a potential recovery of $333,000-500,000. Every dollar invested in retention at this churn rate returns $2.20-$3.30.

---

## Dashboard

**View the interactive Tableau dashboard here:**
https://public.tableau.com/app/profile/siddhi.goswami/viz/TelCoSaaSChurnAnalysis/ChurnAnalysisDashboard?publish=yes

Dashboard includes:
- Annual revenue lost to churn (KPI headline)
- Churn rate by contract type
- Churn rate by customer tenure cohort
- Churn rate by payment method
- Churn rate by internet service type
- Key recommendations summary

---

## SQL Analysis

All 12 queries are documented in `churn_analysis_queries.sql` with business context comments above each query explaining:
- The business question being answered
- What the query is doing technically
- The key finding with the actual result

**SQL techniques demonstrated:**
- `CASE WHEN` aggregations for conditional counting and revenue calculations
- `GROUP BY` with multiple dimensions for segment analysis
- `HAVING` for statistically significant group filtering
- `UNION ALL` for executive summary views
- **CTEs (Common Table Expressions)** — chained multi-step analytical logic
- **Window Functions** — `LAG()` for period-over-period trend analysis
- **Window Functions** — `ROW_NUMBER()` with `PARTITION BY` for ranked customer prioritization

---
## Repository Structure

```
saas-churn-analysis/
│
├── churn_analysis_queries.sql    # All 12 SQL queries with business context comments
├── executive_summary.pdf         # 1-page stakeholder-ready summary
├── dashboard_preview.png         # Screenshot of published Tableau dashboard
└── README.md                     # This file
```
---

## About This Project

This project was built as part of a business analyst portfolio to demonstrate end-to-end analytical capability — from raw data to stakeholder-ready deliverables. The analysis mirrors the type of work a BA would produce in a real customer success, revenue operations, or growth analytics role.

*Dataset: IBM Telco Customer Churn via Kaggle | Tools: SQL, Tableau Public | Author: Siddhi Goswami*
