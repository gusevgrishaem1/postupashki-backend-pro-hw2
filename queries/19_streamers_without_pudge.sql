-- 19. Стримеры, которые ни разу не брали Pudge.
-- Только стримеры с непустым player_id и без единой игры за 'Pudge'; team — тег
-- команды с left_at IS NULL, иначе пусто; games — все строки match_players игрока.
--
-- Колонки: streamer, platform, team, followers, games
-- Порядок: followers по убыванию, при равенстве streamer по возрастанию
-- Строк:   8

SELECT s.nickname as streamer, p.name as platform, t.tag as team, s.followers as followers, count(mp.match_id) as games
FROM streamers s
INNER JOIN platforms p on p.platform_id = s.platform_id
LEFT JOIN team_members tm on tm.player_id = s.player_id and tm.left_at IS NULL
LEFT JOIN teams t on t.team_id = tm.team_id
INNER JOIN match_players mp ON mp.player_id = s.player_id
WHERE not exists (select * from match_players mp where mp.hero_id = 14 and s.player_id = mp.player_id)
GROUP BY s.nickname, p.name, t.tag, s.followers
ORDER BY s.followers DESC, s.nickname ASC