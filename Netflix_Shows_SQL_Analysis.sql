USE netflix_project;

-- =====================================================
-- NETFLIX SHOWS ANALYSIS PROJECT (WORKING VERSION)
-- =====================================================

-- 1. Top 10 shows according to IMDB score
SELECT title,
       type,
       imdb_score
FROM titles
WHERE imdb_score >= 8.0
  AND type = 'SHOW'
ORDER BY imdb_score DESC
LIMIT 10;

-- 2. Bottom 10 shows according to IMDB score
SELECT title,
       type,
       imdb_score
FROM titles
WHERE type = 'SHOW'
  AND imdb_score IS NOT NULL
ORDER BY imdb_score ASC
LIMIT 10;

-- 3. Average IMDB and TMDB scores for shows
SELECT type,
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM titles
GROUP BY type;

-- 4. Count of shows in each decade
SELECT FLOOR(release_year / 10) * 10 AS decade,
       COUNT(*) AS total_count
FROM titles
WHERE release_year >= 1940
GROUP BY FLOOR(release_year / 10) * 10
ORDER BY decade;

-- 5. Average IMDB and TMDB scores for each production country
SELECT production_countries,
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM titles
WHERE production_countries IS NOT NULL
GROUP BY production_countries
ORDER BY avg_imdb_score DESC;

-- 6. Average IMDB and TMDB scores for each age certification
SELECT age_certification,
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM titles
WHERE age_certification IS NOT NULL
GROUP BY age_certification
ORDER BY avg_imdb_score DESC;

-- 7. 5 most common age certifications for shows
SELECT age_certification,
       COUNT(*) AS certification_count
FROM titles
WHERE type = 'SHOW'
  AND age_certification IS NOT NULL
  AND age_certification <> 'N/A'
GROUP BY age_certification
ORDER BY certification_count DESC
LIMIT 5;

-- 8. Top 20 actors that appeared the most
SELECT name AS actor,
       COUNT(*) AS number_of_appearances
FROM credits
WHERE role = 'actor'
GROUP BY name
ORDER BY number_of_appearances DESC
LIMIT 20;

-- 9. Top 20 directors that directed the most
SELECT name AS director,
       COUNT(*) AS number_of_appearances
FROM credits
WHERE role = 'director'
GROUP BY name
ORDER BY number_of_appearances DESC
LIMIT 20;

-- 10. Average runtime of shows
SELECT 'SHOW' AS content_type,
       ROUND(AVG(runtime), 2) AS avg_runtime_min
FROM titles
WHERE type = 'SHOW';

-- 11. Titles and directors of shows released on or after 2010
SELECT DISTINCT t.title,
       c.name AS director,
       t.release_year
FROM titles AS t
JOIN credits AS c
  ON t.id = c.id
WHERE t.type = 'SHOW'
  AND t.release_year >= 2010
  AND c.role = 'director'
ORDER BY t.release_year DESC;

-- 12. Which shows have the most seasons?
SELECT title,
       seasons AS total_seasons
FROM titles
WHERE type = 'SHOW'
  AND seasons IS NOT NULL
ORDER BY seasons DESC
LIMIT 10;

-- 13. Which genres had the most shows?
SELECT genres,
       COUNT(*) AS title_count
FROM titles
WHERE type = 'SHOW'
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;

-- 14. Total number of titles for each year
SELECT release_year,
       COUNT(*) AS title_count
FROM titles
GROUP BY release_year
ORDER BY release_year DESC;

-- 15. Actors who starred in the most highly rated shows
SELECT c.name AS actor,
       COUNT(*) AS num_highly_rated_titles
FROM credits AS c
JOIN titles AS t
  ON c.id = t.id
WHERE c.role = 'actor'
  AND t.type = 'SHOW'
  AND t.imdb_score > 8.0
  AND t.tmdb_score > 8.0
GROUP BY c.name
ORDER BY num_highly_rated_titles DESC;

-- 16. Actors/actresses who played the same character in multiple shows
SELECT c.name AS actor_actress,
       c.character_name,
       COUNT(DISTINCT t.title) AS num_titles
FROM credits AS c
JOIN titles AS t
  ON c.id = t.id
WHERE c.role IN ('actor', 'actress')
GROUP BY c.name, c.character_name
HAVING COUNT(DISTINCT t.title) > 1
ORDER BY num_titles DESC;

-- 17. Top 3 most common show genres
SELECT genres,
       COUNT(*) AS genre_count
FROM titles
WHERE type = 'SHOW'
GROUP BY genres
ORDER BY genre_count DESC
LIMIT 3;

-- 18. Average IMDB score for actors/actresses in shows
SELECT c.name AS actor_actress,
       ROUND(AVG(t.imdb_score), 2) AS average_imdb_score
FROM credits AS c
JOIN titles AS t
  ON c.id = t.id
WHERE c.role IN ('actor', 'actress')
GROUP BY c.name
ORDER BY average_imdb_score DESC;