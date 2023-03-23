# Capstone Data Analysis of a european streaming platform

In recent years, the rise of online streaming platforms has revolutionized the way we consume and enjoy movies, TV shows, and other forms of digital content. These platforms offer users the convenience of accessing a vast library of entertainment from the comfort of their own homes, and have become an increasingly popular choice for viewers worldwide.

We were lucky to be able to get into contact with a European online streaming platform. Unlike traditional streaming services, this service prides itself on offering a curated library of high-quality, independent films and documentaries from around the world. The platform is also committed to supporting emerging filmmakers and promoting diversity and representation in the film industry.

In this exploratory data analysis (EDA) we will dive into platform and subscription growth, typical user behaviour, conversion success for gifted subscriptions and vouchers, and the occurrence of account sharing.
Through this analysis, we aim to provide valuable insights that can inform business decisions and drive the platform's growth and success in the highly competitive streaming industry.

**Disclaimer**: We are unable to show any results and graphs from our analysis due to a Non-Disclosure Agreement (NDA) that we have signed with the streaming service. As responsible and ethical data analysts, we prioritize the protection of our clients' sensitive data and ensure that it is not disclosed or misused in any way. Therefore, in the following, we will only explain our approach to the analysis.

## Table of content:

1. Tools
2. Data model
3. Data cleaning
4. EDA
6. Conclusion

# 1. Tools

For our project we used the following tools:
- Python in VS Code
- SQL in DBeaver
- Github
- Tableau for analysis and visualisation
- Notion for project management/ Kanban 
- Google slides for presentation

# 2. Data model

Our contact at the streaming service platform provided us with four CSV-formatted datasets comprising a cumulative total of 170,000 rows spanning 24 months. We subsequently arranged this data into an ER-diagram as follows:

