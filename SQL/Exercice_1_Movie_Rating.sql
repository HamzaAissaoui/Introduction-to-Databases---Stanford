/*
Database:
Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.
*/

-------------------------------------------------------------------------------------------------------------------
--1.Find the titles of all movies directed by Steven Spielberg.
select title 
from Movie 
where director='Steven Spielberg'

-------------------------------------------------------------------------------------------------------------------
--2.Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
select distinct year 
from Movie m, Rating r
where m.mID= r.mID and (r.stars=4 or r.stars=5)
order by year 

-------------------------------------------------------------------------------------------------------------------
--3.Find the titles of all movies that have no ratings.
select title
from Movie m
where m.mID not in (select mID from Rating)

-------------------------------------------------------------------------------------------------------------------
--4. Some reviewers didn't provide a date with their rating. 
--	 Find the names of all reviewers who have ratings with a NULL value for the date.
select name 
from Reviewer r, Rating ra
where r.rID=ra.rID and ra.ratingDate is null

-------------------------------------------------------------------------------------------------------------------
--5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
--	 Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
select name, title, stars, ratingDate
from Movie m, Reviewer r, Rating ra
where m.mID=ra.mID and r.rID=ra.rID
order by name, title, stars

-------------------------------------------------------------------------------------------------------------------
--6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
--	 return the reviewer's name and the title of the movie.
Select R1.name, R1.title 
from (select Rating.rID , Stars , Rating.mID, name, title, ratingDate
       from Rating, movie, reviewer
       Where Rating.rID= reviewer.rID and rating.mID=movie.mID) R1, 
      
      (select Rating.rID , Stars , Rating.mID, ratingDate
       from Rating, movie, reviewer
       Where Rating.rID= reviewer.rID and rating.mID=movie.mID) R2
	   
Where R1.mID=R2.mID and R1.rID=R2.rID and R1.ratingdate<R2.ratingDate and R1.stars<R2.stars

-------------------------------------------------------------------------------------------------------------------
--7. For each movie that has at least one rating, find the highest number of stars that movie received. 
--	 Return the movie title and number of stars. Sort by movie title.
select title, max(stars) 
from movie, Rating 
where Movie.mID=Rating.mID
group by title

-------------------------------------------------------------------------------------------------------------------
--8. For each movie, return the title and the 'rating spread', that is, the difference between highest and 
--   lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
select movie.title, R.rating_spread
from movie, (select Movie.mID, max(stars)-min(stars) as rating_spread 
             from Rating, movie 
             where rating.mID=movie.mID
             group by Movie.mID) as R
where Movie.mID=R.mID
group by R.rating_spread ,title
order by R.rating_spread desc

-------------------------------------------------------------------------------------------------------------------
--9. Find the difference between the average rating of movies released before 1980 and the average rating 
--   of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
--   Don't just calculate the overall average rating before and after 1980.)
select a.e-b.f
from (select avg(g) as e
        from (select avg(stars) as g
        from rating r,movie m 
        where m.mID=r.mID and m.year < 1980 
        group by r.mID) c
      ) a,
      
      (select avg(h) as f
        from (select avg(stars) as h
        from rating r,movie m 
        where m.mID=r.mID and m.year>=1980 
        group by r.mID) d
      ) b