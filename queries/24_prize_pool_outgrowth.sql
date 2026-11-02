-- 24. Турниры, чей призовой фонд больше суммы призовых всех предыдущих.
-- Предыдущие — со строго меньшим started_at, сравнение строгое; у первого турнира
-- prev_total и prev_count нули, не NULL; matches_played — число матчей турнира.
--
-- Колонки: tournament, started_at, prize_pool, prev_total, prev_count, matches_played
-- Порядок: started_at по возрастанию
-- Строк:   2

SELECT t.name as tournament, t.started_at, t.prize_pool,
       coalesce((SELECT sum(tou.prize_pool) FROM tournaments tou where tou.started_at < t.started_at), 0) as prev_total,
       coalesce((SELECT COUNT(tou.tournament_id) FROM tournaments tou where tou.started_at < t.started_at), 0) as prev_count,
       count(m.match_id) as matches_played
FROM tournaments t
LEFT JOIN matches m on m.tournament_id = t.tournament_id
WHERE t.prize_pool > coalesce((SELECT sum(tou.prize_pool) FROM tournaments tou where tou.started_at < t.started_at), 0)
GROUP BY t.name, t.started_at, t.prize_pool
ORDER BY t.started_at ASC