![ER-diagram](https://user-images.githubusercontent.com/114055916/227152600-76bf8c0b-6eda-4901-9354-7631dc8de638.png)

# 3. Data cleaning

Data cleaning constituted a critical phase in our analytical process. It involved identifying and rectifying errors, inconsistencies, and missing values within the datasets to ensure the data's accuracy, completeness, and reliability. This was necessary to derive more meaningful insights during the exploratory data analysis (EDA) phase. A detailed account of our data cleaning activities is available in the Data_Cleaning Notebook. In essence, we implemented the following measures:
- Uniformizing all columns to a consistent format
- Changing data types (e.g., datetime) as necessary
- Adding additional columns as needed
- Discarding erroneous data points
- Adjusting time ranges to account for any disparities across datasets
- Augmenting datasets with additional information as appropriate

Some of the findings required a more diligent effort to refine. 
Specifically, we focused on gathering **geographic information** about our users, therefore their city or postal code were essential. However, during the data screening process, we discovered that these fields were inconsistent due to the open format in which users registered. Since some countries use various languages and spelling conventions, city names were often not standardized and spelling errors were common. Consequently, we determined that the postal code was a more reliable source of information. To augment this data, we obtained additional postal code, city, state etc. information from external CSV files from official sources and mapped it to our dataset.

In addition, we investigated the **user agents** to determine the devices (desktop or mobile) and whether the users were utilizing the streaming service's app.

To facilitate the analysis of the **subscription** data, we incorporated subscription prices, factoring in the duration of the subscription and whether it was a yearly or monthly subscription. We also accounted for gifted subscriptions, which had different prices.

Finally, we loaded our refined datasets onto an **SQL server** to streamline and expedite further processing of the data.

**Disclaimer**: The disconnected data and censoring measures will prevent the notebook from being executable.

# 4. EDA

In conducting our analysis, we initially explored the data generally to enhance our understanding. We subsequently formulated hypotheses and identified key performance indicators (KPIs) that would be interesting and valuable to our stakeholder. 

To facilitate our analysis, we categorized these KPIs into four broad themes, namely Users, Subscriptions, Vouchers and Gifted Subscriptions, and Account Sharing. 

## 4.1. Users
To gain insights into user behavior, we conducted an analysis that included various factors, including:
- How many accounts are there and are they active (having subscriptions or OTR) or inactive (only having an account) 
- How many hours they watch
- How many playbacks per subscription type/ timeframes /devices
- How many subscriptions / one time rentals (OTR) users have
- Where they come from geographically
- If  they are watching from mobile devices or ‘big screens'

#### Challenges we encountered
- Establishing reliable geographical data (see further explanation in 'Data cleaning'

## 4.2. Subscriptions
A range of subscription options are available to users, including monthly or yearly plans, with varying levels of access. Our investigation focused on the following aspects:
- New Subscription rate -  How many new subscriptions are generated in relation to the total number of subscriptions? 
- Subscription churn rate -  absolute growth of subscriptions per month (positive or negative)
- Subscription growth rate - Growth of active subscriptions from month to month in % 
- What is the seasonal behaviour and what other influences are there?
- Average revenue per user for subscriptions/subscription types and OTR
- Subscription runtimes

#### Challenges we encountered
- Establishing a view of the data on a monthly basis

## 4.3. Vouchers and gifted subscriptions
### 4.3.1. Vouchers
Each subscription allows users to send a predetermined number of movie vouchers to friends or family free of charge per year. The recipient of the voucher can then enjoy the selected movie at no cost.
- Total sent vouchers
- Total redeemed vouchers / redemption rate
- Voucher Lead Conversion - How many vouchers led to a new account registration
- Voucher Subscription Conversion 
- How many vouchers led to a subscription purchase?
- What kind of subscriptions were purchased after?
- Voucher OTR Conversion - How many vouchers led to a OTR purchase?
- Voucher ARPU (average revenue per user) - How much revenue does a movie voucher generate on average in euros?

#### Challenges we encountered
- Identifying the first voucher per account which was received, as some users received multiple vouchers
- Determining whether the first purchase per account was made after the initial voucher was received, as some users were already active prior to receiving the voucher.
- Avoid double-counting of accounts in OTR and Subscription conversion
- Although ARPU analysis is a valuable metric, due to time constraints, we were unable to fully calculate ARPU 

### 4.3.2. Gifted subscriptions
There is an option available to buy a subscription as a gift for another individual.
- Gifted subscription Conversion 
  - How many vouchers led to a subscription purchase?
  - What kind of subscriptions were purchased after?
  
#### Challenges we encountered
- Identifying the first gifted subscription per account which was received, as some users received multiple vouchers
- Identifying if the first paid subscription per account was purchased after the first gifted subscription was received or prior to it

## 4.4. Account sharing

Account sharing is a common practice among users of streaming platforms, where they share their login credentials with others outside their household. This has raised concerns for the industry and we were interested if our stakeholder is affected by this.
In order to be able to set a threshold for what we consider “normal behaviour” or respectively “abnormal behaviour”, which would mean sharing your account outside one household, we researched a typical household behaviour of the users' countries.

From official statistical data sources we learned that in 2021 the average household consisted of 2.2 people, every individual has on average 4 connected devices and the public IP address changes per month on average around 2 times.

Based on these stats, data from the streaming service and common sense we were able to set a threshold and generate a list of accounts which show “suspicious behaviour”.

#### Threshold conditions
- If a household uses more than 9 devices and more than 6 different public IP addresses per month we consider them as potential account sharers. 

Due to the amount of assumptions we have to make, it’s very difficult to tell who is actually sharing their account because:
- User agents are not users or single individuals - they’re not even unique browsers -> real fingerprinting is complex
- Public IP addresses change regularly depending on the ISP (Internet Service Provider)
- Users can change their IP addresses more often for other reasons (restarting the router, privacy tools, VPN etc.)
- Users can have multiple locations besides their home, like work, holiday house etc.

## 5. Conclusion

In our stakeholder presentation, we selectively presented and illustrated the pertinent findings, featuring potential correlations, and offering recommendations on how best to leverage these discoveries. It was gratifying to receive a positive reception from our stakeholders, who expressed keen interest and appreciation for our findings. They sought our perspective on specific business decisions based on the insights we gleaned from the data.

In the end, besides the general stats, we’ve chosen to concentrate the following main questions:
- Where do the users mainly come from geographically? 
- What is the seasonal subscription behaviour and what could be the influences on this?
- What is the subscription runtime behaviour for yearly and monthly subscriptions and how can this information be used for further growth?
- How effective are the vouchers and gifted subscriptions for platform growth?
- How widespread is account sharing?

In conclusion, **further analysis** on further usage scenarios, ARPU conversion for vouchers and gifted subscriptions, recommendation algorithms, customer retention, sociodemographic description of the user base, and changes in usage during the pandemic, could help the streaming platform optimize user experience, increase customer retention, and stay ahead of competitors. By leveraging data and insights on user behavior and preferences, the platforms could tailor their content offerings, pricing strategies, and marketing campaigns to better meet the needs of their user base and ensure long-term growth and success











