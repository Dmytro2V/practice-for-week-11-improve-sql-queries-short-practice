select * FROM cats LIMIT 10;
select * FROM toys LIMIT 10;
select * FROM cat_toys LIMIT 10;
.schema
----------
-- Step 0 - Create a Query 
----------
-- Query: Select all cats that have a toy with an id of 5

    -- Your code here

 select cat_id FROM cat_toys WHERE toy_id =5;

-- Paste your results below (as a comment):
-- 4002 31 77
----------
-- Step 1 - Analyze the Query
----------
-- Query:

    -- Your code here
   EXPLAIN QUERY PLAN select cat_id FROM cat_toys WHERE toy_id =5;

-- Paste your results below (as a comment):
    --SCAN TABLE cat_toys

-- What do your results mean?

    -- Was this a SEARCH or SCAN?
        -- SCAN

    -- What does that mean?
        -- going throw every record
        -- no inexes
        -- unordered table


----------
-- Step 2 - Time the Query to get a baseline
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here
.timer on
    select cat_id FROM cat_toys WHERE toy_id =5;
.timer off

-- Paste your results below (as a comment):
    -- Run Time: real 0.001 user 0.001219 sys 0.000000



----------
-- Step 3 - Add an index and analyze how the query is executing
----------

-- Create index:

    -- Your code here
    CREATE INDEX idx_cat_toys_toy_id 
    ON cat_toys (toy_id);
-- Analyze Query:
    -- Your code here
    EXPLAIN QUERY PLAN select cat_id FROM cat_toys WHERE toy_id =5;

-- Paste your results below (as a comment):
    -- SEARCH TABLE cat_toys USING INDEX idx_cat_toys_toy_id (toy_id=?)

-- Analyze Results:

    -- Is the new index being applied in this query 
        -- do
        -- SQL searching is planned
        -- ordered table




----------
-- Step 4 - Re-time the query using the new index
----------
-- Query (to be used in the sqlite CLI):

    -- Your code here
.timer on
    select cat_id FROM cat_toys WHERE toy_id =5;
.timer off

-- Paste your results below (as a comment):
    -- 4002 31 77
    -- Run Time: real 0.000 user 0.000112 sys 0.000000

-- Analyze Results:
    -- Are you still getting the correct query results?
        -- yes

    -- Did the execution time improve (decrease)?
        -- improved

    -- Do you see any other opportunities for making this query more efficient?
    -- no


---------------------------------
-- Notes From Further Exploration
---------------------------------