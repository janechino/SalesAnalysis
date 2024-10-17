# Customer Sales Analysis
## Data analysis Internship task by CodeBugAI


### Project Overview

This data analysis report aims to provide insights into customer behavior, sales trends, and business performance. This type of analysis typically explores various aspects such as purchasing patterns, product preferences, payment methods, and customer segmentation. It also uncovers sales trends over time, helping businesses understand peak seasons, high-demand products, and the effectiveness of sales channels (e.g., online vs. Offline).

Additionally, customer sales analysis can provide insights into customer lifetime value (CLV), helping businesses target high-value customers for loyalty programs or personalized marketing. 

By leveraging the results of a customer sales analysis, businesses can make data-driven decisions to enhance their marketing efforts, tailor product offerings, and ultimately boost revenue. This analysis is invaluable for strategic planning, resource allocation, and maximizing the overall customer experience.


### Dataset

#### Data source
- Sales Data: The primary dataset used for this analysis is the [Online Shop Customer Sales Data (8).csv](https://www.kaggle.com/datasets/onlineretailshop/online-shop-customer-sales-data)
- Customer Segmentation Data: The primary dataset used for this analysis is the [shopping_behavior_updated Data.csv](https://www.kaggle.com/datasets/zeesolver/consumer-behavior-and-shopping-habits-dataset)
- Customer Sales Data: The primary dataset used for this analysis is the [shopping_trends.csv]((https://www.kaggle.com/datasets/iamsouravbanerjee/customer-shopping-trends-dataset?select=shopping_trends.csv))

#### Main columns/features:
- Sales.Channel: Channel through which the sale was made
- Product.Category: Category of the products sold
- Subscription.Status: Membership or normal status of customers
- Pay.Method: Method used for payments (cash, card, etc.)
- Age: Helps in segmenting customers by age groups, analyzing purchasing behavior by age, and targeting specific age demographics in marketing.
- Gender: Analyzes differences in purchasing patterns between genders and assists in creating gender-targeted marketing strategies.
- Total.Revenue: Measures sales performance, evaluates product profitability, and determines customer value for the business.
- Season:  Identifies seasonal sales trends and product demand fluctuations, helping with inventory and promotional planning.


### Project Objectives
- Analyze Sales Growth.
- Identify Customer's Retention Rate.
- Understand customer buying patterns.
- Analyze the performance of different sales channels.


### Analysis Steps

In the Initial data preparation phase, the following Task was performed;
1. #### Data loading and Inpsection
   
2. #### Data Cleaning:
   - Renaming Each file's column to ensure it is consistent with each other.
   - Removing NA Values.
   - Reomving Duplicates.
 
3. ####  Exploratory Data Analysis (EDA):
   - Identified the Total Revenue by Customer Gender according to their Subscription Status.
   - Analyzed trends in customer purchasing habits.
   - Visualized the distribution of sales channels and product categories.
   - Visualized Customer Retention (Member vs Normal).
   - Visualized Total Revenue by Customer Gender and Subscription Status.

3. #### Statistical Analysis:
   - Analyzed customer retention rate.
   - Performed correlation analysis to identify key factors impacting sales.
   - Segmented customers based on Subscription.Status.


### Tools and Libraries

- R Programming Language: For Data cleaning and Data analysis
- PowerBI: For Dashboarding, Visualizations and reporting
- Libraries: ggplot2 (R), tidyverse ,readr, lubridate, dplyr etc.
