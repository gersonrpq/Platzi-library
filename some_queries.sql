-- Here some queries for some question will be found

-- What are the nationalities of the authors?

SELECT DISTINCT nationality FROM authors
ORDER BY nationality;

-- How many authors for each nationality?

SELECT nationality, count(author_id) as c_author
FROM authors
WHERE nationality IS NOT NULL
    and nationality NOT IN('RUS','AUT')
GROUP BY nationality
ORDER BY c_author DESC, nationality ASC; 

-- What's the average and the standard deviation of the prices for each nationality?

SELECT nationality,COUNT(book_id) as `books`, AVG(price) as average , STDDEV(price) as std
from books as b 
JOIN authors as a
    ON a.author_id = b.author_id 
group by nationality
order by `books` DESC;

-- What the maximum price and the minimum price for the books of every nationality?

SELECT a.nationality, MAX(b.price), Min(b.price)
from books as b
Join authors as a 
 ON a.author_id = b.author_id 
GROUP BY nationality;

-- Reporting transactions

SELECT c.name, o.type, b.title, 
CONCAT(a.name,"(", a.nationality, ")") as Author,
TO_DAYS(NOW()) - TO_DAYS(o.created_at) as Ago
from operations as o 
left join clients as c 
    on c.client_id = o.client_id 
left join books as b 
     on b.book_id = o.book_id 
Left join authors as a 
    on b.author_id = a.author_id ;

-- how much money will be made if all sellable books are sold?

select sum(price*copies) from books where sellable = 1;

-- The books and their range of time when they were written

select count(book_id), 
    sum(if(year < 1950,1,0)) as '<1950',
    sum(if(year >= 1950 and year < 1990,1,0)) as '<1990',
    sum(if(year >= 1950 and year < 2000,1,0)) as '<2000',
    sum(if(year > 2000,1,0)) as '>2000' 
from books;

-- The books amount of books depending on when they were written and their nationality 

SELECT nationality, count(book_id),
    sum(if(year < 1950,1,0)) as '<1950',
    sum(if(year >= 1950 and year < 1990,1,0)) as '<1990',
    sum(if(year >= 1950 and year < 2000,1,0)) as '<2000',
    sum(if(year > 2000,1,0)) as '>2000' 
from books as b 
join authors as a 
    On a.author_id = b.author_id
where a.nationality is not null
Group by nationality;

-- the authors and the ammount of books they wrote

select a.author_id, a.name , a.nationality, count(b.book_id) as written_books
from authors as a
inner join books as b 
    on b.author_id = a.author_id 
Group by a.author_id 
order by a.name;
