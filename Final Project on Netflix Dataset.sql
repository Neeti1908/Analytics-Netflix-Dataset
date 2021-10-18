/* SQL Research Project on Netflix Data*/

Create database ResearchProject;
use ResearchProject;

Create table NetflixTitles
(show_id VarChar(100),
type VarChar(100),
title mediumtext,
director mediumtext,
cast MediumText, 
country Mediumtext,
Addition_Date VarChar(100), 
release_year Char(4), 
rating VarChar(100), 
duration VarChar(200),
listed_in LongText, 
description LongText);

Create table Netflix_Viewership_Stats
(Title mediumtext, 
Type VarChar(100), 
DateOfTitleRelease Char(10), 
DateOfStatisticsAnnounced Char(10), 
Viewership_70percent Integer, 
Viewership_2mins Integer, 
Quarter VarChar(100), 
Subscribers_at_Time_In_Millions float, 
Subscribers	Integer, 
Notes MediumText,
Source longtext);

Create table SubscribersData
(Quarter Char(10), 
Start Char(10), 
End	Char(10), 
Subscribers_Millions Integer);

/* Imported data through Command Prompt */

select * from netflixtitles;
select * from netflix_viewership_stats;
select * from subscribersdata;

/* cleaning the imported data */
delete from netflixtitles
where show_id="show_id";

SET SQL_SAFE_UPDATES=0;

alter table netflixtitles
add column DateOfAddition date;

Update netflixtitles
set DateOfAddition=str_to_date(Addition_Date, "%d-%m-%Y");

alter table subscribersdata
add column Start_Date date;

update subscribersdata
set Start_date=str_to_date(start, "%d-%m-%Y");

alter table subscribersdata
add column End_Date date;

update subscribersdata
set End_Date= str_to_date(end, "%d-%m-%Y");

update netflix_viewership_stats
set viewership_70percent=NULL
where viewership_70percent=0;

update netflix_viewership_stats
set Subscribers=NULL
where Subscribers=0;

alter table netflix_viewership_stats
add column TitleReleaseDate date;

update netflix_viewership_stats
set TitleReleaseDate=str_to_date(DateOfTitleRelease, "%d-%m-%Y");

alter table netflix_viewership_stats
add column StatisticsAnnouncedDate date;

update netflix_viewership_stats
set StatisticsAnnouncedDate=str_to_date(DateOfStatisticsAnnounced, "%d-%m-%Y");

/* Querying the data to obtain insights */ 

/* 1. Which of the two has a larger share on netlfix, TV Show or Movie */

select type, count(type) as Number
from netflixtitles
group by type;

/* 2. Which director has the most no. of shows/movies on netlfix*/ 

/* selecting the number of shows & movies for each director*/ 

select director, count(*) as Number
from netflixtitles
where director <> ""
group by director;

/* selecting the director with the maximum no. of shows/movies on netflix */ 

select director, max(number) as MaxNumber
from (select director, count(*) as Number
from netflixtitles
where director <> ""
group by director) as TempTable;

/* 3. Which country has the most no. of shows/movies on netflix */

/* selecting the number of shows & movies for each country*/

select country, count(*) as Number
from netflixtitles
where country <> ""
group by country;

/* selecting the country with the most no. of shows/movies on netflix*/ 

select country, max(Number) as MaxNumber
from (select country, count(*) as Number
from netflixtitles
where country <> ""
group by country) as TempTable;

/* 4. In which year were the max & min no. of TV shows added on Netlfix and in which year were the max & min no. of movies added on Netflix */ 

/* selecting year wise number of TV Shows added on Netflix */ 

select release_year, type, count(*) as Number
from netflixtitles
where type="TV Show"
group by release_year, type;



/* Selecting the year in which maximum no. of TV Shows were added*/

select release_year, type, count(*) as Number
from netflixtitles
where type="TV Show"
group by release_year, type
order by number desc
limit 0,1;

/* selecting the year in which minimum no. of TV Shows were added */

select release_year, type, count(*) as Number
from netflixtitles
where type="TV Show"
group by release_year, type
order by number asc
limit 0,1;

/* selecting year wise number of movies added on Netflix */ 

select release_year, type, count(*) as Number
from netflixtitles
where type="Movie"
group by release_year
order by number desc;

/* selecting the year in which max no. of movies were added on Netflix */ 

select release_year, type, count(*) as Number
from netflixtitles
where type="Movie"
group by release_year
order by number desc
limit 0,1;

/* selecting the year in which min no. of movies were added on Netlfix */ 

