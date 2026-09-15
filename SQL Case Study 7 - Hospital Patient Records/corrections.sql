select 
	YEAR(start) as each_year,
	round(sum(case when ENCOUNTERCLASS = 'ambulatory' then 1 else 0 end) / cast(count(*) as float) * 100, 2) as ambulatory,
	round(sum(case when ENCOUNTERCLASS = 'outpatient' then 1 else 0 end) / cast(count(*) as float) * 100, 2) as outpatient,
	round(sum(case when ENCOUNTERCLASS = 'wellness' then 1 else 0 end) / cast(count(*) as float) * 100, 2) as wellness,
	round(sum(case when ENCOUNTERCLASS = 'urgentcare' then 1 else 0 end) / cast(count(*) as float) * 100, 2) as "urgentcare",
	round(sum(case when ENCOUNTERCLASS = 'emergency' then 1 else 0 end) / cast(count(*) as float) * 100, 2) as "emergency",
	round(sum(case when ENCOUNTERCLASS = 'inpatient' then 1 else 0 end) / cast(count(*) as float) * 100, 2) as inpatient
from hospital_db.encounters
group by YEAR(start)

----------------------------------------------------------------------------

select
	round(sum(case when DATEDIFF(HOUR, START, STOP) >= 24 then 1 else 0 end) / cast(count(*) as float) * 100, 2) as "over 24 hrs",
	round(sum(case when DATEDIFF(HOUR, START, STOP) < 24 then 1 else 0 end) / cast(count(*) as float) * 100, 2) as "under 24 hrs"
from hospital_db.encounters

----------------------------------------------------------------------------




