-- ============================================================
-- Movies Database Analysis (MySQL)
-- Tables: movie, genre, director_mapping, role_mapping, names, ratings
-- Skills: JOINs, GROUP BY, HAVING, subqueries, CASE WHEN, aggregate functions
-- ============================================================


-- Q1: Count total records in each table
-- Logic: Use UNION ALL to combine counts from all tables
SELECT 'movie' AS table_name, COUNT(*) FROM movie
UNION ALL
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
SELECT 'director mapping', COUNT(*) FROM director_mapping
UNION ALL
SELECT 'role mapping', COUNT(*) FROM role_mapping
UNION ALL
SELECT 'names', COUNT(*) FROM names
UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings;


-- Q2: Identify NULL values in movie table columns
-- Logic: Use CASE WHEN to count NULLs in each column
SELECT
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_nulls,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_nulls,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS income_nulls,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS lang_nulls,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS company_nulls
FROM movie;


-- Q3: Movies released per year and month
-- Logic: Extract month using MONTH() and group by year + month,
-- giving a year-wise count with a month-wise breakdown inside each year
SELECT year, MONTH(date_published) AS month, COUNT(*) AS total_movies
FROM movie
GROUP BY year, MONTH(date_published)
ORDER BY year, month;


-- Q4: Count movies from USA or India in 2019
-- Logic: Filter by year and country using IN
SELECT COUNT(*) AS total_movies
FROM movie
WHERE year = 2019 AND country IN ('USA', 'India');


-- Q5a: List unique genres
SELECT DISTINCT genre FROM genre;


-- Q5b: Count movies with only one genre
-- Logic: Group by movie_id and filter where count = 1
SELECT COUNT(*)
FROM (
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(*) = 1
) t;


-- Q6: Find genre with highest number of movies
-- Logic:
-- 1. Group by genre
-- 2. Count number of movies per genre
-- 3. Sort in descending order and take top 1
SELECT genre, COUNT(*) AS total_movies
FROM genre
GROUP BY genre
ORDER BY total_movies DESC
LIMIT 1;


-- Q7: Average duration per genre
-- Logic: Join movie + genre and use AVG
SELECT g.genre, ROUND(AVG(m.duration), 2) AS avg_duration
FROM genre g
JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre;


-- Q8: Actors/actresses with more than 3 movies rated below 5
-- Logic:
-- 1. Subquery runs first and returns all movie ids with a low rating (< 5)
-- 2. Main query filters using IN
-- 3. Filter only actors/actresses
-- 4. Join with names, group by actor, HAVING COUNT(*) > 3
SELECT n.name, COUNT(*) AS movie_count
FROM role_mapping rm
JOIN names n ON rm.name_id = n.id
WHERE rm.category IN ('actor', 'actress')
  AND rm.movie_id IN (
      SELECT movie_id
      FROM ratings
      WHERE avg_rating < 5
  )
GROUP BY n.name
HAVING COUNT(*) > 3;


-- Q9: MIN and MAX values in ratings table
-- Logic: Apply MIN and MAX on numeric columns
SELECT
    MIN(avg_rating), MAX(avg_rating),
    MIN(total_votes), MAX(total_votes),
    MIN(median_rating), MAX(median_rating)
FROM ratings;


-- Q10: Top 10 movies by average rating
-- Logic: Join movie + ratings and sort
SELECT m.title, r.avg_rating
FROM movie m
JOIN ratings r ON m.id = r.movie_id
ORDER BY r.avg_rating DESC
LIMIT 10;


-- Q11: Group movies by median rating
-- Logic: Use GROUP BY
SELECT median_rating, COUNT(*) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;


-- Q12: Drama movies released in March 2017 (USA) with votes > 1000
-- Logic: Filter by date, country, votes and genre
SELECT COUNT(*)
FROM movie m
JOIN genre g ON m.id = g.movie_id
JOIN ratings r ON m.id = r.movie_id
WHERE YEAR(m.date_published) = 2017
  AND MONTH(m.date_published) = 3
  AND m.country = 'USA'
  AND r.total_votes > 1000
  AND g.genre = 'drama';


-- Q13: Movies starting with "The" and rating > 8
-- Logic: Use LIKE and filter rating
SELECT m.title, g.genre, r.avg_rating
FROM movie m
JOIN genre g ON m.id = g.movie_id
JOIN ratings r ON m.id = r.movie_id
WHERE m.title LIKE 'The%'
  AND r.avg_rating > 8;


-- Q14: Movies between dates with median rating 8
-- Logic: Use BETWEEN and filter median rating
SELECT COUNT(*)
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
  AND r.median_rating = 8;


-- Q15: Compare average votes (Germany vs Italy)
-- Logic: Group by country
SELECT country, AVG(r.total_votes) AS avg_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE country IN ('Germany', 'Italy')
GROUP BY country;


-- Q16: Find NULL values in names table
-- Logic: Use CASE WHEN
SELECT
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END)
FROM names;


-- Q17: Top 2 actors with median rating >= 8
-- Logic: Filter and group
SELECT n.name, COUNT(*) AS movie_count
FROM role_mapping rm
JOIN names n ON rm.name_id = n.id
JOIN ratings r ON rm.movie_id = r.movie_id
WHERE r.median_rating >= 8
  AND rm.category = 'actor'
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;


-- Q18: Top 3 production companies by votes
-- Logic: Aggregate and sort
SELECT m.production_company, SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
GROUP BY m.production_company
ORDER BY total_votes DESC
LIMIT 3;


-- Q19: Directors with more than 3 movies
-- Logic: Group and filter using HAVING
SELECT n.name, COUNT(*) AS total_movies
FROM director_mapping d
JOIN names n ON d.name_id = n.id
GROUP BY n.name
HAVING COUNT(*) > 3;


-- Q20: Average height by category
-- Logic: Filter actor/actress and group
SELECT rm.category, AVG(n.height) AS avg_height
FROM role_mapping rm
JOIN names n ON rm.name_id = n.id
WHERE rm.category IN ('actor', 'actress')
GROUP BY rm.category;


-- Q21: Oldest 10 movies with director
-- Logic: Sort by year ascending
SELECT m.title, m.country, n.name AS director
FROM movie m
JOIN director_mapping d ON m.id = d.movie_id
JOIN names n ON d.name_id = n.id
ORDER BY m.year ASC
LIMIT 10;


-- Q22: Top 5 movies by votes with genre
-- Logic: Join all tables and sort
SELECT m.title, g.genre, r.total_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
JOIN genre g ON m.id = g.movie_id
ORDER BY r.total_votes DESC
LIMIT 5;


-- Q23: Movie with longest duration
-- Logic: Order by duration
SELECT m.title, m.duration, g.genre, m.production_company
FROM movie m
JOIN genre g ON m.id = g.movie_id
ORDER BY m.duration DESC
LIMIT 1;


-- Q24: Total votes for movies in 2018
-- Logic: Filter year and group
SELECT m.title, SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.year = 2018
GROUP BY m.title;