select release_year, type, count(*) as Number
from netflixtitles
where type="Movie"
group by release_year
order by number asc
limit 0,1;

/* 5. Calculate the Avg time between date of release and date and date of addition on neflix for TV shows and Movies separately*/

/* Calculating the time between release and addition of TV Shows on Netflix*/

select show_id, title, type, year(dateofaddition), release_year, year(dateofaddition)-release_year as TimeBtwReleaseAndAddition
from netflixtitles
where type="TV Show" and year(dateofaddition)-release_year >=0 and release_year>1997; /* the values in which date of addition is before release year and when release year is before 1997 have been ignored keeping in mind practicality */

/* Calculating the avg time between release of TV Show and Addition of TV Show on Netlflix */

select type, concat(round(avg(TimeBtwReleaseAndAddition),2), " years") as Avg_Time_Btw_Release_and_Addition
from (select show_id, title, type, year(dateofaddition), release_year, year(dateofaddition)-release_year as TimeBtwReleaseAndAddition
from netflixtitles
where type="TV Show" and year(dateofaddition)-release_year >=0 and release_year>1997) as TempTable;

/* Calcuating the time between release and addition of Movies on Netlfix */

select show_id, title, type, year(dateofaddition), release_year, year(dateofaddition)-release_year as TimeBtwReleaseAndAddition
from netflixtitles
where type="Movie" and year(dateofaddition)-release_year >=0 and release_year>1997; /* the values in which date of addition is before release year and when release year is before 1997 have been ignored keeping in mind practicality */

/* Calculating the avg time between release of Movie and Addition of Movie on Netlflix */
 
select type, concat(round(avg(TimeBtwReleaseAndAddition),2), "years") as Avg_Time_Btw_Release_and_Addition
from (select show_id, title, type, year(dateofaddition), release_year, year(dateofaddition)-release_year as TimeBtwReleaseAndAddition
from netflixtitles
where type="Movie" and year(dateofaddition)-release_year >=0 and release_year>1997) as TempTable;

/* 6. For which TV Shows and Movies the time between release date and date of addition on netflix was greater than the avg */ 

/* selecting TV Shows for which time between release date & date of addition is greater than the avg */

select show_id, title, type, year(dateofaddition), release_year, year(dateofaddition)-release_year as TimeBtwReleaseAndAddition
from netflixtitles
where type="TV Show"
and year(dateofaddition)-release_year > (select round(avg(year(dateofaddition)-release_year),2) from netflixtitles where type="TV Show" and year(dateofaddition)-release_year >=0 and release_year>1997);

/* selecting Movies for which time between release date & date of addition is greater than the avg */

select show_id, title, type, year(dateofaddition), release_year, year(dateofaddition)-release_year as TimeBtwReleaseAndAddition
from netflixtitles
where type="Movie"
and year(dateofaddition)-release_year > (select round(avg(year(dateofaddition)-release_year),2) from netflixtitles where type="Movie" and year(dateofaddition)-release_year >=0 and release_year>1997);


/* 7. Plot the rating wise no. of TV shows and movies added on Netflix */ 

select type, rating, count(*) as NumberofAdditions
from netflixtitles
where rating <> ""
group by Type, rating
order by type;

/* 8. Plot the category wise no. of TV shows and movies added on Netflix */ 

select type, listed_in as Category, count(*) as NumberofAdditions
from netflixtitles
group by type, listed_in
order by type;

/* 9. Which TV Show/Movie has the highest 70% viewership in the Viewership Table*/ 

/* TV Show with the highest 70% viewership in the viewership table */ 

select title, type, viewership_70percent
from netflix_viewership_stats
where type="Series"
order by viewership_70percent desc
limit 0,1;

/* Movie with the highest 70% viewership in the viewership table */
 
select title, type, viewership_70percent
 from netflix_viewership_stats
 where type="Movie"
 order by viewership_70percent desc
 limit 0,1;
 
/* Content with the highest 70% viewership in the viewership table */ 

select title, type, viewership_70percent
from netflix_viewership_stats
order by viewership_70percent desc
limit 0,1;

/* 10. Which TV Show/Movie has the highest 2 mins viewership in the viewership table */ 

/* TV Show with the highest 2 mins viewership*/ 

select title, type, viewership_2mins 
from netflix_viewership_stats
where type="Series"
order by viewership_2mins desc
limit 0,1;

/* Movie with the highest 2 mins viewership */ 

select title, type, viewership_2mins
from netflix_viewership_stats
where type="Movie"
order by viewership_2mins desc
limit 0,1;

/* 	Content with the highest 2 mins viewership */ 

