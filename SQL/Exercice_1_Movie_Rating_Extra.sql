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
--1.Find the names of all reviewers who rated Gone with the Wind.
select distinct name 
from reviewer, rating, movie
where movie.title='Gone with the Wind' and movie.mID=rating.mid and rating.rID = reviewer.rID

-------------------------------------------------------------------------------------------------------------------
--2.For any rating where the reviewer is the same as the director of the movie, 
--  return the reviewer name, movie title, and number of stars.
select name, title, stars
from reviewer r, movie m, rating ra
where ra.rID=r.rID and m.mID=ra.mID and r.name=m.director

-------------------------------------------------------------------------------------------------------------------
--3.Return all reviewer names and movie names together in a single list, alphabetized. 
--  (Sorting by the first name of the reviewer and first word in the title is fine;
--  no need for special processing on last names or removing "The".)
select distinct name from reviewer
union
select distinct title from movie

-------------------------------------------------------------------------------------------------------------------
--4. Find the titles of all movies not reviewed by Chris Jackson.
select distinct title 
from movie

except 

select distinct title
from movie m, rating ra, reviewer r
where r.rID=ra.rID
      and m.mID=ra.mID and r.rID in (select rID
                                         from reviewer 
                                         where name='Chris Jackson')

-------------------------------------------------------------------------------------------------------------------
--5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, 
--   return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, 
--   and include each pair only once. For each pair, return the names in the pair in alphabetical order.
select distinct r1.name, r2.name
from reviewer r1, reviewer r2, rating ra1, rating ra2
where r1.name<r2.name and r2.rID=ra2.rID and r1.rid=ra1.rid and ra1.mid=ra2.mid
order by r1.name,r2.name


-------------------------------------------------------------------------------------------------------------------
--6. For each rating that is the lowest (fewest stars) currently in the database, 
--   return the reviewer name, movie title, and number of stars.
select name, title, stars
from movie m, reviewer r, rating ra
where r.rid=ra.rid and m.mid=ra.mid and ra.stars = (select min(stars) 
                                                        from rating)

-------------------------------------------------------------------------------------------------------------------
--7.List movie titles and average ratings, from highest-rated to lowest-rated. 
--  If two or more movies have the same average rating, list them in alphabetical order.
select title, avg(stars) as s
from rating ra, movie m
where ra.mid=m.mid
group by title
order by s Desc, title

-------------------------------------------------------------------------------------------------------------------
--8.Find the names of all reviewers who have contributed three or more ratings. 
--  (As an extra challenge, try writing the query without HAVING or without COUNT.)
select name 
from rating ra, reviewer r
where ra.rid=r.rid 
group by ra.rid
having count(ra.rid)>=3

-------------------------------------------------------------------------------------------------------------------
--9. Some directors directed more than one movie. 
--   For all such directors, return the titles of all movies directed by them, 
--   along with the director name. Sort by director name, then movie title. 
--   (As an extra challenge, try writing the query both with and without COUNT.)
select title, director
from movie M 
Where M.Director In (select Director from movie m2 where m2.mid<>m.mid and m2.director=m.director)
Order by director, title

-------------------------------------------------------------------------------------------------------------------
--10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
--   (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as 
--   finding the highest average rating and then choosing the movie(s) with that average rating.)
Select M.title, avg(stars) as s From rating ra, movie m 
                Where ra.mid=m.mid
                Group by M.titlE
                Order by s Desc 
                Limit 1


-------------------------------------------------------------------------------------------------------------------
--11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 
--   (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it 
--    as finding the lowest average rating and then choosing the movie(s) with that average rating.)

Select M.title, avg(stars) as s From rating ra, movie m 
                Where ra.mid=m.mid
                Group by M.titlE
                Order by s
                Limit 2
-------------------------------------------------------------------------------------------------------------------
--12. For each director, return the director's name together with the title(s) of the movie(s) they directed 
--    that received the highest rating among all of their movies, and the value of that rating. 
--    Ignore movies whose director is NULL.
Select Distinct director, title, stars
from movie m, Rating ra
where m.mid=ra.mid and ra.stars in ( selecT max(stars) 
                                    from Rating ra2, movie M2
                                    where ra2.mid=m2.mid and M2.director=m.director) 
                    