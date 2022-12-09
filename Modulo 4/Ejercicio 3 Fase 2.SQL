With
Flagging as
(SELECT 
date_trunc('MONTH',date(a.dt)) as date,
a.act_acct_cd as client_id,
case when b.interaction_purpose_descrip is not null then 1 Else 0 End as Interaction,
case when c.order_type is not null then 1 else 0 End as Service_order
FROM "db-analytics-prod"."fixed_cwp" a
Left Join "db-stage-prod"."interactions_cwp" b
on a.act_acct_cd =b.account_id and date_trunc('MONTH',date(a.dt)) = date_trunc('MONTH',date(b.interaction_start_time))
Left Join "db-stage-dev"."so_hdr_cwp" c 
On b.account_id = cast(c.account_id as varchar) and date_trunc('MONTH',date(a.dt)) = date_trunc('MONTH',date(c.order_start_date))
Where a.act_cust_typ_nm ='Residencial' and date_trunc('MONTH',date(a.dt))>=date('2022-01-01') and date(a.dt)=date_trunc('MONTH',date(a.dt))
Order by date)

Select
date,
Count(distinct Case when Interaction = 1 and Service_order = 1 then client_id Else Null end)
From Flagging
Group by 1
Order by date asc
