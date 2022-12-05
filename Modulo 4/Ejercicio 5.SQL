With
Status as(
SELECT 
date_trunc('MONTH', date(dt)) as Date,
account_id,
oldest_unpaid_bill_dt,
Case when date_diff('DAY',cast (concat(substr(oldest_unpaid_bill_dt, 1,4),'-',substr(oldest_unpaid_bill_dt, 5,2),'-', substr(oldest_unpaid_bill_dt, 7,2)) as date), cast(dt as date)) >= 90 then 'Inactivo'
when date_diff('DAY',cast (concat(substr(oldest_unpaid_bill_dt, 1,4),'-',substr(oldest_unpaid_bill_dt, 5,2),'-', substr(oldest_unpaid_bill_dt, 7,2)) as date), cast(dt as date)) <=90 or oldest_unpaid_bill_dt is null and dt='2022-10-01' then 'Activo'
End as client_status
FROM "db-analytics-prod"."tbl_postpaid_cwc"
where account_type='Residential' and org_id='338')

Select
Date,
Count(Distinct case when client_status='Inactivo' then account_id Else Null End) as Inactivos,
Count(Distinct case when client_status='Activo' then account_id Else Null End) as Activo
from Status
Group by 1
Order by 1
