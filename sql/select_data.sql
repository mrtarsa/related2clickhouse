-- Query 1
SELECT id, count()
FROM a1 AS a1
LEFT JOIN b1 AS b1 ON a1.id = b1.id
GROUP BY id
-- DB::Exception: Table db0.b1 doesn't exist..
-- SELECT id, count() FROM a1_replicated ALL LEFT JOIN b1 ON id = b1.id GROUP BY id
-- Uses default_database=db0 that was set in config.xml
-- But, in comparison to a1, does not translate b1 into b1_replicated

-- Query 2
SELECT id, count()
FROM a1 AS a1
LEFT JOIN (SELECT id FROM b1) AS b1 ON a1.id = b1.id
GROUP BY id
-- DB::Exception: Table default.b1_replicated doesn't exist
-- Does not use default_database=db0 that was set in config.xml

-- Query 3
SELECT id, count()
FROM (SELECT id FROM a1) AS a1
LEFT JOIN (SELECT id FROM b1) AS b1 ON a1.id = b1.id
GROUP BY id
-- Without local joins
