import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# STEP ONE: Install & Import Necessary Libraries

# STEP TWO: Upload Customer Sales Data (CSV files)
Q1 = pd.read_csv("C:/Users/USER-PC/Downloads/Online Shop Customer Sales Data (8).csv")
Q2 = pd.read_csv("C:/Users/USER-PC/Downloads/shopping_behavior_updated (1).csv")
Q9 = pd.read_csv("C:/Users/USER-PC/Downloads/shopping_trends.csv")

# Checking file structure
print(Q1.info())
print(Q2.info())
print(Q9.info())

# STEP THREE: Data Wrangling
# Reassign "Not Subscribed" to "Normal" and "Subscribed" to "Member"
Q1["Subscription.Status"] = Q1["Newsletter"].replace({"Not Subscribed": "Normal", "Subscribed": "Member"})

# Convert Date column to datetime format
Q1["Purchase_DATE"] = pd.to_datetime(Q1["Purchase_DATE"], dayfirst=True)

# Extracting Date Components
Q1["year"] = Q1["Purchase_DATE"].dt.year
Q1["month"] = Q1["Purchase_DATE"].dt.month_name()
Q1["day"] = Q1["Purchase_DATE"].dt.day
Q1["day_of_week"] = Q1["Purchase_DATE"].dt.day_name()

# Assign Seasons
seasons = {
    "December": "Winter", "January": "Winter", "February": "Winter",
    "March": "Spring", "April": "Spring", "May": "Spring",
    "June": "Summer", "July": "Summer", "August": "Summer",
    "September": "Autumn", "October": "Autumn", "November": "Autumn"
}
Q1["Season"] = Q1["month"].map(seasons)

# Renaming Columns for Consistency
Q1.rename(columns={
    "Customer_id": "Customer.ID",
    "Revenue_Total": "Total.Revenue",
    "Pay_Method": "Pay.Method"
}, inplace=True)

Q2.rename(columns={
    "Purchase.Amount..USD.": "Total.Revenue",
    "Shipping.Type": "Sales.Channel",
    "Payment.Method": "Pay.Method"
}, inplace=True)

Q9.rename(columns={
    "Customer ID": "Customer.ID",
    "Purchase Amount (USD)": "Total.Revenue",
    "Shipping Type": "Sales.Channel",
    "Subscription Status": "Subscription.Status",
    "Payment Method": "Pay.Method"
}, inplace=True)

# Standardizing Gender Values
Q1["Gender"] = Q1["Gender"].replace({0: "Male", 1: "Female", 2: "Other"})

# Standardizing Payment Method Names
payment_mapping = {0: "Digital wallets", 1: "Card", 2: "Paypal", 3: "Other"}
Q1["Pay.Method"] = Q1["Pay.Method"].replace(payment_mapping)

# Standardizing Subscription Status in Q2 and Q9
Q2["Subscription.Status"] = Q2["Subscription.Status"].replace({"Yes": "Member", "No": "Normal"})
Q9["Subscription.Status"] = Q9["Subscription.Status"].replace({"Yes": "Member", "No": "Normal"})

# Standardizing Sales Channel Values
Q2["Sales.Channel"] = Q2["Sales.Channel"].replace({
    "Day Shipping": "Online", "Express": "Online", "Free Shipping": "Online",
    "Next Day Air": "Online", "Standard ": "Online", "Store Pickup": "Offline"
})

# Ensure Data Types are Consistent
Q2["Total.Revenue"] = pd.to_numeric(Q2["Total.Revenue"], errors='coerce')
Q9["Age"] = Q9["Age"].astype(int)
Q9["Customer.ID"] = Q9["Customer.ID"].astype(int)

# Assigning All Sales Channel in Q1 to "Online"
Q1["Sales.Channel"] = "Online"

