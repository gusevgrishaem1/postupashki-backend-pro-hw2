-- 23. Игроки, поигравшие больше чем за одну команду.
-- Считаются различные team_id по всем периодам, строго больше одного; current_team —
-- название команды с пустым left_at, current_team и streamer могут быть NULL.
--
-- Колонки: player, country, teams_count, current_team, streamer
-- Порядок: teams_count по убыванию, при равенстве player по возрастанию
-- Строк:   25

SELECT
    p.nickname AS player,
    p.country,
    (
        SELECT
            COUNT(DISTINCT tm.team_id)
        FROM team_members AS tm
        WHERE tm.player_id = p.player_id
    ) AS teams_count,
    t.name AS current_team,
    s.nickname AS streamer
FROM players AS p
LEFT JOIN team_members AS tm ON tm.player_id = p.player_id AND tm.left_at IS NULL
LEFT JOIN teams AS t ON t.team_id = tm.team_id
LEFT JOIN streamers AS s ON s.player_id = p.player_id
WHERE (
    SELECT
        COUNT(DISTINCT tm.team_id)
    FROM team_members AS tm
    WHERE tm.player_id = p.player_id
) > 1
ORDER BY teams_count DESC, p.nickname ASC;
