----------
-- Step 0 - Create a Query 
----------
-- Query: Find a count of `toys` records that have a price greater than
    -- 55 and belong to a cat that has the color "Olive".
    
    -- Your code here
    select count(*) FROM cat_toys 
        WHERE cat_id IN (SELECT id FROM cats WHERE color = 'Olive') 
        AND toy_id IN (SELECT id FROM toys WHERE price > 55)
    ;

-- Paste your results below (as a comment):
    -- 215




----------
-- Step 1 - Analyze the Query
----------
-- Query:

    -- Your code here
    EXPLAIN QUERY PLAN     select count(*) FROM cat_toys 
        WHERE cat_id IN (SELECT id FROM cats WHERE color = 'Olive') 
        AND toy_id IN (SELECT id FROM toys WHERE price > 55)
    ;

-- Paste your results below (as a comment):
    --SEARCH TABLE cat_toys USING INDEX idx_cat_toys_toy_id (toy_id=?)
    --LIST SUBQUERY 2
      --SCAN TABLE toys
    --LIST SUBQUERY 1
      --SCAN TABLE cats


-- What do your results mean?

    -- Was this a SEARCH or SCAN?
      -- search on mix table, scan on sides


    -- What does that mean?
        -- indexes only on mixed, ordered same




----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here
.timer on
    select count(*) FROM cat_toys 
        WHERE cat_id IN (SELECT id FROM cats WHERE color = 'Olive') 
        AND toy_id IN (SELECT id FROM toys WHERE price > 55)
    ;
.timer off
-- Paste your results below (as a comment):
    -- Run Time: real 0.008 user 0.007621 sys 0.000000



----------
-- Step 3 - Add an index and analyze how the query is executing
----------

-- Create index:

    -- Your code here
    CREATE INDEX idx_cats_color ON cats(color);
    CREATE INDEX idx_toys_price ON toys(price);
-- Analyze Query:
    -- Your code here

    EXPLAIN QUERY PLAN     select count(*) FROM cat_toys 
        WHERE cat_id IN (SELECT id FROM cats WHERE color = 'Olive') 
        AND toy_id IN (SELECT id FROM toys WHERE price > 55)
    ;
-- Paste your results below (as a comment):
    -- QUERY PLAN
     --SEARCH TABLE cat_toys USING INDEX idx_cat_toys_toy_id (toy_id=?)
       --LIST SUBQUERY 2
     --SEARCH TABLE toys USING COVERING INDEX idx_toys_price (price>?)
       --LIST SUBQUERY 1
   --SEARCH TABLE cats USING COVERING INDEX idx_cats_color (color=?)


-- Analyze Results:

    -- Is the new index being applied in this query?
        -- yes




----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here
.timer on
    select count(*) FROM cat_toys 
        WHERE cat_id IN (SELECT id FROM cats WHERE color = 'Olive') 
        AND toy_id IN (SELECT id FROM toys WHERE price > 55)
    ;
.timer off

-- Paste your results below (as a comment):
    -- Run Time: real 0.006 user 0.006091 sys 0.000000


-- Analyze Results:
    -- Are you still getting the correct query results?
        -- yes

    -- Did the execution time improve (decrease)?
        -- a bit

    -- Do you see any other opportunities for making this query more efficient?
        -- can try use join


---------------------------------
-- Notes From Further Exploration
---------------------------------
EXPLAIN QUERY PLAN select count(*) FROM 
            cat_toys JOIN cats ON (cats.id = cat_id)
            JOIN toys ON (toys.id = toy_id)
        WHERE  cats.color = 'Olive'
        AND  price > 55
    ;

.timer on
    select count(*) FROM 
            cat_toys JOIN cats ON (cats.id = cat_id)
            JOIN toys ON (toys.id = toy_id)
        WHERE  cats.color = 'Olive'
        AND  price > 55
    ;
.timer off
-- Run Time: real 0.006 user 0.005391 sys 0.000000
-- a bit better
