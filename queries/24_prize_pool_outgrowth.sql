-- 24. Турниры, чей призовой фонд больше суммы призовых всех предыдущих.
-- Предыдущие — со строго меньшим started_at, сравнение строгое; у первого турнира
-- prev_total и prev_count нули, не NULL; matches_played — число матчей турнира.
--
-- Колонки: tournament, started_at, prize_pool, prev_total, prev_count, matches_played
-- Порядок: started_at по возрастанию
-- Строк:   2

SELECT
    tou.name AS tournament,
    tou.started_at,
    tou.prize_pool,
    COALESCE((
        SELECT SUM(previous_tournament.prize_pool)
        FROM tournaments AS previous_tournament
        WHERE previous_tournament.started_at < tou.started_at
    ), 0) AS prev_total,
    (
        SELECT COUNT(*)
        FROM tournaments AS previous_tournament
        WHERE previous_tournament.started_at < tou.started_at
    ) AS prev_count,
    COUNT(m.match_id) AS matches_played
FROM tournaments AS tou
LEFT JOIN matches AS m ON m.tournament_id = tou.tournament_id
WHERE tou.prize_pool > COALESCE((
    SELECT SUM(previous_tournament.prize_pool)
    FROM tournaments AS previous_tournament
    WHERE previous_tournament.started_at < tou.started_at
), 0)
GROUP BY tou.name, tou.started_at, tou.prize_pool
ORDER BY tou.started_at ASC;
