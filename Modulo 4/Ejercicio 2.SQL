SELECT
date_trunc('MONTH',date(order_start_date)) as Month,
COUNT (DISTINCT order_id) as Num_orders
FROM "db-stage-dev"."so_hdr_cwc"
where org_cntry ='Jamaica' AND account_type ='Residential' AND date_trunc('MONTH',date(order_start_date)) >=date('2022-01-01')
Group by 1
Order by 1
