-- Show active long-running queries
SELECT
  pid, now() - pg_stat_activity.query_start AS duration,
  query, state, wait_event_type, wait_event
FROM pg_stat_activity
WHERE state != 'idle'
  AND (now() - pg_stat_activity.query_start) > interval '5 minutes'
ORDER BY duration DESC;
