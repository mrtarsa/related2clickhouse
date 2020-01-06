SELECT
    query,
    type,
    event_time,
    is_initial_query,
    result_rows
FROM system.query_log
WHERE
    position(query, 'system') = 0
    AND dateDiff('second', event_time, now()) < 600
ORDER BY event_time DESC
LIMIT 10
