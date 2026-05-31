CREATE DATABASE melbourne_analysis;
USE melbourne_analysis;


CREATE TABLE clue_businesses (
    id                      INT AUTO_INCREMENT PRIMARY KEY,
    census_year             INT,
    block_id                INT,
    property_id             INT,
    base_property_id        INT,
    clue_small_area         VARCHAR(100),
    trading_name            VARCHAR(255),
    business_address        VARCHAR(255),
    industry_code           INT,
    industry_description    VARCHAR(255),
    longitude               DECIMAL(12, 8),
    latitude                DECIMAL(12, 8)
);


CREATE TABLE sensor_locations (
    location_id         INT PRIMARY KEY,
    sensor_description  VARCHAR(255),
    sensor_name         VARCHAR(100),
    installation_date   DATE,
    note                VARCHAR(500),
    location_type       VARCHAR(50),
    status              CHAR(1),
    direction_1         VARCHAR(50),
    direction_2         VARCHAR(50),
    latitude            DECIMAL(12, 8),
    longitude           DECIMAL(12, 8),
    location_raw		VARCHAR(100)
);



CREATE TABLE pedestrian_counts (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    location_id         INT,
    sensing_date        DATE,
    hour_of_day         INT,
    direction_1_count   INT,
    direction_2_count   INT,
    total_count         INT,
    sensor_name         VARCHAR(100),
    FOREIGN KEY (location_id) REFERENCES sensor_locations(location_id)
);



-- ============================================================
-- 1. ROW COUNTS — confirm everything loaded
-- ============================================================
SELECT 'clue_businesses'   AS table_name, COUNT(*) AS row_count FROM clue_businesses
UNION ALL
SELECT 'sensor_locations',                COUNT(*)               FROM sensor_locations
UNION ALL
SELECT 'pedestrian_counts',               COUNT(*)               FROM pedestrian_counts;

-- Expected: ~413,550 / 137 / 812,178


-- ============================================================
-- 2. CHECK FOR NULLS IN KEY COLUMNS
-- ============================================================

-- CLUE table
SELECT
    SUM(CASE WHEN census_year IS NULL THEN 1 ELSE 0 END)           AS null_year,
    SUM(CASE WHEN clue_small_area IS NULL THEN 1 ELSE 0 END)       AS null_area,
    SUM(CASE WHEN industry_description IS NULL THEN 1 ELSE 0 END)  AS null_industry,
    SUM(CASE WHEN trading_name IS NULL THEN 1 ELSE 0 END)          AS null_trading_name
FROM clue_businesses;
-- Note: ~127 rows have no trading_name — these are legitimate (vacant/unnamed spaces)

-- Pedestrian counts
SELECT
    SUM(CASE WHEN location_id IS NULL THEN 1 ELSE 0 END)   AS null_location_id,
    SUM(CASE WHEN sensing_date IS NULL THEN 1 ELSE 0 END)  AS null_date,
    SUM(CASE WHEN total_count IS NULL THEN 1 ELSE 0 END)   AS null_count
FROM pedestrian_counts;


-- ============================================================
-- 3. DATE RANGE CHECKS
-- ============================================================
SELECT MIN(census_year) AS earliest, MAX(census_year) AS latest
FROM clue_businesses;
-- Expected: 2002 – 2024

SELECT MIN(sensing_date) AS earliest, MAX(sensing_date) AS latest
FROM pedestrian_counts;
-- Expected: 2025-01-01 – 2025-12-31


-- ============================================================
-- 4. JOIN INTEGRITY CHECK
-- Are there pedestrian counts with no matching sensor?
-- ============================================================
SELECT COUNT(*) AS unmatched_counts
FROM pedestrian_counts pc
LEFT JOIN sensor_locations sl ON pc.location_id = sl.location_id
WHERE sl.location_id IS NULL;
-- Expected: 0 (all 102 count locations have a matching sensor record)


-- ============================================================
-- 5. FLAG BAD VALUES
-- ============================================================
SELECT COUNT(*) AS negative_or_zero_counts
FROM pedestrian_counts
WHERE total_count < 0;

SELECT COUNT(*) AS future_dated_clue
FROM clue_businesses
WHERE census_year > YEAR(CURDATE());


-- ============================================================
-- 6. SPOT CHECK — PREVIEW EACH TABLE
-- ============================================================
SELECT * FROM clue_businesses   LIMIT 5;
SELECT * FROM sensor_locations  LIMIT 5;
SELECT * FROM pedestrian_counts LIMIT 5;





