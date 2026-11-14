-- 18. Призовые турниров, до которых добрались игроки команды.
-- Турнир в зачёт один раз, если игрок сыграл его матч в составе: joined_at <=
-- started_at::date < left_at (пустой left_at — сейчас); команды без турниров не выводятся.
--
-- Колонки: team, tag, tournaments, prize_total
-- Порядок: prize_total по убыванию, при равенстве team по возрастанию
-- Строк:   22

SELECT
    team,
    tag,
    COUNT(*) AS tournaments,
    SUM(prize_pool) AS prize_total
FROM (
    SELECT DISTINCT
        t.name AS team,
        t.tag,
        tou.tournament_id,
        tou.prize_pool
    FROM teams AS t
    INNER JOIN team_members AS tm ON t.team_id = tm.team_id
    INNER JOIN match_players AS mp ON mp.player_id = tm.player_id
    INNER JOIN matches AS m ON m.match_id = mp.match_id
    INNER JOIN tournaments AS tou ON tou.tournament_id = m.tournament_id
    WHERE tm.joined_at <= m.started_at::DATE
        AND (tm.left_at IS NULL OR tm.left_at > m.started_at::DATE)
) AS team_tournaments
GROUP BY team, tag
ORDER BY prize_total DESC, team ASC;
