### STEP 1: INSTALL PACKAGES

library(tidyverse)
library(ggplot2)
library(readr)
library(lubridate)
library(dplyr)


## Upload Customer Sales Data (csv files) here
Q1 <- read.csv("C:/Users/USER-PC/Downloads/Online Shop Customer Sales Data (8).csv")
Q2 <- read.csv("C:/Users/USER-PC/Downloads/shopping_behavior_updated (1).csv")
Q9 <- read_csv("C:/Users/USER-PC/Downloads/shopping_trends.csv")




# Comparing file structure and column names of each files, to ensure they match perfectly
colnames(Q1)
colnames(Q2)
colnames(Q9)
str(Q1)
str(Q2)
str(Q9)




# Reassigning "Not Subscribed" to "Normal" and "Subscribed" to "Member"
  Q1$Subscription.status <- ifelse(Q1$Newsletter %in% c("Not Subscribed"), "Normal",
                     ifelse(Q1$Newsletter %in% c("Subscribed"), "Member",
                     NA))


table(Q1$Subscription.status) # Checking the tables for Subscription.Satus to ensure it is changed



#Converting the Date from Chr to DATE format
Q1$Purchase_DATE <- dmy(Q1$Purchase_DATE)



Q1$date <- as.Date(Q1$Purchase_DATE) #The default format is yyyy-mm-dd
Q1$month <- format(as.Date(Q1$Purchase_DATE), "%m")
Q1$day <- format(as.Date(Q1$Purchase_DATE), "%d")
Q1$year <- format(as.Date(Q1$Purchase_DATE), "%Y")
Q1$day_of_week <- format(as.Date(Q1$Purchase_DATE), "%A")



Q1$month <- as.numeric(Q1$month)   # Converting "month" to numeric

Q1$month <- month.name[Q1$month]   #Converting the month(1,2,3...) to be month(January, Febuary,  March...)



# Reassign "month" names as seasons
Q1$Season <- ifelse(Q1$month %in% c("December", "January", "February"), "Winter",
                    ifelse(Q1$month %in% c("March", "April", "May"), "Spring",
                    ifelse(Q1$month %in% c("June", "July", "August"), "Summer",
                    ifelse(Q1$month %in% c("September", "October", "November"), "Autumn", NA))))


## Renaming Each file's column to ensure it is consistent with each other


 ## Renaming for Q1 Data
Q1 <- rename(Q1,
  Customer.ID = Customer_id,
  Age = Age,
  Gender = Gender,
  Total.Revenue = Revenue_Total,
  Season = Season,
  Sales.Channel = Time_Spent,
  Subscription.Status = Subscription.status,
  Pay.Method = Pay_Method,
  Product.Category = NULL
)

# Renaming for Q2 Data
Q2 <- rename(Q2,
  Customer.ID = Customer.ID,
  Age = Age,
  Gender = Gender,
  Total.Revenue = Purchase.Amount..USD.,
  Season = Season,
  Sales.Channel = Shipping.Type,
  Subscription.Status = Subscription.Status,
  Pay.Method = Payment.Method,
  Product.Category = Category
)

# Renaming for Q9 Data
Q9 <- rename(Q9,
  Customer.ID = 'Customer ID',
  Age = Age,
  Gender = Gender,
  Total.Revenue = 'Purchase Amount (USD)',
  Season = Season,
  Sales.Channel = 'Shipping Type',
  Subscription.Status = 'Subscription Status',
  Pay.Method = 'Payment Method',
  Product.Category = Category
)



#checking the structure to confirm
str(Q1)
str(Q2)
str(Q9)
table(Q1$Gender)
table(Q2$Gender)
table(Q9$Gender)



 # Reassigning the gender in Q1 data from "0", "1", "2" to become "Male", "female" and "Other
Q1 <- Q1 %>%
  mutate(Gender = case_when(
    Gender == 0 ~ "Male",
    Gender == 1 ~ "Female",
   Gender== 2 ~ "Other",
    TRUE ~ as.character(Gender)
  ))

# Rename values in Payment_method to Correspond to Orignal Data Description
Q1 <- Q1 %>%
  mutate(Pay.Method = case_when(
    Pay.Method == 0 ~ "Digital wallets",
    Pay.Method == 1 ~ "Card",
    Pay.Method == 2 ~ "Paypal",
    Pay.Method == 3 ~ "Other",
    TRUE ~ as.character(Pay.Method)
  ))




table(Q2$Sales.Channel)  # Checking how many observations that falls under Sales.Channel


# Rename values in Customer.Type in Q2
  Q2 <- Q2 %>%
  mutate(Subscription.Status = recode(Subscription.Status
                                ,"Yes" = "Member"
                                ,"No" = "Normal"))
  
 
  
  
  # Assigning each Observation according to their Sales Channel needed for analysis
  Q2 <- Q2 %>%
  mutate(Sales.Channel = recode(Sales.Channel
                                ,"Day Shipping" = "Online"
                                ,"Express" = "Online"
                                ,"Free Shipping" = "Online"
                                ,"Next Day Air" = "Online"
                                , "Standard " = "Online"
                                , "Store Pickup" = "Offline"))
  


  
Q2$Total.Revenue  <- as.numeric(Q2$Total.Revenue) # Converting Total revenue in Q2 data from Integer to numeric




 #Rename values in for the Subscription Status, Converting Age from numeric to integer and converting Customer. ID from numeric to integer in Q9 data
  Q9 <- Q9 %>%
  mutate(Subscription.Status = recode(Subscription.Status
                                ,"Yes" = "Member"
                                ,"No" = "Normal"))


