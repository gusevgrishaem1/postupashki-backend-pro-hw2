-- 09. Кто из стримеров за какую команду выступает сейчас.
-- Только действующие составы; стримеры без player_id не выводятся.
--
-- Колонки: streamer, platform, player, team, tag, followers
-- Порядок: followers по убыванию, при равенстве streamer по возрастанию
-- Строк:   16

SELECT  s.nickname as streamer, pf.name as platform, p.nickname as player, t.name as team, t.tag, s.followers
from streamers s
inner join platforms pf on pf.platform_id = s.platform_id
inner join players p on p.player_id = s.player_id
inner join team_members tm on p.player_id = tm.player_id and tm.left_at IS NULL
inner join teams t on t.team_id = tm.team_id
order by s.followers DESC, pf.name ASC