select title, type, viewership_2mins
from netflix_viewership_stats
order by viewership_2mins desc
limit 0,1;

/* 11. Find the movie with the highest 2 mins viewership for which all netflix title details are available. Plot all available details from the database.*/

select *
from netflixtitles as T inner join netflix_viewership_stats as V on T.title=V.title 
where T.type="Movie"
and v.viewership_2mins= (select max(viewership_2mins)
                        from netflixtitles as T inner join Netflix_viewership_stats as V
                        on T.title=V.title
                        where T.type="Movie");

/*12. Find the TV Show with the highest subscribers at the time for which all netflix title details are available. Plot all available details from the database. */

select *
from netflix_viewership_stats as V inner join netflixtitles as T on V.title=T.title
where T.type="TV Show"
and V.Subscribers_at_Time_In_Millions = (select max(Subscribers_at_Time_In_Millions)
										from netflix_viewership_stats as V
										inner join netflixtitles as T on V.title=T.title
										where T.type="TV Show");

/* 13. What were the avg number of subscribers in the year in which maximum no. of TV Shows were added */

/* year-wise no. of TV shows added */ 

SELECT 
    YEAR(dateofaddition) AS Year, COUNT(*) AS NumberOfAdditions
FROM
    netflixtitles
WHERE
    type = 'TV Show'
        AND YEAR(dateofaddition) <> 0
GROUP BY YEAR(dateofaddition)
ORDER BY NumberOfAdditions DESC;

/* year in which maximum no. of TV Shows were added */ 

SELECT 
    Year
FROM
    (SELECT 
        YEAR(dateofaddition) AS Year, COUNT(*) AS NumberOfAdditions
    FROM
        netflixtitles
    WHERE
        type = 'TV Show'
            AND YEAR(dateofaddition) <> 0
    GROUP BY YEAR(dateofaddition)
    ORDER BY NumberOfAdditions DESC) AS TempTable
LIMIT 0 , 1;

/* Calculating avg no. of subscribers in the year in which maximum no. of TV Shows were added */ 

SELECT 
    right(quarter, 4) as YearWithMaxAdditions, AVG(subscribers_millions) as AverageNoOfSubscribers
FROM
    subscribersdata
WHERE
    RIGHT(quarter, 4) = (SELECT 
    Year
FROM
    (SELECT 
        YEAR(dateofaddition) AS Year, COUNT(*) AS NumberOfAdditions
    FROM
        netflixtitles
    WHERE
        type = 'TV Show'
            AND YEAR(dateofaddition) <> 0
    GROUP BY YEAR(dateofaddition)
    ORDER BY NumberOfAdditions DESC) AS TempTable
LIMIT 0 , 1);
				

/* 14. Plot a year wise no of TV shows and no. of movies added from 2013 to 2019. Compare with the no. of subscibers in 2013 to 2019.*/

/* Year wise no of TV shows and no. of movies added from 2013 to 2019*/

select year(DateOfAddition) as Year, type, count(*) as NumberOfAdditions
from netflixtitles
where year(dateofaddition) between 2013 and 2019
group by Year(DateOfAddition), type
order by Year(DateOfAddition), type;

/*No. of subscibers in 2013 to 2019*/

select right(quarter, 4) as Year , avg(subscribers_millions) as Average
from subscribersdata 
where right(quarter, 4) between 2013 and 2019
group by right(quarter,4);

/* Growth in the no. of subscribers from 2013 to 2019 */
 select year, Average, 
(Average-lag (average, 1) over (order by year asc)) as IncreaseInAvgNoOfSubscribers
 from 
 (select right(quarter, 4) as Year , avg(subscribers_millions) as Average
from subscribersdata 
where right(quarter, 4) between 2012 and 2019
group by right(quarter,4)) as temptable; 


/* Comparing the two data sets */ 

select A.Year, A.Type, A.NumberOfAdditions, B.IncreaseInAvgNoOfSubscribers
from 
(select year(DateOfAddition) as Year, type, count(*) as NumberOfAdditions
from netflixtitles
where year(dateofaddition) between 2013 and 2019
group by Year(DateOfAddition), type
order by Year(DateOfAddition), type) as A 
inner join 
(select year, Average, 
 round((Average-lag (average, 1) over (order by year asc)),2) as IncreaseInAvgNoOfSubscribers
 from 
 (select right(quarter, 4) as Year , avg(subscribers_millions) as Average
from subscribersdata 
where right(quarter, 4) between 2012 and 2019
group by right(quarter,4)) as temptable) as B 
on A.Year= B.Year;

