# Melbourne CBD Business & Foot Traffic Analysis

## Project Overview

A SQL-based analysis of Melbourne's commercial landscape and pedestrian activity using three official City of Melbourne open datasets. The project explores industry composition, post-COVID business recovery, commercial vacancy trends, and pedestrian behaviour across the CBD.

**Tools:** MySQL · MySQL Workbench · Tableau Public · GitHub

**Data Sources:** City of Melbourne Open Data Portal
- CLUE Business Establishments 2002–2024 (413,550 records)
- Pedestrian Counting System Hourly Counts 2025 (812,178 records)
- Pedestrian Sensor Locations (137 sensors)

**[View Tableau Dashboard](https://public.tableau.com/views/MelbourneCBDBusinessFootTrafficAnalysis/MelbourneCBDBusinessandFootTraffic?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

---

## Database Schema

Three tables joined via `Location_ID` (pedestrian counts → sensor locations) and suburb name (CLUE businesses → sensor descriptions).

| Table | Rows | Key columns |
|---|---|---|
| `clue_businesses` | 413,550 | census_year, clue_small_area, industry_description |
| `sensor_locations` | 137 | location_id, sensor_description, location_type |
| `pedestrian_counts` | 812,178 | location_id, sensing_date, hour_of_day, total_count |

---

## Key Business Questions & Findings

### Business Landscape (CLUE 2024)

**1. What are the most common industries in Melbourne CBD?**

Vacant Space dominates at 5,335 listings (27.1% of all entries), reflecting the elevated post-COVID vacancy rate. Among active businesses, Cafes & Restaurants lead with 1,677 establishments (8.5%), followed by Takeaway Food Services (707, 3.6%) and Legal Services (585, 3.0%). The full top 15:

| Industry | Establishments | % of Total |
|---|---|---|
| Vacant Space | 5,335 | 27.1% |
| Cafes and Restaurants | 1,677 | 8.5% |
| Takeaway Food Services | 707 | 3.6% |
| Legal Services | 585 | 3.0% |
| Hairdressing and Beauty Services | 425 | 2.2% |
| Other Auxiliary Finance and Investment Services | 363 | 1.8% |
| Specialist Medical Services | 359 | 1.8% |
| Computer System Design and Related Services | 339 | 1.7% |
| Management Advice and Other Consulting Services | 333 | 1.7% |
| Accommodation | 333 | 1.7% |
| Clothing Retailing | 284 | 1.4% |
| Other Personal Services n.e.c. | 279 | 1.4% |
| Technical and Vocational Education and Training | 264 | 1.3% |
| Pubs, Taverns and Bars | 262 | 1.3% |
| Real Estate Services | 260 | 1.3% |

**2. Which precincts have the highest business density?**

Melbourne CBD proper accounts for 10,767 establishments across 264 unique industries over 5× the next largest precinct. Docklands (1,714) and Carlton (1,336) follow. Melbourne CBD also has by far the most diverse industry mix.

| Precinct | Total Establishments | Unique Industries |
|---|---|---|
| Melbourne (CBD) | 10,767 | 264 |
| Docklands | 1,714 | 190 |
| Carlton | 1,336 | 151 |
| North Melbourne | 1,260 | 188 |
| Southbank | 1,139 | 169 |
| Port Melbourne | 681 | 184 |
| East Melbourne | 624 | 87 |
| West Melbourne (Residential) | 563 | 116 |
| Kensington | 557 | 142 |
| Parkville | 430 | 62 |

**3. How did business numbers change post-COVID?**

Total establishment counts remained remarkably stable throughout the study period, hovering between 19,460 and 19,912 from 2015–2024. The COVID impact on raw counts was modest: the biggest single-year drop was 2022 (−253 establishments, −1.3%). The real COVID story is told not by business closures but by the vacancy rate (see Q5).

| Census Year | Establishments | YoY Change | YoY % |
|---|---|---|---|
| 2015 | 19,482 | | |
| 2016 | 19,460 | −22 | −0.1% |
| 2017 | 19,598 | +138 | +0.7% |
| 2018 | 19,729 | +131 | +0.7% |
| 2019 | 19,730 | +1 | 0.0% |
| 2020 | 19,749 | +19 | +0.1% |
| 2021 | 19,912 | +163 | +0.8% |
| 2022 | 19,659 | −253 | −1.3% |
| 2023 | 19,671 | +12 | +0.1% |
| 2024 | 19,672 | +1 | 0.0% |

**4. Which industries grew or shrank between 2019 and 2024?**

Every industry in this result declined over the 2019–2024 period. The biggest losers were Computer System Design (−280), Other Auxiliary Finance & Investment Services (−175), and Cafes & Restaurants (−125). The decline in tech and finance likely reflects the permanent shift to remote/hybrid work reducing CBD office presence, while hospitality losses reflect changed dining patterns post-COVID.

| Industry | 2019 Count | 2024 Count | Net Change |
|---|---|---|---|
| Computer System Design and Related Services | 619 | 339 | −280 |
| Other Auxiliary Finance and Investment Services | 538 | 363 | −175 |
| Cafes and Restaurants | 1,802 | 1,677 | −125 |
| Employment Placement and Recruitment Services | 237 | 139 | −98 |
| Travel Agency and Tour Arrangement Services | 136 | 46 | −90 |
| Legal Services | 673 | 585 | −88 |
| Womens Clothing Retailing | 210 | 124 | −86 |
| Management Advice and Other Consulting Services | 405 | 333 | −72 |
| Other Personal Services n.e.c. | 348 | 279 | −69 |
| Real Estate Services | 329 | 260 | −69 |

**5. How has commercial vacancy changed over time?**

This is where COVID's impact is stark. Vacancy sat around 14–16% from 2015–2019, then surged to 23.8% in 2020 and peaked at 29.7% in 2022. By 2024 it had only marginally recovered to 27.1% nearly double the pre-pandemic rate indicating that Melbourne CBD's commercial real estate market has not yet returned to pre-COVID health.

| Year | Vacant Spaces | Total Establishments | Vacancy Rate |
|---|---|---|---|
| 2015 | 3,127 | 19,482 | 16.1% |
| 2016 | 2,899 | 19,460 | 14.9% |
| 2017 | 2,874 | 19,598 | 14.7% |
| 2018 | 2,961 | 19,729 | 15.0% |
| 2019 | 3,011 | 19,730 | 15.3% |
| 2020 | 4,705 | 19,749 | 23.8% |
| 2021 | 5,401 | 19,912 | 27.1% |
| 2022 | 5,831 | 19,659 | 29.7% |
| 2023 | 5,573 | 19,671 | 28.3% |
| 2024 | 5,335 | 19,672 | 27.1% |

---

### Foot Traffic (Pedestrian Counting System 2025)

**6. Which locations have the highest pedestrian volumes?**

Flinders Lane–Swanston St (West) is the busiest point in the CBD, recording over 14.1 million pedestrian counts in 2025 with an average of 1,611 per sensor per hour. Town Hall (West) and the Elizabeth St–Flinders St (East) footpath are close behind. All top locations are outdoor sensors concentrated around the Flinders/Swanston hub.

| Location | Total Pedestrians | Avg Hourly | Peak Hourly |
|---|---|---|---|
| Flinders La-Swanston St (West) | 14,108,851 | 1,611 | 5,411 |
| Town Hall (West) | 13,586,917 | 1,551 | 6,217 |
| Elizabeth St - Flinders St (East) - New footpath | 10,635,950 | 1,214 | 5,424 |
| State Library - New | 10,362,503 | 1,205 | 5,087 |
| Princes Bridge | 9,667,018 | 1,104 | 7,381 |
| Melbourne Central | 9,515,455 | 1,086 | 4,805 |
| Melbourne Central-Elizabeth St (East) | 7,971,626 | 910 | 4,320 |
| Spencer St-Collins St (North) | 7,839,042 | 903 | 3,634 |
| Bourke Street Mall (North) | 7,360,021 | 979 | 4,467 |
| 368 Elizabeth Street | 6,831,468 | 1,014 | 3,202 |

**7. When do people move around the CBD most?**

Pedestrian activity follows a clear tri-modal pattern. A morning commuter peak occurs at 8:00am (406 avg/sensor), plateauing through the mid-morning. A lunch peak emerges at 12:00–13:00 (717–730 avg/sensor). The largest peak is the **evening peak at 17:00 (5pm)** with 801 avg/sensor the busiest hour of the day tapering off through the evening. The city is at its quietest between 3:00am–5:00am.

| Hour | Avg Per Sensor | Hour | Avg Per Sensor |
|---|---|---|---|
| 0 (midnight) | 90 | 12 | 717 |
| 1 | 56 | 13 | 730 |
| 2 | 36 | 14 | 663 |
| 3 | 27 | 15 | 666 |
| 4 | 20 | 16 | 719 |
| 5 | 30 | **17 (peak)** | **801** |
| 6 | 82 | 18 | 650 |
| 7 | 190 | 19 | 514 |
| 8 | 406 | 20 | 422 |
| 9 | 380 | 21 | 357 |
| 10 | 418 | 22 | 276 |
| 11 | 519 | 23 | 172 |

**8. Are weekdays or weekends busier?**

Weekdays dominate Friday is the busiest day of the week (48.8M total pedestrians, avg 420/hr). Sunday is the quietest by a clear margin (39.3M total, avg 338/hr). Saturday performs similarly to Thursday, suggesting the CBD draws strong weekend foot traffic from retail and hospitality, but weekday commuter and office activity still drives overall volume.

| Day | Total Pedestrians | Avg Hourly Per Sensor |
|---|---|---|
| Sunday | 39,304,231 | 338 |
| Monday | 39,870,782 | 348 |
| Tuesday | 43,851,483 | 381 |
| Wednesday | 46,400,048 | 394 |
| Thursday | 47,726,799 | 413 |
| **Friday** | **48,799,409** | **420** |
| Saturday | 48,181,579 | 413 |

**Bonus Monthly seasonality:**

December and March are the busiest months (422 and 419 avg/hr respectively), likely reflecting Christmas/summer activity and the start of the academic/business year. June is the quietest month (335 avg/hr), consistent with Melbourne winter dampening foot traffic.

| Month | Monthly Total | Avg Hourly |
|---|---|---|
| January | 24,399,500 | 364 |
| February | 22,544,865 | 371 |
| March | 28,494,149 | 419 |
| April | 26,893,025 | 403 |
| May | 24,958,027 | 366 |
| June | 21,385,426 | 335 |
| July | 26,356,048 | 381 |
| August | 27,804,301 | 399 |
| September | 25,830,944 | 380 |
| October | 29,115,494 | 408 |
| November | 26,525,213 | 386 |
| December | 29,827,339 | 422 |

**Cross-dataset: Hospitality venues × nearby foot traffic**

Using a fuzzy suburb-name join, Melbourne CBD has the most hospitality venues (1,611) and substantial nearby pedestrian volume. Southbank, despite fewer venues (189), records 12.3M nearby pedestrian counts high foot traffic per venue. Docklands has 223 hospitality venues but only 1.16M nearby counts from matching sensors, suggesting its pedestrian counting coverage in this dataset is limited.

| Precinct | Hospitality Venues | Nearby Sensors | Total Nearby Pedestrians |
|---|---|---|---|
| Melbourne (CBD) | 1,611 | 3 | 23,727,096 |
| Carlton | 239 | 0 | |
| Docklands | 223 | 2 | 1,164,788 |
| Southbank | 189 | 3 | 12,344,264 |
| North Melbourne | 115 | 12 | 46,849,060 |
| East Melbourne | 34 | 8 | 30,790,187 |
| South Yarra | 9 | 19 | 67,856,680 |

---

## Tableau Dashboard

The interactive Tableau dashboard includes 5 visualisations:

1. **Top 15 Industries in Melbourne CBD (2024)** horizontal bar chart ranked by establishment count, with Vacant Space as a separate category to highlight commercial vacancy
2. **Melbourne CBD Business Count & Year-on-Year Growth (2015–2024)** dual-axis line chart showing absolute business count (left axis) and YoY % change (right axis), with COVID annotation
3. **Melbourne Industry Growth vs Decline: 2019 to 2024** diverging bar chart of net change by industry, showing all industries that lost establishments over the five-year post-COVID period
4. **Melbourne CBD Commercial Vacancy Rate (2015–2024)** area chart showing vacancy rate surging from ~15% pre-COVID to nearly 30% post-COVID
5. **Average Hourly Pedestrian Activity Across Melbourne CBD (2025)** line chart with annotated morning, lunch, and evening peaks, plus reference lines at key hours

**[View the full dashboard on Tableau Public](https://public.tableau.com/views/MelbourneCBDBusinessFootTrafficAnalysis/MelbourneCBDBusinessandFootTraffic?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

---

## Data Limitations & Notes

- The pedestrian counts dataset (2025) only contains readings from outdoor sensors. The 34 indoor sensors in the locations table had no corresponding count data in this export; only 102 of 137 sensors returned results.
- Query 12 uses a fuzzy `LIKE` join between suburb names and sensor descriptions as a proxy for geographic proximity. A production environment would use a spatial/GIS join based on coordinates.
- The CLUE dataset does not include an employee count column in the standard export; all analysis is based on establishment counts only.
- Year-on-year business counts appear stable in part because "Vacant Space" is recorded as its own industry category closures are captured as vacancies rather than deletions, which is why the vacancy rate is the more sensitive indicator of COVID impact.

---

## SQL Concepts Used

- Multi-table `INNER JOIN` and `LEFT JOIN`
- CTEs (`WITH` clause)
- `CASE WHEN` conditional aggregation
- Subqueries in `WHERE` and `FROM` clauses
- Date functions: `DAYNAME`, `MONTH`, `DATE_FORMAT`
- Aggregate functions: `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`
- Window functions: `SUM() OVER()`
- Data validation: null checks, join integrity testing, bad value flags

---

## How to Reproduce

1. Install MySQL 8.0 and MySQL Workbench
2. Download the three datasets from the [City of Melbourne Open Data Portal](https://data.melbourne.vic.gov.au/)
3. Run `schema.sql` to create the database and tables
4. Import CSVs using `LOAD DATA LOCAL INFILE`
5. Run `queries.sql` for all analysis queries