# Dropping Unnecessary Columns
Q1.drop(columns=["N_Purchases", "Purchase_DATE", "Purchase_VALUE", "Browser", "Newsletter", "Voucher"], inplace=True)
Q2.drop(columns=["Item.Purchased", "Size", "Color", "Review.Rating", "Discount.Applied", "Promo.Code.Used"], inplace=True)
Q9.drop(columns=["Item Purchased", "Location", "Size", "Color", "Review Rating", "Discount Applied"], inplace=True)

# Combining Data into One Dataset
Sales_Data = pd.concat([Q1, Q2, Q9], ignore_index=True)

# Removing NA Values
Sales_Data.dropna(inplace=True)

# Removing Duplicates
Sales_Data.drop_duplicates(inplace=True)

# Encoding Categorical Variables
encoder = LabelEncoder()
Sales_Data["Gender"] = encoder.fit_transform(Sales_Data["Gender"])
Sales_Data["Subscription.Status"] = encoder.fit_transform(Sales_Data["Subscription.Status"])
Sales_Data["Sales.Channel"] = encoder.fit_transform(Sales_Data["Sales.Channel"])
Sales_Data["Pay.Method"] = encoder.fit_transform(Sales_Data["Pay.Method"])

# Splitting Data for Prediction
X = Sales_Data[["Gender", "month", "Sales.Channel", "Subscription.Status", "Pay.Method"]]
Y_sales = Sales_Data["Total.Revenue"]  # Target for sales prediction
Y_sub = Sales_Data["Subscription.Status"]  # Target for subscription classification

X_train_sales, X_test_sales, Y_train_sales, Y_test_sales = train_test_split(X, Y_sales, test_size=0.2, random_state=42)
X_train_sub, X_test_sub, Y_train_sub, Y_test_sub = train_test_split(X, Y_sub, test_size=0.2, random_state=42)

# Scaling Features
scaler = StandardScaler()
X_train_sales = scaler.fit_transform(X_train_sales)
X_test_sales = scaler.transform(X_test_sales)
X_train_sub = scaler.fit_transform(X_train_sub)
X_test_sub = scaler.transform(X_test_sub)

# Predictive Model for Sales (Regression)
sales_model = LinearRegression()
sales_model.fit(X_train_sales, Y_train_sales)
Y_pred_sales = sales_model.predict(X_test_sales)

print("Sales Prediction Model Performance:")
print("MAE:", mean_absolute_error(Y_test_sales, Y_pred_sales))
print("MSE:", mean_squared_error(Y_test_sales, Y_pred_sales))
print("R2 Score:", r2_score(Y_test_sales, Y_pred_sales))

# Predictive Model for Subscription Status (Classification)
sub_model = RandomForestClassifier(n_estimators=100, random_state=42)
sub_model.fit(X_train_sub, Y_train_sub)
Y_pred_sub = sub_model.predict(X_test_sub)

print("\nSubscription Prediction Model Performance:")
print("Accuracy:", accuracy_score(Y_test_sub, Y_pred_sub))
print("Classification Report:\n", classification_report(Y_test_sub, Y_pred_sub))

# Descriptive Analysis - Customer Retention Rate
total_customers = len(Sales_Data)
retained_customers = len(Sales_Data[Sales_Data["Subscription.Status"] == "Member"])
retention_rate = (retained_customers / total_customers) * 100
print(f"Customer Retention Rate: {retention_rate:.2f}%")

# Customer Retention Pie Chart
subscription_counts = Sales_Data["Subscription.Status"].value_counts()
plt.pie(subscription_counts, labels=subscription_counts.index, autopct='%1.1f%%', colors=["lightblue", "lightgreen"])
plt.title("Customer Retention (Member vs Normal)")
plt.show()

# Revenue by Gender and Subscription Status
revenue_summary = Sales_Data.groupby(["Gender", "Subscription.Status"])["Total.Revenue"].agg(["mean", "median", "max", "min"])
print(revenue_summary)

# Bar Plot of Total Revenue by Gender & Subscription Status
plt.figure(figsize=(10, 5))
sns.barplot(data=Sales_Data, x="Gender", y="Total.Revenue", hue="Subscription.Status")
plt.title("Total Revenue by Gender and Subscription Status")
plt.show()
