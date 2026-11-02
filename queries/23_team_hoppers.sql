-- 23. Игроки, поигравшие больше чем за одну команду.
-- Считаются различные team_id по всем периодам, строго больше одного; current_team —
-- название команды с пустым left_at, current_team и streamer могут быть NULL.
--
-- Колонки: player, country, teams_count, current_team, streamer
-- Порядок: teams_count по убыванию, при равенстве player по возрастанию
-- Строк:   25

SELECT p.nickname as player, p.country, (select count(distinct tm.team_id) from team_members tm where tm.player_id = p.player_id) as teams_count, t.name current_team, s.nickname as streamer
FROM players p
LEFT JOIN team_members tm on tm.player_id = p.player_id and tm.left_at is null
LEFT JOIN teams t on t.team_id = tm.team_id
LEFT JOIN streamers s on s.player_id = p.player_id
WHERE (SELECT count(distinct tm.team_id) from team_members tm where tm.player_id = p.player_id)  > 1
ORDER BY teams_count DESC, p.nickname ASC