-- Duplicate MRN Analysis
-- SQL validation queries, run on SQLite against the combined CSV file (data/combined_mrn_portfolioproject.csv)
-- before splitting into the star schema in Power Query. Used to check row counts and spot
-- data quality issues.

-- Total rows loaded — should match the combined CSV row count (10,000)
SELECT COUNT(*) AS total_duplicates
FROM duplicate_events;

-- Duplicate counts by registration source
SELECT
    source,
    COUNT(*) AS duplicate_count
FROM combined_mrn_portfolioproject
GROUP BY source
ORDER BY duplicate_count DESC;

-- Duplicate counts by department
SELECT
    department_name,
    COUNT(*) AS duplicate_count
FROM combined_mrn_portfolioproject
GROUP BY department_name
ORDER BY duplicate_count DESC;

-- Status breakdown by source, checking for any unresolved backlog concentrated in one channel
SELECT
    source,
    status,
    COUNT(*) AS duplicate_count
FROM combined_mrn_portfolioproject
GROUP BY source, status
ORDER BY source, status;

-- Resolution type breakdown by department
SELECT
    department_name,
    resolution_type,
    COUNT(*) AS resolution_count
FROM combined_mrn_portfolioproject
GROUP BY department_name, resolution_type
ORDER BY department_name, resolution_count DESC;

-- Monthly trend in duplicate creation
SELECT
    strftime('%Y-%m', event_date) AS month,
    COUNT(*) AS duplicate_count
FROM combined_mrn_portfolioproject
GROUP BY month
ORDER BY month;

-- Contributing factor types, with share of total
SELECT
    contributory_factor_type,
    COUNT(*) AS duplicate_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM combined_mrn_portfolioproject), 1) AS percent_of_total
FROM combined_mrn_portfolioproject
GROUP BY contributory_factor_type
ORDER BY duplicate_count DESC;

-- Primary categories, with share of total
SELECT
    primary_category,
    COUNT(*) AS duplicate_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM combined_mrn_portfolioproject), 1) AS percent_of_total
FROM combined_mrn_portfolioproject
GROUP BY primary_category
ORDER BY duplicate_count DESC;


-- Facilities ranked by duplicate volume (used to confirm the "top 5" cutoff makes sense
-- given there are 1,000 unique facilities)
SELECT
    facility,
    COUNT(*) AS duplicate_count
FROM combined_mrn_portfolioproject
GROUP BY facility
ORDER BY duplicate_count DESC
LIMIT 10;
