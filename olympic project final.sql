#                                                                   OLYMPIC DATA 
use projects;

#                                                                   DATA CLEANING

set sql_safe_updates=0;

# removing duplicate records
with cte as (
select  *, row_number() over(partition by athlete,event,medal) as rn
from olympic_data)
delete from olympic_data
where (athlete,event,medal) in (
select athlete,event,medal from cte where rn>1);


# handling missing values 
delete from  olympic_data
where city is null
or year is null
or sport is null
or discipline is null
or event is null
or athlete is null
or gender is null
or country_code is null 
or country is null
or event_gender is null
or medal is null;

# checking data structural value 
desc olympic_data;
          -- all datatype looks correct so we will move to the further process of finding useful insight.


#                                                                               INSIGHTS

# BASIC OVERVIEW
  -- Total rows
	 select count(*)from olympic_data;
  -- Unique athletes
     select distinct(athlete) from olympic_data;
  -- Unique event
	 select distinct(event) from olympic_data; 
  -- Unique country
     select distinct(country) from olympic_data;
  -- Unique years   
     select distinct(year) from olympic_data;
	
# checking duplicates if any
select athlete,event,medal,count(*)
            from olympic_data
            group by athlete,event,medal
            having count(*) >1;

# Distribution of medal by country
select country,count(medal) as total_medals 
           from olympic_data
           group by country;
           
# Top 10 athletes with most medals
select athlete,count(medal) as medals_won
             from olympic_data
             group by athlete
             order by medals_won desc
             limit 10;

# Medal trends over time
select year,count(medal) as medals
             from olympic_data
             group by year 
             order by year;
             
# Top 10 successful sport 
select sport,count(medal) as medals
         from olympic_data
         group by sport
         order by medals desc
         limit 10;
         
# Gender distribution of medals
select gender,count(medal) as medals
           from olympic_data
           group by gender
           order by medals desc;

# Top 10 countries whose males athletes won gold medal 
select country,count(medal) as  males_gold
         from olympic_data where medal="gold"
         group by gender,country
         having gender="men"
         order by males_gold desc
         limit 10;

# Total athlete in a particular sport discipline
select discipline,count(*) as total_athletes
         from olympic_data  
         group by discipline;
         
# Top 5 countries who won maximum number of medals
select country,count(medal) as medals
        from olympic_data
        group by country
        order by medals desc
        limit 5;

# Different types of medal won over the years
         with cte1 as(
         select year,count(medal) as gold
         from olympic_data
         where medal="gold"
         group by year),
         cte2 as(
         select year,count(medal) as silver
         from olympic_data
         where medal="silver"
         group by year),
         cte3 as(
         select year,count(medal) as bronze
         from olympic_data
         where medal="bronze"
         group by year)
         select cte1.year,cte1.gold,cte2.silver,cte3.bronze
         from cte1 inner join cte2 on
         cte1.year = cte2.year
         inner join cte3 on
         cte2.year=cte3.year;
         
# Medal distribution according to gender and country.
with cte1 as (select country,count(medal) as men_gold from olympic_data where medal="gold"
          and gender="men"
          group by country),

          cte2 as (
          select country,count(medal) as women_gold
          from olympic_data
          where medal="gold"
          and gender="women"
          group by country),

          cte3 as (
          select country,count(medal) as men_silver
          from olympic_data
          where medal="silver"
          and gender="men"
          group by country),

         cte4 as(
        select country,count(medal) as women_silver
        from olympic_data
        where medal="silver"
        and gender="women"
        group by country),
        cte5 as(
        select country,count(medal) as men_bronze
        from olympic_data
        where medal="bronze"
        and gender="men"
        group by country),
        cte6 as (
        select country,count(medal) as women_bronze
        from olympic_data
        where medal="bronze"
        and gender="women"
        group by country)
        
	   select cte1.country,cte1.men_gold,cte2.women_gold,cte3.men_silver,cte4.women_silver,
       cte5.men_bronze,cte6.women_bronze
       from cte1 inner join cte2 on
       cte1.country = cte2.country
       inner join cte3 on
       cte2.country=cte3.country
       inner join cte4 on
       cte3.country=cte4.country
       inner join cte5 on
       cte4.country=cte5.country
       inner join cte6 on
       cte5.country=cte6.country;








 


