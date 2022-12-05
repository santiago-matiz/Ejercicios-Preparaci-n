With
Flagging as
(SELECT 
date_trunc('MONTH',date(dt)) as date,
act_acct_cd as Client,
act_cust_strt_dt,
CASE 
WHEN date_diff('MONTH',date(act_cust_strt_dt),date(dt)) <6 then 'Early Tenure'
WHEN date_diff('MONTH',date(act_cust_strt_dt),date(dt)) between 6 and 12 then 'Mid Tenure'
WHEN date_diff('MONTH',date(act_cust_strt_dt),date(dt)) > 12 then 'Late Tenure'
END as Tenure
FROM "db-analytics-prod"."fixed_cwp"
Where act_cust_typ_nm ='Residencial' and date_trunc('MONTH',date(dt))>=date('2022-01-01') and date(dt)=date_trunc('MONTH',date(dt))
Order by date)

Select
Tenure,
COUNT(DISTINCT Client)
From Flagging
Group by 1
Order by 2 desc
