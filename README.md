# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/Selvan-crypto/netflix_sql_project/blob/main/Netflixlogo.jpg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.


## Objective

- Analyze the distribution of content types (Movies vs TV Shows).
- Identify the most common ratings for Movies and TV Shows.
- List and analyze content based on release years, countries and duration.
- Explore and categories content based on specific criteria and keywords.


## Dataset

The Data for this project is sourced from the kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows)


## Schema

```sql
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
	listed_in varchar(100  ),
	description varchar(250 )
);
```
## Business Problems and Solutions
### 1. Count the Number of Movies vs TV Shows

```sql
select type ,count(type) from netflix
group by type;
```
**Objecttive:** Determine the distribution of content types on Netflix.

### 2. Find the most common rating for Movies and TV shows 

```sql
with group_up as (
	select type,rating, count(*) as total_count from netflix
	where rating is not null
	group by 1,2
),ranking as(
	select *,rank() over(partition by type order by total_count desc ) ranking_tot_content from group_up
)

select * from ranking
where ranking_tot_content = 1; 
```
**Objective:** Identify the most frequently occuring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select * from netflix
where type = 'Movie' and release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

## 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
with group_up as (
	select unnest(string_to_array(country,',')),count(*) as total_content from netflix 
	where 1 is not  null
	group by 1
),ranking as (
	select *,rank() over(order by total_content desc ) as ranking_tot_content from group_up
)

select * from ranking
where ranking_tot_content <= 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
select type,cast(substring(trim(duration) ,1,position('min' in trim(duration))-1) as int) as timing from netflix
where type = 'Movie' and duration is not null
order by timing desc
limit 1;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
select * from netflix
where to_date(date_added,'month DD,yyyy') >= current_date - interval '5year';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select * from netflix
where director like '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select * from netflix
where type = 'TV Show' and duration > '5 Seasons';
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select unnest(string_to_array(listed_in,',')) as genre,count(show_id) from netflix
group by 1;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix.Return top 5 year avgerage content release

```sql
with average as (select date_part('year',cast(date_added as date)) as year_, 
		count(*)  as yearly_content,round(cast(count(*) as int)/(select count(*) from netflix where country like '%India%'):: numeric * 100,2) as average_container_per_year from netflix
		where country like '%India%'
		group by 1)
select year_,average_container_per_year from average
order by 2 desc
limit 5;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select * from netflix
where listed_in like '%Documentaries%' and type = 'Movie';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select * from netflix
where director is null;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select * from netflix
where type = 'Movie' and
	casts ilike '%Salman Khan%' and
	to_date(date_added,'month DD,yyyy') > current_date - interval '10 year'
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
select unnest(string_to_array(casts,',')) as list_casts,count(*) from netflix
where country ilike '%india%' and casts is not null
group by 1
order by 2 desc 
limit 10
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' or 'Violence' Keywords in description field.Label content containing these keywords as Bad and also other content as 'Good'.Count how many item fall in each category

```sql
select 
case 
	when description ilike '%kill%' or description ilike '%Violence%' then 'Bad'
	else 'Good'
end as category  ,count(*) as each_category from netflix
group by 1
```
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Finding and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
