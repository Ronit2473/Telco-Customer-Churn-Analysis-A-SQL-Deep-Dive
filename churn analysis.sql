create database customer_churn;
use customer_churn;

CREATE TABLE telco_customers (
    customerID VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(3),
    Dependents VARCHAR(3),
    tenure INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges FLOAT,
    TotalCharges FLOAT,
    Churn VARCHAR(3)
);

select * from telco_customers;

/*Query 1: Total Customers & Churn Rate*/

select 
	count(*) as total_customers,
    sum(case when churn='yes' then 1 else 0 end) as churned_customers,
    round(sum(case when churn='yes' then 1 else 0 end) *100/count(*),2) as churn_rate_percentage
from telco_customers;


/*Query 2: Average Tenure of Active vs Churned Customers*/
select * from telco_customers;
SELECT 
    Churn,
    ROUND(AVG(tenure), 2) AS avg_tenure_months
FROM telco_customers
GROUP BY Churn;

/*Query 3: Average Monthly Charges by Contract Type*/
select distinct contract from telco_customers;
SELECT 
    Contract,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telco_customers
GROUP BY Contract
ORDER BY churn_rate DESC;

/*Query 4: Churn Rate by Internet Service Type*/
SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telco_customers
GROUP BY InternetService
ORDER BY churn_rate DESC;


/*Query 5: Senior Citizen Churn Rate*/

SELECT 
    SeniorCitizen,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telco_customers
GROUP BY SeniorCitizen;

/*Query 6: Payment Method Influence on Churn*/

SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telco_customers
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;


/*Query 7: Correlation Between Monthly Charges and Churn*/

SELECT 
    CASE 
        WHEN MonthlyCharges < 35 THEN 'Low (<$35)'
        WHEN MonthlyCharges BETWEEN 35 AND 70 THEN 'Medium ($35-$70)'
        ELSE 'High (>$70)'
    END AS charge_category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telco_customers
GROUP BY charge_category
ORDER BY churn_rate DESC;


/*Query 8: Services Impact on Churn*/

SELECT 
    InternetService,
    OnlineSecurity,
    TechSupport,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telco_customers
GROUP BY InternetService, OnlineSecurity, TechSupport
ORDER BY churn_rate DESC
LIMIT 10;


/*Query 9: Churn Rate by Contract Duration & Tenure*/
SELECT 
    Contract,
    CASE 
        WHEN tenure < 12 THEN 'New (<1 year)'
        WHEN tenure BETWEEN 12 AND 36 THEN 'Mid-term (1-3 years)'
        ELSE 'Loyal (>3 years)'
    END AS tenure_category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telco_customers
GROUP BY Contract, tenure_category
ORDER BY churn_rate DESC;

/*Query 10: Gender-Wise Churn Comparison*/
SELECT 
    gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telco_customers
GROUP BY gender;

/*Query 11:Churn Rate Based on the Number of Extra Services*/
SELECT
    Total_Extra_Services,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM (
    SELECT
        *,
        (
            CASE WHEN OnlineSecurity != 'No' THEN 1 ELSE 0 END +
            CASE WHEN OnlineBackup != 'No' THEN 1 ELSE 0 END +
            CASE WHEN DeviceProtection != 'No' THEN 1 ELSE 0 END +
            CASE WHEN TechSupport != 'No' THEN 1 ELSE 0 END +
            CASE WHEN StreamingTV != 'No' THEN 1 ELSE 0 END +
            CASE WHEN StreamingMovies != 'No' THEN 1 ELSE 0 END
        ) AS Total_Extra_Services
    FROM telco_customers
) AS Service_Count_Table
GROUP BY Total_Extra_Services
ORDER BY Total_Extra_Services DESC;


/*Query 12: Identifying High-Value, High-Risk Customers (Tenure vs Total Charges)*/

WITH Customer_Value_Risk AS (
    SELECT
        customerID,
        tenure,
        TotalCharges,
        Churn,
        CASE
            WHEN TotalCharges > (SELECT AVG(TotalCharges) FROM telco_customers) THEN 'High-Value'
            ELSE 'Low-Value'
        END AS Value_Segment,
        CASE
            WHEN tenure <= 6 THEN 'High-Risk (New)'
            ELSE 'Low-Risk (Established)'
        END AS Risk_Segment
    FROM telco_customers
)
SELECT
    Value_Segment,
    Risk_Segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM Customer_Value_Risk
GROUP BY Value_Segment, Risk_Segment
ORDER BY Value_Segment DESC, churn_rate DESC;

/* Query 15: Impact of Having a Partner and/or Dependents*/

SELECT
    CONCAT(Partner, ' Partner, ', Dependents, ' Dependents') AS Relationship_Group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telco_customers
GROUP BY Relationship_Group
ORDER BY churn_rate DESC;


/* Query 13: Identifying the Highest-Priority Retention Target Group*/
SELECT
    customerID,
    MonthlyCharges,
    tenure,
    Contract,
    OnlineSecurity,
    TechSupport
FROM telco_customers
WHERE
    Churn = 'No' -- Focus on customers who haven't left YET
    AND Contract = 'Month-to-month' -- High-risk contract type
    AND MonthlyCharges >= (SELECT AVG(MonthlyCharges) FROM telco_customers) -- High-value
    AND TechSupport = 'No'
    AND OnlineSecurity = 'No'
ORDER BY MonthlyCharges DESC
LIMIT 50; -- The top 50 customers the company should contact immediately







    
