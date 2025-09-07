create table netflix(
	show_id	varchar(6),
	type	varchar(10),
	title	varchar(150),
	director varchar(210),
	casts	varchar(1000),
	country	varchar(150),
	date_added	varchar(50),
	release_year int,	
	rating	varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(250 )
);

select * from netflix;

select count(*) as total_content from netflix;

--1. Count the number of Movies vs TV shows

select type ,count(type) from netflix
group by type;


--2. Find the most common rating for Movies and TV shows 

with group_up as(
	select type,rating, count(*) as total_count from netflix
	where rating is not null
	group by 1,2
),ranking as(
	select *,rank() over(partition by type order by total_count desc ) ranking_tot_content from group_up
)

select * from ranking
where ranking_tot_content = 1; 


--3. List All Movies Released in a Specific Year (e.g., 2020)

select * from netflix
where type = 'Movie' and release_year = 2020;


--4. Find the Top 5 Countries with the Most Content on Netflix

with group_up as (
	select unnest(string_to_array(country,',')),count(*) as total_content from netflix 
	where 1 is not  null
	group by 1
),ranking as (
	select *,rank() over(order by total_content desc ) as ranking_tot_content from group_up
)

select * from ranking
where ranking_tot_content <= 5;


--5. Identify the Longest Movie

select type,cast(substring(trim(duration) ,1,position('min' in trim(duration))-1) as int) as timing from netflix
where type = 'Movie' and duration is not null
order by timing desc
limit 1;


--6. Find Content Added in the Last 5 Years

select * from netflix
where to_date(date_added,'month DD,yyyy') >= current_date - interval '5year';


--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

select * from netflix
where director like '%Rajiv Chilaka%';


--8. List All TV Shows with More Than 5 Seasons

select * from netflix
where type = 'TV Show' and duration > '5 Seasons';


--9. Count the Number of Content Items in Each Genre

select unnest(string_to_array(listed_in,',')) as genre,count(show_id) from netflix
group by 1;


--10.Find each year and the average numbers of content release in India on netflix.Return top 5 year avgerage content release

with average as (select date_part('year',cast(date_added as date)) as year_, 
		count(*)  as yearly_content,round(cast(count(*) as int)/(select count(*) from netflix where country like '%India%'):: numeric * 100,2) as average_container_per_year from netflix
		where country like '%India%'
		group by 1)
select year_,average_container_per_year from average
order by 2 desc
limit 5;


--11. List All Movies that are Documentaries

select * from netflix
where listed_in like '%Documentaries%' and type = 'Movie';


--12. Find All Content Without a Director

select * from netflix
where director is null;


--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

select * from netflix
where type = 'Movie' and casts ilike '%Salman Khan%' and to_date(date_added,'month DD,yyyy') > current_date - interval '10 year'


--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India


select unnest(string_to_array(casts,',')) as list_casts,count(*) from netflix
where country ilike '%india%' and casts is not null
group by 1
order by 2 desc 
limit 10



--15. Categorize Content Based on the Presence of 'Kill' or 'Violence' Keywords in description field.
-- Label content containing these keywords as Bad and also other content as 'Good'.Count how many item fall in each category


select 
case 
	when description ilike '%kill%' or description ilike '%Violence%' then 'Bad'
	else 'Good'
end as category  ,count(*) as each_category from netflix
group by 1

