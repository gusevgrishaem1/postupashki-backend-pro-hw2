-- 07. Действующие составы: кто сейчас за кого играет.
-- Только незакрытые периоды (left_at IS NULL); игроки без команды не выводятся.
--
-- Колонки: nickname, country, mmr, team_name, joined_at
-- Порядок: joined_at по возрастанию, при равенстве nickname по возрастанию
-- Строк:   86

SELECT  p.nickname,  p.country,  p.mmr, t.name as team_name, tm.joined_at
from players p
inner join team_members tm on p.player_id = tm.player_id and tm.left_at IS NULL
inner join teams t on t.team_id = tm.team_id
order by tm.joined_at ASC, p.nickname ASC