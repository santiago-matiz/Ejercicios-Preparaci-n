SELECT 
date_trunc('MONTH',date(dt)) as date,
count(distinct act_acct_cd) as Number_of_clients
FROM "db-analytics-prod"."fixed_cwp"
Where act_cust_typ_nm ='Residencial' and extract(year from date(dt))=2022 and date(dt)=date_trunc('MONTH',date(dt))
Group by 1
Order by date
