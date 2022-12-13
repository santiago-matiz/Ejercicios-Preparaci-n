With
Client_status as
(SELECT 
date(dt) as date,
act_acct_cd as client
FROM "db-analytics-prod"."fixed_cwp"
Where act_cust_typ ='R' and (fi_outst_age < 90 or fi_outst_age is null) and date(dt)>= date('2022-07-01') and date(dt)<=date('2022-08-31'))

,First_v as
(Select
distinct client,
First_value(date)over(partition by client order by date desc) as Churn_date
From Client_status)

Select
Churn_date,
count(distinct client) as churners
From First_v
Group by 1
Order by 1 ASC
