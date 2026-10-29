-- 08. Сколько в команде игроков и сколько среди них стримеров.
-- Считаются только незакрытые периоды; команда без состава остаётся
-- в ответе с нулями, стримеры без player_id не учитываются.
--
-- Колонки: name, tag, players_now, streamers_now
-- Порядок: players_now по убыванию, при равенстве name по возрастанию
-- Строк:   24

SELECT  t.name, t.tag, count(p.player_id) as players_now, count(s.streamer_id) as streamers_now
from teams t
left join team_members tm on t.team_id = tm.team_id and tm.left_at IS NULL
left join players p on p.player_id = tm.player_id
left join streamers s on s.player_id = p.player_id
group by t.name, t.tag
order by count(p.player_id) DESC, t.name ASC