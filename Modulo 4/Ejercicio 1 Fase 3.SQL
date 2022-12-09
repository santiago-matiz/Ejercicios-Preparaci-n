With
Flagging as
(SELECT 
date_trunc('MONTH',date(a.dt)) as date,
a.act_acct_cd as client,
b.interaction_id as interaction,
Case when a.fi_outst_age < 90 or a.fi_outst_age is null then 'Activo'
When a.fi_outst_age >= 90 then 'Inactivo' Else Null End as client_status
FROM "db-analytics-prod"."fixed_cwp" a
Inner Join "db-stage-prod"."interactions_cwp" b
On a.act_acct_cd = b.account_id and date_trunc('MONTH',date(a.dt)) = date_trunc('MONTH',date(b.interaction_start_time))
Where a.act_cust_typ ='R' and b.interaction_purpose_descrip ='CLAIM' and date_trunc('MONTH', date(a.dt)) >=date('2022-01-01'))

,Calls as
(SELECT
date,
client,
count(distinct interaction) as llamadas
From Flagging
Where client_status ='Activo'
Group by 1,2)

Select
date,
count(distinct case when llamadas = 1 then client Else Null End) as una_Llamada,
count(distinct case when llamadas > 1 then client Else Null End) as Mas_de_1_Llamada
From Calls
Group by 1
Order by 1 asc