Q9$Age  <- as.integer(Q9$Age)
Q9$Customer.ID  <- as.integer(Q9$Customer.ID)



# Changing all values in Sales Channel to be Online since the inial values showed "Time Spent On Web"
Q1$Sales.Channel <- "Online"



## Removing Unwanted Columns in each Dataset that does not fit the Customer Sales analysis
Q1 <- Q1 %>%
select(-c(N_Purchases, Purchase_DATE, Purchase_VALUE, Browser, Newsletter,  Voucher, date, month, day, year, day_of_week))


Q2<- Q2 %>%
select(-c(Item.Purchased  , Size, Color, Review.Rating, Discount.Applied, Promo.Code.Used, Previous.Purchases, , Frequency.of.Purchases))


Q9<- Q9 %>%
select(-c('Item Purchased', Location, Size, Color, 'Review Rating', 'Discount Applied', 'Promo Code Used', 'Previous Purchases', 'Frequency of Purchases', 'Preferred Payment Method'))



# Confirming the Structure of each data to ensure complete wrangling
str(Q1)
str(Q2)
str(Q9)


# Stacking all data frames into One big data frame
Sales.Data <- bind_rows(Q1, Q2, Q9)



# count the number of NA value in each column
colSums(is.na(Sales.Data))



# remove NA
Sales.Data <-
  Sales.Data[rowSums(is.na(Sales.Data)) !=
             ncol(Sales.Data), ]



# Removing duplicate
Sales.Data <- unique(Sales.Data)




table(Sales.Data$Gender)



Sales.Data <- Sales.Data %>% filter(!is.na(Product.Category))



str(Sales.Data)  #Confirm Data structure


### STEP 4: CONDUCTING DESCRIPTIVE ANALYSIS (FINDING KEYMETRICS)


# Total number of customers
total_customers <- nrow(Sales.Data)

# Retained customers (those with a "Member" status)
retained_customers <- nrow(Sales.Data[Sales.Data$Subscription.Status == "Member", ])

# Calculate retention rate
retention_rate <- (retained_customers / total_customers) * 100

retention_rate



# Calculate percentages
Subscription.status_count <- as.data.frame(table(Sales.Data$Subscription.Status))
Subscription.status_count$percent <- round(Subscription.status_count$Freq / sum(Subscription.status_count$Freq) * 100, 1)

# Plot the pie chart
pie(Subscription.status_count$Freq, labels = paste(Subscription.status_count$Var1, Subscription.status_count$percent, "%"), 
    main = "Customer Retention (Member vs Normal)",
    col = c("lightblue", "lightgreen"))



# Compare the Total Revenue by Customer Gender according to their Subscription Status
aggregate(Sales.Data$Total.Revenue  ~ Sales.Data$Subscription.Status + Sales.Data$Gender, FUN = mean)
aggregate(Sales.Data$Total.Revenue  ~ Sales.Data$Subscription.Status + Sales.Data$Gender, FUN = median)
aggregate(Sales.Data$Total.Revenue  ~ Sales.Data$Subscription.Status + Sales.Data$Gender, FUN = max)
aggregate(Sales.Data$Total.Revenue  ~ Sales.Data$Subscription.Status+ Sales.Data$Gender, FUN = min)



# Group by Customer.Gender and Subscription.Status, then sum the total revenue
Total.Revenue <- Sales.Data %>%
  group_by(Gender, Subscription.Status) %>%
  summarise(Total.Revenue = sum(Total.Revenue, na.rm = TRUE), .groups = "drop")



# Create a bar plot of Total Revenue by Customer Gender and Subscription Status
Total.Revenue <- Sales.Data %>%
  group_by(Gender, Subscription.Status) %>%
  summarise(Total.Revenue = sum(Total.Revenue, na.rm = TRUE), .groups = "drop")
ggplot(Total.Revenue , aes(x = Gender, y = Total.Revenue, fill = Subscription.Status)) +
  geom_bar(stat = "identity", position = "dodge") +  # Use "dodge" to place bars side by side
  labs(title = "Total Revenue by Customer Gender and Subscription Status",
       x = "Customer Gender",
       y = "Total Revenue") +
  theme_minimal()




# Compare the Product category gotten by customers for each season
aggregate(Sales.Data$Season  ~ Sales.Data$Product.Category + Sales.Data$Subscription.Status, FUN = max)
aggregate(Sales.Data$Season  ~ Sales.Data$Product.Category + Sales.Data$Subscription.Status, FUN = min)



# Group by Season, Subscription.Status, and Product.Category, and Total purchases
Seasonal.Purchases <- Sales.Data %>%
  group_by(Season, Subscription.Status, Product.Category) %>%
  summarise(Total.Purchase = n()) %>%  # n() counts the number of rows in each group
  arrange(Season, Subscription.Status, desc(Total.Purchase))



# Create a bar plot for seasonal purchases
ggplot(Seasonal.Purchases, aes(x = Season, y = Total.Purchase, fill = Product.Category)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ Subscription.Status) +
  labs(title = "Product Purchases by Season and Subscription Status",
       x = "Season",
       y = "Number of Purchases")




# Save cleaned data frame as a CSV file
write.csv(Sales.Data, file = "Cleaned Sales Data.csv", row.names = FALSE)

s
