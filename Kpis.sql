-- Overall funnel conversion
SELECT COUNT(*) AS postings,
  SUM(views) AS total_views,
  SUM(applies) AS total_applies,
  ROUND(1.0 * SUM(applies) / NULLIF(SUM(views), 0), 6) AS apply_per_view_rate
FROM v_jobs;
-- Funnel conversion by city 
SELECT city,
  COUNT(*) AS postings,
  SUM(views) AS total_views,
  SUM(applies) AS total_applies,
  ROUND(1.0 * SUM(applies) / NULLIF(SUM(views), 0), 6) AS apply_per_view_rate
FROM v_jobs
GROUP BY city
HAVING postings >= 3
ORDER BY apply_per_view_rate ASC,
  total_views DESC;
-- Cohort analysis: month posted vs engagement
SELECT cohort_month,
  COUNT(*) AS postings,
  ROUND(AVG(views), 2) AS avg_views,
  ROUND(AVG(applies), 2) AS avg_applies,
  ROUND(1.0 * SUM(applies) / NULLIF(SUM(views), 0), 6) AS apply_per_view_rate
FROM v_jobs
GROUP BY cohort_month
ORDER BY cohort_month;
-- Rank postings by apply rate 
SELECT job_id,
  company_name,
  title,
  city,
  views,
  applies,
  ROUND(1.0 * applies / NULLIF(views, 0), 4) AS apply_rate,
  listed_dt
FROM v_jobs
WHERE views >= 50
ORDER BY apply_rate DESC,
  applies DESC
LIMIT 50;
WITH skill_flags AS (
  SELECT city,
    CASE
      WHEN lower(title || ' ' || description) LIKE '%sql%' THEN 1
      ELSE 0
    END AS has_sql,
    CASE
      WHEN lower(title || ' ' || description) LIKE '%python%' THEN 1
      ELSE 0
    END AS has_python,
    CASE
      WHEN lower(title || ' ' || description) LIKE '%excel%' THEN 1
      ELSE 0
    END AS has_excel,
    CASE
      WHEN lower(title || ' ' || description) LIKE '%tableau%' THEN 1
      ELSE 0
    END AS has_tableau,
    CASE
      WHEN lower(title || ' ' || description) LIKE '%power bi%' THEN 1
      ELSE 0
    END AS has_powerbi
  FROM v_jobs
)
SELECT city,
  COUNT(*) AS postings,
  SUM(has_sql) AS demand_sql,
  SUM(has_python) AS demand_python,
  SUM(has_excel) AS demand_excel,
  SUM(has_tableau) AS demand_tableau,
  SUM(has_powerbi) AS demand_powerbi
FROM skill_flags
GROUP BY city
HAVING postings >= 3
ORDER BY postings DESC;
-- Median days_open overall
WITH x AS (
  SELECT days_open,
    ROW_NUMBER() OVER (
      ORDER BY days_open
    ) AS rn,
    COUNT(*) OVER () AS cnt
  FROM v_jobs
  WHERE days_open IS NOT NULL
),
mid AS (
  SELECT CASE
      WHEN cnt % 2 = 1 THEN (
        SELECT days_open
        FROM x
        WHERE rn = (cnt + 1) / 2
      )
      ELSE (
        (
          SELECT days_open
          FROM x
          WHERE rn = cnt / 2
        ) + (
          SELECT days_open
          FROM x
          WHERE rn = cnt / 2 + 1
        )
      ) / 2.0
    END AS median_days_open
  FROM x
  LIMIT 1
)
SELECT ROUND(median_days_open, 2) AS median_days_open
FROM mid;