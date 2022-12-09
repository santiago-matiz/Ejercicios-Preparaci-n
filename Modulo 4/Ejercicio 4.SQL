With
Flagging as
(SELECT 
date_trunc('MONTH',date(dt)) as date,
act_acct_cd as Client,
act_cust_strt_dt,
CASE 
WHEN date_diff('MONTH',date(act_cust_strt_dt),date(dt)) <6 then 'Early Tenure'
WHEN date_diff('MONTH',date(act_cust_strt_dt),date(dt)) >= 6 and date_diff('MONTH',date(act_cust_strt_dt),date(dt))<12 then 'Mid Tenure'
Else 'Late Tenure'
END as Tenure
FROM "db-analytics-prod"."fixed_cwp"
Where act_cust_typ_nm ='Residencial' and date_trunc('MONTH',date(dt))>=date('2022-01-01') and date(dt)=date_trunc('MONTH',date(dt))
Order by date)

Select
date,
Tenure,
COUNT(DISTINCT Client)
From Flagging
Group by 1,2
Order by 1,2 desc
