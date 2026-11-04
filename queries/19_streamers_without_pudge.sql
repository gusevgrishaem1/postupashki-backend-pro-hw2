-- 19. Стримеры, которые ни разу не брали Pudge.
-- Только стримеры с непустым player_id и без единой игры за 'Pudge'; team — тег
-- команды с left_at IS NULL, иначе пусто; games — все строки match_players игрока.
--
-- Колонки: streamer, platform, team, followers, games
-- Порядок: followers по убыванию, при равенстве streamer по возрастанию
-- Строк:   8

SELECT
    s.nickname AS streamer,
    pl.name AS platform,
    t.tag AS team,
    s.followers AS followers,
    COUNT(mp.match_id) AS games
FROM streamers AS s
INNER JOIN platforms AS pl ON pl.platform_id = s.platform_id
LEFT JOIN team_members AS tm ON tm.player_id = s.player_id AND tm.left_at IS NULL
LEFT JOIN teams AS t ON t.team_id = tm.team_id
INNER JOIN match_players AS mp ON mp.player_id = s.player_id
WHERE NOT EXISTS (
    SELECT
        *
    FROM match_players AS mp
    WHERE mp.hero_id = (
        SELECT
            hero_id
        FROM heroes
        WHERE name = 'Pudge'
    )
    AND s.player_id = mp.player_id
)
GROUP BY s.nickname, pl.name, t.tag, s.followers
ORDER BY s.followers DESC, s.nickname ASC;
