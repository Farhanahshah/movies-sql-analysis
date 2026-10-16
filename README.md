# movies-sql-analysis
A SQL analysis of a movies database with 7,997 movies from 2017 to 2019.

## Business question
What does the data reveal about genres, ratings, release patterns, actors and directors?

## Tools
MySQL: JOINs, subqueries, CASE WHEN, GROUP BY, HAVING and aggregate functions

## What I did
Wrote 24 queries across six tables (movie, genre, ratings, names, role_mapping, director_mapping), covering record counts, missing values, release trends, genre analysis, ratings, top actors, directors and production companies.

## Findings
- Drama is the most common genre, with 4,285 titles.
- Action movies are the longest on average (about 113 minutes) and Horror the shortest (about 93).
- 3,289 movies belong to only one genre.
- Marvel Studios has the most total votes of any production company (about 2.66 million).
- Worldwide gross income is missing for 3,724 of the 7,997 movies.

## Files
- `movies_analysis.sql`: all 24 queries with comments
- The PDF with the query outputs

---
Built by [Farhanah Shah](https://farhanahshah.github.io/) | [LinkedIn](https://www.linkedin.com/in/farhanah-s-333236414/)
