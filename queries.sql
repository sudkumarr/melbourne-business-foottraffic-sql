-- ============================================================
-- Query 1
-- ============================================================
SELECT
    industry_description                AS industry,
    COUNT(*)                            AS num_establishments,
    ROUND(COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(), 1)        AS pct_of_total
FROM clue_businesses
WHERE census_year = (SELECT MAX(census_year) FROM clue_businesses)
    AND industry_description IS NOT NULL
GROUP BY industry_description
ORDER BY num_establishments DESC
LIMIT 15;

-- ============================================================
-- Query 2
-- ============================================================


SELECT
    clue_small_area,
    COUNT(*)            AS total_establishments,
    COUNT(DISTINCT industry_description) AS unique_industries
FROM clue_businesses
WHERE census_year = (SELECT MAX(census_year) FROM clue_businesses)
GROUP BY clue_small_area
ORDER BY total_establishments DESC;


-- ============================================================
-- Query 3
-- ============================================================

SELECT
    clue_small_area,
    industry_description,
    COUNT(*) AS num_venues
FROM clue_businesses
WHERE census_year = (SELECT MAX(census_year) FROM clue_businesses)
    AND industry_description IN (
        'Cafes and Restaurants',
        'Pubs, Taverns and Bars',
        'Takeaway Food Services'
    )
GROUP BY clue_small_area, industry_description
ORDER BY clue_small_area, num_venues DESC;


-- ============================================================
-- Query 4
-- ============================================================

WITH yearly AS (
    SELECT
        census_year,
        COUNT(*) AS establishments
    FROM clue_businesses
    WHERE census_year >= 2015
    GROUP BY census_year
)
SELECT
    curr.census_year,
    curr.establishments,
    prev.establishments                                             AS prev_year,
    curr.establishments - prev.establishments                       AS yoy_change,
    ROUND(
        (curr.establishments - prev.establishments) * 100.0
        / prev.establishments, 1
    )                                                               AS yoy_pct_change
FROM yearly curr
LEFT JOIN yearly prev ON curr.census_year = prev.census_year + 1
ORDER BY curr.census_year ASC;



-- ============================================================
-- Query 5
-- ============================================================

SELECT
    industry_description,
    SUM(CASE WHEN census_year = 2019 THEN 1 ELSE 0 END) AS count_2019,
    SUM(CASE WHEN census_year = 2024 THEN 1 ELSE 0 END) AS count_2024,
    SUM(CASE WHEN census_year = 2024 THEN 1 ELSE 0 END) -
    SUM(CASE WHEN census_year = 2019 THEN 1 ELSE 0 END) AS net_change
FROM clue_businesses
WHERE census_year IN (2019, 2024)
    AND industry_description NOT IN ('Vacant Space')
GROUP BY industry_description
HAVING count_2019 > 10 AND count_2024 > 10
ORDER BY net_change ASC
LIMIT 20;


-- ============================================================
-- Query 6
-- ============================================================

SELECT
    census_year,
    SUM(CASE WHEN industry_description = 'Vacant Space' THEN 1 ELSE 0 END)     AS vacant_count,
    COUNT(*)                                                                    AS total_establishments,
    ROUND(
        SUM(CASE WHEN industry_description = 'Vacant Space' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 1
    )                                                                           AS vacancy_rate_pct
FROM clue_businesses
WHERE census_year >= 2015
GROUP BY census_year
ORDER BY census_year ASC;


-- ============================================================
-- Query 7
-- ============================================================

SELECT
    sl.sensor_description,
    sl.location_type,
    SUM(pc.total_count)                 AS total_pedestrians,
    ROUND(AVG(pc.total_count), 0)       AS avg_hourly_count,
    MAX(pc.total_count)                 AS peak_hourly_count
FROM pedestrian_counts pc
INNER JOIN sensor_locations sl ON pc.location_id = sl.location_id
GROUP BY sl.location_id, sl.sensor_description, sl.location_type
ORDER BY total_pedestrians DESC
LIMIT 15;


-- ============================================================
-- Query 8
-- ============================================================


SELECT
    DAYNAME(sensing_date)               AS day_of_week,
    DAYOFWEEK(sensing_date)             AS day_num,
    SUM(total_count)                    AS total_pedestrians,
    ROUND(AVG(total_count), 0)          AS avg_hourly_count
FROM pedestrian_counts pc
INNER JOIN sensor_locations sl ON pc.location_id = sl.location_id
GROUP BY DAYNAME(sensing_date), DAYOFWEEK(sensing_date)
ORDER BY day_num ASC;


-- ============================================================
-- Query 9
-- ============================================================

SELECT
    hour_of_day,
    SUM(total_count)                    AS total_pedestrians,
    ROUND(AVG(total_count), 0)          AS avg_per_sensor,
    MAX(total_count)                    AS peak_single_hour
FROM pedestrian_counts pc
INNER JOIN sensor_locations sl ON pc.location_id = sl.location_id
GROUP BY hour_of_day
ORDER BY hour_of_day ASC;


-- ============================================================
-- Query 10
-- ============================================================

SELECT
    MONTH(sensing_date)                 AS month_num,
    DATE_FORMAT(sensing_date, '%M')     AS month_name,
    SUM(total_count)                    AS monthly_total,
    ROUND(AVG(total_count), 0)          AS avg_hourly
FROM pedestrian_counts pc
INNER JOIN sensor_locations sl ON pc.location_id = sl.location_id
GROUP BY MONTH(sensing_date), DATE_FORMAT(sensing_date, '%M')
ORDER BY month_num ASC;


-- ============================================================
-- Query 11
-- ============================================================

SELECT
    sl.location_type,
    COUNT(DISTINCT sl.location_id)      AS sensors_with_data,
    SUM(pc.total_count)                 AS total_pedestrians,
    ROUND(AVG(pc.total_count), 0)       AS avg_hourly_count,
    MAX(pc.total_count)                 AS peak_hourly_count
FROM pedestrian_counts pc
INNER JOIN sensor_locations sl ON pc.location_id = sl.location_id
GROUP BY sl.location_type;

-- ============================================================
-- Query 12
-- ============================================================


WITH hospitality_suburbs AS (
    SELECT
        clue_small_area,
        COUNT(*) AS hospitality_venues
    FROM clue_businesses
    WHERE census_year = 2024
        AND industry_description IN (
            'Cafes and Restaurants',
            'Pubs, Taverns and Bars',
            'Takeaway Food Services'
        )
    GROUP BY clue_small_area
    ORDER BY hospitality_venues DESC
),
sensor_traffic AS (
    SELECT
        sl.sensor_description,
        SUM(pc.total_count) AS total_pedestrians
    FROM pedestrian_counts pc
    INNER JOIN sensor_locations sl ON pc.location_id = sl.location_id
    GROUP BY sl.sensor_description
)
SELECT
    hs.clue_small_area,
    hs.hospitality_venues,
    COUNT(st.sensor_description)        AS nearby_sensors,
    SUM(st.total_pedestrians)           AS total_nearby_pedestrians
FROM hospitality_suburbs hs
LEFT JOIN sensor_traffic st
    ON st.sensor_description LIKE CONCAT('%',
        SUBSTRING_INDEX(hs.clue_small_area, ' ', 1), '%')
GROUP BY hs.clue_small_area, hs.hospitality_venues
ORDER BY hs.hospitality_venues DESC;


