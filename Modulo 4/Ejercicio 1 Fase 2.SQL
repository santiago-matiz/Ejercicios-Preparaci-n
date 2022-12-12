SELECT 
date_trunc('MONTH',date(a.dt)) as date,
Count(distinct a.act_acct_cd) as clients
FROM "db-analytics-prod"."fixed_cwp" a
Left Join "db-stage-prod"."interactions_cwp" b
On a.act_acct_cd = b.account_id and date_trunc('MONTH',date(a.dt)) = date_trunc('MONTH',date(b.interaction_start_time))
Where a.act_cust_typ_nm ='Residencial' and date_trunc('MONTH',date(a.dt))>=date('2022-01-01') and date(a.dt)=date_trunc('MONTH',date(a.dt)) and b.interaction_purpose_descrip ='TRUCKROLL' and a.pd_bb_prod_cd is not null
Group by 1
Order by date,clients
