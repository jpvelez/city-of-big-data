-- Find count of number of buildings that are active, proposed, and demolished.
-- Only 139 proposed, and 1 demolished. This column is probably useless.
SELECT 
	bldg_statu, count(*)
FROM 
	buildings
GROUP BY 
	bldg_statu;



-- Look at values of UNIT_NAME column.
SELECT 
	unit_name, count(*)
FROM 
	buildings
GROUP BY 
	unit_name
ORDER BY
	count(*) ASC;


-- Look at values of non_standard column
-- Used for structures not usually considered ‘buildings’. --- RESIDENTIAL GARAGE, MONUMENT, CTA PLATFORM, OTHER
SELECT 
	non_standa, count(*)
FROM 
	buildings
GROUP BY 
	non_standa
ORDER BY
	count(*) ASC;


-- Look for addresses on a certain street
SELECT
	f_add1,
	t_add1,
	pre_dir1,
	st_name1,
	st_type1

FROM
	buildings

WHERE
	f_add1 = 1528 AND st_name1 = 'BOSWORTH';


-- Look at distribution of numbers of year built
-- 45.58% (374192/820944) of buildings age info. 
SELECT
	year_built,
	count(*)

FROM
	buildings

GROUP BY
	year_built

ORDER BY
	count(*) ASC;

-- Number / percentages of buildings with addresses that have ages.
-- There are 488,992 buildings with addresses.
-- 11.58% (56634) of them lack age data.
WITH buildings_with_addresses AS (
	
	SELECT 
		*

	FROM 
		buildings

	WHERE 
		st_name1 IS NOT NULL)

SELECT
	year_built,
	count(*)

FROM
	buildings_with_addresses

GROUP BY
	year_built

ORDER BY
	year_built ASC;


-- Count up the number of buildings with no addresses.
-- Most of these will be garages and the like.
-- Result 40.43% of buildings lack addresses (331,952 out of 820,944)

-- First, create a new table from a subquery.
-- Tilemill works much faster if pulling from a new table.
CREATE TABLE no_address_buildings AS (
	SELECT * FROM buildings WHERE st_name1 IS NULL)
;

-- Then, count!
SELECT count(*)
FROM no_address_buildings;


-- Create table of buildings with addresses for mapping in Tilemill
-- NEXT STEP: visualize ones that have years vs. dont.
CREATE TABLE buildings_with_addresses AS (
	
	SELECT 
		*

	FROM 
		buildings

	WHERE 
		st_name1 IS NOT NULL);