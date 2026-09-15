----------------------------------------------Objective 1 Tasks solutions---------------------------------------------

select
	year(START) as "year",
	COUNT(*) as total_encounter
from hospital_db.encounters
group by year(START)
order by "year"

-------------------------------------------------------------------------------------------

with encounters as (
select
	year(START) as 'year',
	COUNT(*) as total_encounters
from hospital_db.encounters
group by year(START)
), encounterclass as(
select
	year(START) as "year",
	ENCOUNTERCLASS,
	count(*) as total_encounterclass
from hospital_db.encounters
group by year(START), ENCOUNTERCLASS
)

select
	A.year,
	B.ENCOUNTERCLASS,
	cast(B.total_encounterclass as float) / cast(A.total_encounters as float) * 100 as "percentage"
from encounters A
inner join encounterclass B
on A.year = B.year
order by A.year

----------------------------------------------------------------------------------------------------------------
with hrs_data as (
select
	id,
	case when DATEDIFF(HOUR, start, stop) < 24 then 'under 24 hrs' else 'over 24 hrs' end as hrs_difference
from hospital_db.encounters
)
select
	hrs_difference,
	cast(count(*) as float)/cast(((select count(*) from hrs_data)) as float) * 100 as "percentge"
from hrs_data
group by hrs_difference


-----------------------------------------------------------------------------------------------------------------

--------------------------------------------------------OBJECTIVE 2 TASKS SOLUTION-----------------------------------------------------------------

select
	SUM(case when PAYER_COVERAGE = 0.00 then 1 else 0 end) as total_zero_payer_coverage,
	round((SUM(case when PAYER_COVERAGE = 0.00 then 1 else 0 end) / cast(count(*) as float) *100), 2) as percentage_zero_payer_coverage
from hospital_db.encounters

--------------------------------------------------------------------------------------------------------------------------------

select
	TOP 10
	DESCRIPTION,
	count(*) as total_no,
	avg(base_cost) as avg_basecost
from hospital_db.procedures
group by DESCRIPTION
order by total_no desc

--------------------------------------------------------------------------------------------------------------------------------

select
	top 10
	DESCRIPTION,
	avg(base_cost) as highest_avg_basecost,
	count(*) as no_of_times_performed
from hospital_db.procedures
group by DESCRIPTION
order by highest_avg_basecost desc

--------------------------------------------------------------------------------------------------------------------------------

select
	P.NAME,
	AVG(E.TOTAL_CLAIM_COST) as avg_total_claim_cost
from hospital_db.payers P
inner join hospital_db.encounters E
on P.Id = E.PAYER
group by P.NAME

--------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------OBJECTIVE 3 TASKS SOLUTION-----------------------------------------------------------------------------

select
	year(START) as "year",
	DATEPART(quarter, START) as "quarter",
	count(distinct PATIENT) as no_of_unique_patients
from hospital_db.procedures
group by year(START), DATEPART(quarter, START)
order by year, "quarter"

------------------------------------------------------------------------------------------------------

with days_compare as (
select
	START,
	STOP,
	PATIENT,
	--ROW_NUMBER() OVER (PARTITION BY PATIENT ORDER BY START) as rn,
	lead(START) OVER (PARTITION BY PATIENT ORDER BY START) as readmitt_start_date
from hospital_db.encounters
)
select
	count(distinct PATIENT) as no_of_readmitted
from days_compare
where DATEDIFF(day, STOP, readmitt_start_date) < 30

------------------------------------------------------------------------------------------------------
-----------------------Most Readmissions overtime

with readmissions as (
	select
		PATIENT,
		count(*) as total_readmissions
	from hospital_db.encounters
	group by PATIENT
)
select
	top 1
	P.*,
	R.total_readmissions
from readmissions R
inner join hospital_db.patients P
on R.PATIENT = P.Id
order by total_readmissions desc

------------------------------------------------------------------------------------------------------
---------------------Most readmissions within 30 days of a previous encounter

with days_compare as (
select
	START,
	STOP,
	PATIENT,
	--ROW_NUMBER() OVER (PARTITION BY PATIENT ORDER BY START) as rn,
	lead(START) OVER (PARTITION BY PATIENT ORDER BY START) as readmitt_start_date
from hospital_db.encounters
)
select
	TOP 1
	PATIENT,
	count(*) as no_of_readmissions
from days_compare
where DATEDIFF(day, STOP, readmitt_start_date) < 30
group by PATIENT
order by no_of_readmissions desc

------------------------------------------------------------------------------------------------------

---------------------5th Most readmissions within 30 days of a previous encounter
with days_compare as (
select
	START,
	STOP,
	PATIENT,
	--ROW_NUMBER() OVER (PARTITION BY PATIENT ORDER BY START) as rn,
	lead(START) OVER (PARTITION BY PATIENT ORDER BY START) as readmitt_start_date
from hospital_db.encounters
), within_30_days as (
select
	PATIENT,
	count(*) as no_of_readmissions
from days_compare
where DATEDIFF(day, STOP, readmitt_start_date) < 30
group by PATIENT
), ranking as (
select
	*,
	ROW_NUMBER() over (order by no_of_readmissions desc) as ranking_readmissions
from within_30_days
)

select
	*
from ranking
where ranking_readmissions = 5