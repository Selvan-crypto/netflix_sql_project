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
