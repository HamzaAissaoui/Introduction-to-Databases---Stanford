/*
Students at your hometown high school have decided to organize their social network using databases. 
So far, they have collected information about sixteen students in four grades, 9-12. Here's the schema:

Highschooler ( ID, name, grade )
English: There is a high school student with unique ID and a given first name in a certain grade.

Friend ( ID1, ID2 )
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, 
so if (123, 456) is in the Friend table, so is (456, 123).

Likes ( ID1, ID2 )
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, 
so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present.
*/

-------------------------------------------------------------------------------------------------------------------
--1.Find the names of all students who are friends with someone named Gabriel.
select h1.name
from highschooler h1, friend f, highschooler h2
where h1.Id=f.id1 and f.id2=h2.id and h2.name='Gabriel'

-------------------------------------------------------------------------------------------------------------------
--2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, 
--   and the name and grade of the student they like.
select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1, highschooler h2, likes l
where h1.id=l.id1 and h2.id=l.id2 and (h1.grade-h2.grade) >= 2

-------------------------------------------------------------------------------------------------------------------
--3. For every pair of students who both like each other, return the name and grade of both students. 
--   Include each pair only once, with the two names in alphabetical order.
select distinct  h1.name,h1.grade,h2.name,h2.grade
from highschooler h1, highschooler h2, likes l1, likes l2
where (h1.id=l1.id1 and h2.id=l1.id2) and h2.name>h1.name  and (h2.id=l2.id1 and h1.id=l2.id2) 


-------------------------------------------------------------------------------------------------------------------
--4. Find all students who do not appear in the Likes table (as a student who likes or is liked) 
--   and return their names and grades. Sort by grade, then by name within each grade.
select name, grade
from highschooler h
where h.id not in (select id1 from likes union select id2 from likes) 

-------------------------------------------------------------------------------------------------------------------
--5. For every situation where student A likes student B, but we have no information about whom B likes 
--   (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1, highschooler h2, likes l
where h1.id=l.id1 and h2.id=l.id2 and h2.id not in(select id1 from likes)


-------------------------------------------------------------------------------------------------------------------
--6. Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, 
--   then by name within each grade.
select distinct h1.name, h1.grade
from highschooler h1, highschooler h2, friend f
where h1.id=f.id1 and f.id2=h2.id and h2.grade=h1.grade
except 

select h3.name, h3.grade
from highschooler h3, friend f2
where h3.id=f2.id1 and exists (select h4.name,h4.grade from highschooler h4, friend f3 where f3.id1=h3.id and f3.id2=h4.id and h4.grade<>h3.grade)

order by h1.grade,h1.name


-------------------------------------------------------------------------------------------------------------------
--7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common 
--   (who can introduce them!). 
--   For all such trios, return the name and grade of A, B, and C.
select distinct h1.name, h1.grade, h2.name,h2.grade,h3.name,h3.grade
from highschooler h1, highschooler h2, highschooler h3, likes l, friend f
where l.id1=h1.id and l.id2=h2.id and not exists (select * from friend f2 
                                                    where (f2.id1=h1.id and f2.id2=h2.id) 
                                                    or (f2.id1=h2.id and f2.id2=h1.id) )  
                                  and exists (select * from friend f3
                                              where (f3.id1=h3.id and f3.id2=h1.id) 
                                                    and exists (select * from friend f3
                                              where (f3.id1=h3.id and f3.id2=h2.id)))

-------------------------------------------------------------------------------------------------------------------
--8. Find the difference between the number of students in the school and the number of different first names.
select ns.a-fn.b
from (select count(*) as a from highschooler) ns,(select count(distinct name) as b from highschooler) fn

-------------------------------------------------------------------------------------------------------------------
--9. Find the name and grade of all students who are liked by more than one other student.
select distinct h1.name, h1.grade
from highschooler h1, likes l
where (select count(*) from likes l2 where l2.id2=h1.id) > 1

-------------------------------------------------------------------------------------------------------------------
--10. Find those students for whom all of their friends are in different grades from themselves. 
--    Return the students' names and grades.
select name, grade
from Highschooler h1
where not grade in (select grade 
                    from (Highschooler h2 join friend on h2.id=id1) a 
                    where a.id2=h1.id)
					
-------------------------------------------------------------------------------------------------------------------
--11. What is the average number of friends per student? (Your result should be just one number.)
select avg(s.coun)
from (select id1,count(id2) as coun from friend group by id1) as s
					

-------------------------------------------------------------------------------------------------------------------
--12. Find the name and grade of the student(s) with the greatest number of friends.
select h1.name,h1.grade
from highschooler h1
where h1.id in (select id1 
                from (select max(s.coun) as max
                        from (select id1,count(id2) as coun from friend group by id1) as s
                        )  a, friend f
                 
                 group by f.id1
                 having count(f.id1) = a.max)