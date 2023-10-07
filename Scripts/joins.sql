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
SELECT 
	UPPER(D.company_name) distributor_company_name,
	AVG(R.film_budget) avg_budget
FROM 
	distributors D
	INNER JOIN specs S ON D.distributor_id = S.domestic_distributor_id 
	INNER JOIN revenue R ON S.movie_id = R.movie_id 
GROUP BY
	UPPER(D.company_name)
ORDER BY 
	2 DESC
LIMIT(5)

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?
/*
SELECT * FROM SPECS LIMIT 100;
SELECT * FROM RATING LIMIT 100;
SELECT * FROM REVENUE LIMIT 100;
SELECT * FROM DISTRIBUTORS LIMIT 100;
*/

/*
How many movies in the dataset are distributed by a company which is not headquartered in California?
*/
SELECT SUM(COUNTS) 
FROM 
(SELECT
    UPPER(S.film_title) film_title
    count(distinct(S.movie_id)) COUNTS,
    
FROM
    Specs S
	LEFT OUTER JOIN distributors D ON D.distributor_id = S.domestic_distributor_id 
	LEFT OUTER JOIN rating R ON S.movie_id = R.movie_id
WHERE 
	UPPER(SUBSTRING(TRIM(d.headquarters),STRPOS(TRIM(d.headquarters),',')+2)) <>'CA'
GROUP BY
	 UPPER(S.film_title)
)

-- 2

/*
Which of these movies has the highest imdb rating?
*/

SELECT
    UPPER(S.film_title),
	COALESCE(R.imdb_rating,0) imdb_rating
FROM
    Specs S
	LEFT OUTER JOIN distributors D ON D.distributor_id = S.domestic_distributor_id 
	LEFT OUTER JOIN rating R ON S.movie_id = R.movie_id
WHERE 
	UPPER(SUBSTRING(TRIM(d.headquarters),STRPOS(TRIM(d.headquarters),',')+2)) <>'CA'
AND imdb_rating =
(SELECT MAX(imdb_rating)
FROM(

SELECT
    UPPER(S.film_title),
	UPPER(COALESCE(d.headquarters,'*UNASSIGNED')) headquarters,
	COALESCE(R.imdb_rating,0) imdb_rating
FROM
    Specs S
	LEFT OUTER JOIN distributors D ON D.distributor_id = S.domestic_distributor_id 
	LEFT OUTER JOIN rating R ON S.movie_id = R.movie_id
WHERE 
UPPER(SUBSTRING(TRIM(d.headquarters),STRPOS(TRIM(d.headquarters),',')+2)) <>'CA'))

-- DIRTY DANCING (7.0)

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
/*
SELECT * FROM SPECS LIMIT 100;
SELECT * FROM RATING LIMIT 100;
SELECT * FROM REVENUE LIMIT 100;
SELECT * FROM DISTRIBUTORS LIMIT 100;
*/

SELECT 
	HOURS,
	ROUND(avg_rating,2)
FROM 
(SELECT
	CASE 
	WHEN S.length_in_min > 120 THEN 'OVER TWO HOURS'
	WHEN S.length_in_min <= 120 THEN 'UNDER TWO HOURS'
	END HOURS,
	AVG(R.imdb_rating) avg_rating
FROM
    Specs S
	INNER JOIN rating R ON S.movie_id = R.movie_id
GROUP BY
	CASE 
	WHEN S.length_in_min > 120 THEN 'OVER TWO HOURS'
	WHEN S.length_in_min <= 120 THEN 'UNDER TWO HOURS'
	END)
	WHERE avg_rating =
(SELECT 
	MAX(avg_rating) 
FROM (
SELECT
	CASE 
	WHEN S.length_in_min > 120 THEN 'OVER TWO HOURS'
	WHEN S.length_in_min <= 120 THEN 'UNDER TWO HOURS'
	END HOURS,
AVG(R.imdb_rating) avg_rating
FROM
    Specs S
	INNER JOIN rating R ON S.movie_id = R.movie_id
GROUP BY
	CASE 
	WHEN S.length_in_min > 120 THEN 'OVER TWO HOURS'
	WHEN S.length_in_min <= 120 THEN 'UNDER TWO HOURS'
	END))
	
-- BEST RATING: OVER TWO HOURS (7.26)

