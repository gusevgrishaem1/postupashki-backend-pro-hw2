-- 09. Кто из стримеров за какую команду выступает сейчас.
-- Только действующие составы; стримеры без player_id не выводятся.
--
-- Колонки: streamer, platform, player, team, tag, followers
-- Порядок: followers по убыванию, при равенстве streamer по возрастанию
-- Строк:   16

SELECT
    s.nickname AS streamer,
    pl.name AS platform,
    p.nickname AS player,
    t.name AS team,
    t.tag,
    s.followers
FROM streamers AS s
INNER JOIN platforms AS pl ON pl.platform_id = s.platform_id
INNER JOIN players AS p ON p.player_id = s.player_id
INNER JOIN team_members AS tm ON p.player_id = tm.player_id AND tm.left_at IS NULL
INNER JOIN teams AS t ON t.team_id = tm.team_id
ORDER BY s.followers DESC, s.nickname ASC;
