select top 100 *, (Year / 10) * 10 AS Decade  from baby_names_db.names

select * from baby_names_db.regions


with cte as(
select
	*,
	(Year / 10) * 10 AS Decade  
from baby_names_db.names
), cte2 as (
select
	decade,
	gender,
	name,
	sum(births) as no_of_times_named
from cte
group by Decade, gender, name
), cte3 as (
select
	*,
	row_number() over (partition by decade, gender order by no_of_times_named desc) as rn
from cte2
)

select * from cte3 where rn = 1

-----------------------------------------------

with cte as(
select
	*,
	(Year / 10) * 10 AS Decade  
from baby_names_db.names
), cte2 as (
select
	decade,
	name,
	sum(births) as no_of_times_named
from cte
group by Decade, name
), cte3 as (
select
	*,
	row_number() over (partition by decade order by no_of_times_named desc) as rn
from cte2
)

select * from cte3 where rn = 1

-----------------------------------------------
with cte as(
select
	gender,
	name,
	sum(births) as no_of_times_named
from baby_names_db.names
group by gender, name
), cte2 as (
select 
*,
row_number() over (partition by gender order by no_of_times_named desc) as rn
from cte
)
select * from cte2 where rn = 1

-------------------------------------------------------------------------------------
Objective 2

with cte as(
select
	Year,
	gender,
	name,
	sum(births) as no_of_times_named
from baby_names_db.names
group by Year, gender, name
), cte2 as (
select 
*,
row_number() over (partition by year, gender order by no_of_times_named desc) as rn
from cte
)
select * from cte2 where rn <= 3 order by Year

----------------------------------------------

with cte as(
select
	*,
	(Year / 10) * 10 AS Decade  
from baby_names_db.names
), cte2 as (
select
	decade,
	gender,
	name,
	sum(births) as no_of_times_named
from cte
group by Decade, gender, name
), cte3 as (
select
	*,
	row_number() over (partition by decade, gender order by no_of_times_named desc) as rn
from cte2
)

select * from cte3 where rn <= 3 order by Decade

--------------------------------------------------------------------------------------------
Objective 3    

select
	case when R.Region is null or R.Region = 'Midwest' then 'Midwest' else R.Region end as Region,
	sum(n.Births) as no_of_birth
from baby_names_db.names N
left join baby_names_db.regions R
on n.State = R.State
group by R.Region
order by no_of_birth desc

with cte as (select * from baby_names_db.regions union all select 'MI' as state, 'Midwest' as region)

select
	R.Region,
	sum(n.Births) as no_of_birth
from baby_names_db.names N
inner join cte R
on n.State = R.State
group by R.Region
order by no_of_birth desc
-----------------------------------------

with cte as (select 
		State,
		case when Region = 'New England' then 'New_England' else Region end as "Region"
	from baby_names_db.regions
	union
	select 'MI' as state, 'Midwest' as region),
cte2 as (
select
	R.Region,
	N.Gender,
	N.name,
	sum(n.Births) as no_of_birth
from baby_names_db.names N
inner join cte R
on n.State = R.State
group by R.Region, N.Gender, N.Name ),
cte3 as (
select *, ROW_NUMBER() over (partition by Region, Gender order by no_of_birth desc) as rn from cte2
)

select * from cte3 where rn <= 3

---------------------------------------------------------------------------------------------------------------------------
Objective 4

with cte as (
select
	Gender,
	Name,
	sum(births) as total_births
from baby_names_db.names
group by Gender, Name
)

select
	top 10
	C.Gender,
	D.Gender,
	C.Name,
	(C.total_births + D.total_births) as total_births
from cte C
join cte D
on C.Name = D.Name
where C.Gender = 'M' and D.Gender = 'F'
order by total_births desc
---------------------------------------

select
	top 10
	Name,
	SUM(births) as total_births
from baby_names_db.names
group by Name
having count(distinct Gender) = 2
order by total_births desc

