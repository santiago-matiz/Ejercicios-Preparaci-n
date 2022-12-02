SELECT
date_trunc('MONTH',date(interaction_start_time)) as Date_Month,
interaction_purpose_descrip as Purpose,
COUNT(DISTINCT interaction_id) as Interactions
FROM "db-stage-prod"."interactions_cwp"
WHERE date_trunc('MONTH',date(interaction_start_time)) =date('2022-08-01')
Group by 1,2
Order by 1,2
