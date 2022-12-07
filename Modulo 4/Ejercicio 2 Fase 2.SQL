With
Flagging as
(Select
date_trunc('MONTH', date(a.dt)) as Date,
a.account_id as clients,
Case when date_diff('DAY',cast (concat(substr(a.oldest_unpaid_bill_dt, 1,4),'-',substr(a.oldest_unpaid_bill_dt, 5,2),'-', substr(a.oldest_unpaid_bill_dt, 7,2)) as date), cast(a.dt as date)) >= 90 then 'Inactivo'
when date_diff('DAY',cast (concat(substr(a.oldest_unpaid_bill_dt, 1,4),'-',substr(a.oldest_unpaid_bill_dt, 5,2),'-', substr(a.oldest_unpaid_bill_dt, 7,2)) as date), cast(a.dt as date)) <90 or a.oldest_unpaid_bill_dt is null then 'Activo'
End as client_status,
b.order_type as Order_type
FROM "db-analytics-prod"."tbl_postpaid_cwc" a
Join "db-stage-dev"."so_hdr_cwc" b
on a.account_id = cast(b.account_id as varchar) and date_trunc('MONTH', date(a.dt)) = date_trunc('MONTH', date(b.order_start_date))
where a.account_type='Residential' and a.org_id='338' and b.order_type ='DEACTIVATION' and date(a.dt)=date('2022-10-01'))

Select 
Date,
count(distinct clients) as Total_clients
From Flagging
Group by Date, Client_status
Having client_status ='Activo'
