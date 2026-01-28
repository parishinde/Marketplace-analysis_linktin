-- Creates a clean layer with derived fields like city, cohort_month, days_open
DROP VIEW IF EXISTS v_jobs;
CREATE VIEW v_jobs AS
SELECT job_id,
    company_id,
    company_name,
    title,
    description,
    location,
    -- Extract city from "City, State" format
    TRIM(
        CASE
            WHEN INSTR(location, ',') > 0 THEN SUBSTR(location, 1, INSTR(location, ',') - 1)
            ELSE location
        END
    ) AS city,
    formatted_work_type,
    work_type,
    formatted_experience_level,
    remote_allowed,
    CAST(COALESCE(views, 0) AS INTEGER) AS views,
    CAST(COALESCE(applies, 0) AS INTEGER) AS applies,
    -- Epoch ms → datetime
    datetime(CAST(listed_time AS REAL) / 1000, 'unixepoch') AS listed_dt,
    datetime(CAST(expiry AS REAL) / 1000, 'unixepoch') AS expiry_dt,
    -- Cohort bucket (YYYY-MM)
    strftime(
        '%Y-%m',
        datetime(CAST(listed_time AS REAL) / 1000, 'unixepoch')
    ) AS cohort_month,
    -- Time open (proxy for time-to-hire / time-to-fill)
    CASE
        WHEN listed_time IS NOT NULL
        AND expiry IS NOT NULL THEN (CAST(expiry AS REAL) - CAST(listed_time AS REAL)) / 86400000.0
        ELSE NULL
    END AS days_open,
    normalized_salary,
    min_salary,
    max_salary,
    pay_period,
    currency,
    compensation_type,
    posting_domain,
    application_type,
    job_posting_url,
    application_url
FROM rawww;
SELECT job_id,
    company_name,
    SUBSTR(title, 1, 40) || '...' AS short_title,
    city,
    views,
    applies
FROM v_jobs
LIMIT 20;