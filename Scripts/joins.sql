-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.
/*
SELECT * FROM SPECS LIMIT 100;
SELECT * FROM RATING LIMIT 100;
SELECT * FROM REVENUE LIMIT 100;
SELECT * FROM DISTRIBUTORS LIMIT 100;
*/

SELECT 
	UPPER(S.film_title) film_title,
	S.release_year,
	R.worldwide_gross 
FROM
	specs S
	INNER JOIN revenue R ON S.movie_id = R.movie_id
WHERE
	R.worldwide_gross = (SELECT MIN(worldwide_gross) FROM revenue);
 
-- FILM: SEMI-TOUGH
-- RELEASE_YEAR: 1977
-- MIN WORLWIDE GROSS: 37,187,139

-- 2. What year has the highest average imdb rating?
/*
SELECT * FROM SPECS LIMIT 100;
SELECT * FROM RATING LIMIT 100;
SELECT * FROM REVENUE LIMIT 100;
SELECT * FROM DISTRIBUTORS LIMIT 100;
*/


SELECT 
T.release_year
FROM
(SELECT 
	S.release_year,
	AVG(R.imdb_rating) avg_imd_rating
FROM
	specs S
	INNER JOIN rating R ON S.movie_id = R.movie_id
GROUP BY 
	S.release_year) T	
WHERE avg_imd_rating =
(SELECT MAX(avg_imd_rating) 
	FROM
(SELECT 
	S.release_year,
	AVG(R.imdb_rating) avg_imd_rating
FROM
	specs S
	INNER JOIN rating R ON S.movie_id = R.movie_id
GROUP BY 
	S.release_year))

-- 1991

-- 3. What is the highest grossing G-rated movie? Which company distributed it?
/*
SELECT * FROM SPECS LIMIT 100;
SELECT * FROM RATING LIMIT 100;
SELECT * FROM REVENUE LIMIT 100;
SELECT * FROM DISTRIBUTORS LIMIT 100;
*/

SELECT 
	UPPER(S.film_title) film_title,
	UPPER(D.company_name) distributor_company_name,
	R.worldwide_gross
FROM
	specs S
	INNER JOIN distributors D ON S.domestic_distributor_id = D.distributor_id
	INNER JOIN revenue R ON S.movie_id = R.movie_id
WHERE 
	S.mpaa_rating = 'G'
AND
	R.worldwide_gross = 
(SELECT 
	MAX(worldwide_gross) 
	FROM (
	SELECT 
	UPPER(S.film_title) film_title,
	UPPER(D.company_name) distributor_company_name,
	R.worldwide_gross
FROM
	specs S
	INNER JOIN distributors D ON S.domestic_distributor_id = D.distributor_id
	INNER JOIN revenue R ON S.movie_id = R.movie_id
WHERE 
	S.mpaa_rating = 'G'));

-- MOVIE: TOY STORY
-- DISTRIBUTING COMPANY: WALT DISNEY
-- GROSS: 1,073,394,593


-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
/*
SELECT * FROM SPECS LIMIT 100;
SELECT * FROM RATING LIMIT 100;
SELECT * FROM REVENUE LIMIT 100;
SELECT * FROM DISTRIBUTORS LIMIT 100;
*/

SELECT 
	UPPER(D.company_name) distributor_company_name,
	COUNT(DISTINCT(S.movie_id)) COUNTS
FROM 
	distributors D
	LEFT OUTER JOIN specs S ON D.distributor_id = S.domestic_distributor_id 
GROUP BY
	UPPER(D.company_name)
ORDER BY 
	2 DESC,1
	
-- 5. Write a query that returns the five distributors with the highest average movie budget.
/*
SELECT * FROM SPECS LIMIT 100;
SELECT * FROM RATING LIMIT 100;
SELECT * FROM REVENUE LIMIT 100;
SELECT * FROM DISTRIBUTORS LIMIT 100;
*/


-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?