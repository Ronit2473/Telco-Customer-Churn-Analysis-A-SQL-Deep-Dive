# 📞 Telco Customer Churn Analysis: A SQL Deep Dive

# 🎯 Project Goal
 The primary objective of this project is to analyze a comprehensive telecommunications dataset using SQL to identify the key drivers of customer churn. By segmenting customers and calculating churn rates across   various dimensions (contract type, services, tenure, and charges), the analysis provides actionable insights and a prioritized list of at-risk customers for retention efforts.

# 💾 Dataset Overview
Source: This analysis uses the well-known IBM Telco Customer Churn Dataset, commonly found on platforms like Kaggle.

Size: 7,032 customer records.

Key Metrics Calculated: Overall Churn Rate, Average Tenure, Segmentation Churn Rates.

# 🛠️ Tools and Technologies
Database: MySQL (or any SQL-compliant database system)

Language: SQL (specifically MySQL syntax for functions like DATE_FORMAT, ROUND, and CASE)

# 📊 Key Findings & Business Insights
 The analysis identified stark differences in churn behavior, pointing to critical areas for immediate intervention:
<img src="Summarized_tables_images/Screenshot 2025-10-25 195524.png" alt="Alt Text" width="500" height="300"/>

# 💡 Strategic Recommendations
Based on the SQL analysis, the following actions are recommended to reduce customer churn:

 1. Contract Conversion & Onboarding: Focus retention budget on moving Month-to-month customers to longer contracts, especially during the first year of their service. Offer incentives like free Tech Support to new customers to increase their service count and "stickiness."

 2. Fix Fiber Optic Quality: Immediately investigate the quality, reliability, or pricing model of the Fiber Optic internet service, as it is the single greatest service-related driver of customer dissatisfaction.

 3. Proactive High-Value Retention: Use the output from Query 13 (Highest-Priority Retention List) to initiate personalized, proactive outreach to high-value customers who exhibit high-risk behaviors (e.g., high monthly charge, month-to-month, no security). The focus should be on adding value rather than offering a discount.

# 📂 Project Files and Queries
The analysis is broken down into 13 key queries, each answering a specific business question.
<img src="C:\Users\abc\Pictures\Screenshots\Screenshot 2025-10-25 200004.png" alt="Alt Text" width="500" height="300"/>
# churn_analysis.sql
# Contains the complete, commented SQL scripts for all 13 queries.

# 🔗 Dataset Link
[https://www.kaggle.com/datasets/blastchar/telco-customer-churn]



