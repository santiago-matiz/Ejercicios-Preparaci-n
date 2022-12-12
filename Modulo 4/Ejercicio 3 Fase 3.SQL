WITH
Status as
(SELECT 
date(dt) as date,
act_acct_cd as client,
Case when fi_outst_age < 90 or fi_outst_age is null then 'Activo'
When fi_outst_age >= 90 then 'Inactivo' Else Null End as client_status
FROM "db-analytics-prod"."fixed_cwp"
Where act_cust_typ ='R' and date_trunc('MONTH', date(dt)) >=date('2022-01-01'))

,Interactions as
(Select
date,
client
From Status
Inner Join "db-stage-prod"."interactions_cwp" b
On client = b.account_id and date = date(b.interaction_start_time)
Where client_status ='Activo')

,Int_orders as
(Select
date as int_date,
client,
date(c.order_start_date) as order_date
From Interactions
Inner Join "db-stage-dev"."so_hdr_cwp" c
On client = cast(c.account_id as varchar)
Where c.order_type ='DEACTIVATION'
)

Select
count(distinct client) as Total_clients
From Int_orders
Where date_diff('DAY',int_date,order_date) <=40