---------------------------------------------------------------------------------------------------------------------
with long_names as (
select
	Name,
	len(name) as length,
	sum(births) as total_births
from baby_names_db.names
group by name
), most_popular as (
select 
	*,
	dense_rank() over (order by length desc) as dr
from long_names )
select * from most_popular where dr = 1 order by total_births desc    ----- TOP 1 for most popular

-------------------------------------------------------------------------

with short_names as (
select
	Name,
	len(name) as length,
	sum(births) as total_births
from baby_names_db.names
group by name
), most_popular as (
select 
	*,
	dense_rank() over (order by length) as dr
from short_names)
select * from most_popular where dr = 1 order by total_births desc   ----- TOP 1 for most popular

--------------------------------------------------------------------------------------------------------------------------------------------------
with total_births_state as (
select
	state,
	cast(sum(births) as float) as total_births
from baby_names_db.names
group by State
), chris_birth_state as(
select
	State,
	cast(sum(births) as float) as birth
from baby_names_db.names
where Name = 'Chris'
group by State
)

select
	C.State,
	(C.birth / D.total_births) * 100 as highest_percentage_chris
	--*
from chris_birth_state C
inner join total_births_state D
on C.State = D.State
order by highest_percentage_chris desc

-----------------------------------------------------------------------------------
Objective 1

with cte as (
select
	gender,
	name,
	sum(births) as total_births
from baby_names_db.names
group by gender, name
--order by total_births desc
), cte2 as (
select *, row_number() over (partition by gender order by total_births desc) as rn from cte
)

select * from cte2 where rn = 1

---------------------------------------------------------------------------------------------------------
with most_popular_names_overall as (
select
	Name,
	Gender,
	sum(births) as total_births
from baby_names_db.names
group by Name, Gender
--order by total_births desc
), ranking as (
select
	*,
	ROW_NUMBER() over (partition by gender order by total_births desc) as popularity
from most_popular_names_overall
)
select
	*
from ranking
where popularity = 1

-------------------------------------------------------------------------------------------------

with most_popular_names as (
select
	Year,
	Name,
	sum(births) as total_births
from baby_names_db.names
group by Year, Name
), ranking as (
select
	*,
	ROW_NUMBER() over (partition by year order by total_births desc) as popularity
from most_popular_names
)
select
	*
from ranking
where Name = 'Jessica'
order by year

-------------------------------------------------------------------------------------------

with most_popular_names as (
select
	Year,
	Name,
	sum(births) as total_births
from baby_names_db.names
group by Year, Name
), ranking as (
select
	*,
	ROW_NUMBER() over (partition by year order by total_births desc) as popularity
from most_popular_names
)
select
	*
from ranking
where Name = 'Michael'
order by year

------------------------------------------------------------------------------------------
with data_2008 as (
	with cte1 as (
	select
		Name,
		Year,
		sum(Births) as total_births
	from baby_names_db.names
	group by Name, Year
	)
	select
		*,
		ROW_NUMBER() over (partition by year order by total_births desc) as popularity
	from cte1
	where Year = 2008
), data_1980 as (
	with cte1 as (
	select
		Name,
		Year,
		sum(Births) as total_births
	from baby_names_db.names
	group by Name, Year
	)
	select
		*,
		ROW_NUMBER() over (partition by year order by total_births desc) as popularity
	from cte1
	where Year = 1980
)

select
	*
from data_1980
-----------------------------------------------------------------------------------------------
with all_babies as (
select
	State,
	cast(sum(births) as float) as total_births
from baby_names_db.names N
group by State
), chris_baby as (
select
	state,
	cast(sum(births) as float) as total_births
from baby_names_db.names N
where Name = 'Chris'
group by State
)

select
	top 1
	A.state,
	((B.total_births / A.total_births) * 100) as percentage
from all_babies A
inner join chris_baby B
on A.state = B.state
order by percentage