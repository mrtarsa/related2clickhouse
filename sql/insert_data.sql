INSERT INTO a0 (day, id) VALUES
    ('2019-01-01', 9),
    ('2019-01-01', 10), ('2019-01-01', 13),
    ('2019-01-01', 11), ('2019-01-01', 14), ('2019-01-01', 17)

INSERT INTO b0 (day, id) VALUES
    ('2019-01-01', 9),
    ('2019-01-01', 10), ('2019-01-01', 13),
    ('2019-01-01', 11), ('2019-01-01', 14), ('2019-01-01', 17)

INSERT INTO a1 (day, id) VALUES
    ('2019-01-01', 9),
    ('2019-01-01', 10), ('2019-01-01', 13),
    ('2019-01-01', 11), ('2019-01-01', 14), ('2019-01-01', 17)

INSERT INTO b1 (day, id) VALUES
    ('2019-01-01', 9),
    ('2019-01-01', 10), ('2019-01-01', 13),
    ('2019-01-01', 11), ('2019-01-01', 14), ('2019-01-01', 17)

-- Select data

-- With local join
-- DB::Exception: Distributed table should have an alias when distributed_product_mode set to local..
SELECT id, count()
FROM a0 a0
LEFT JOIN b0 b0 ON a0.id = b0.id
GROUP BY id
-- SELECT id, count() FROM db0.a0_replicated AS a0 ALL LEFT JOIN b0 AS b0 ON a0.id = b0.id GROUP BY id

-- Without local join
SELECT id, count()
FROM (SELECT id FROM a0) a0
LEFT JOIN (SELECT id FROM b0) b0 ON a0.id = b0.id
GROUP BY id

-- DB::Exception: Table db0.b1 doesn't exist..
SELECT id, count()
FROM a1 a1
LEFT JOIN b1 b1 ON a1.id = b1.id
GROUP BY id
-- SELECT id, count() FROM a1_replicated ALL LEFT JOIN b1 ON id = b1.id GROUP BY id
-- Uses default_database=db0 that was set in config.xml
-- But, in comparison to a1, does not translate b1 into b1_replicated

-- DB::Exception: Table default.b1_replicated doesn't exist
SELECT id, count()
FROM a1 a1
LEFT JOIN (SELECT id FROM b1 b1) b1 ON a1.id = b1.id
GROUP BY id
-- Does not use default_database=db0 that was set in config.xml

-- Without local join
SELECT id, count()
FROM (SELECT id FROM a1) a1
LEFT JOIN (SELECT id FROM b1) b1 ON a1.id = b1.id
GROUP BY id

-- Show query plan
SELECT
    query,
    type,
    event_time,
    is_initial_query,
    result_rows
FROM system.query_log
WHERE
    type IN (2, 3, 4)
    AND position(query, 'system') = 0
    AND dateDiff('second', event_time, now()) < 600
ORDER BY event_time DESC
LIMIT 10
