-- 22. Стримеры с подписчиками выше среднего по своей площадке.
-- Строго больше среднего по всем стримерам площадки, сам стример в среднее входит;
-- platform_avg до 2 знаков; team — тег действующей команды, иначе NULL.
--
-- Колонки: streamer, platform, followers, platform_avg, team
-- Порядок: followers по убыванию, при равенстве streamer по возрастанию
-- Строк:   16

SELECT s.nickname as streamer, p.name as platform, s.followers as followers, (select round(avg(ss.followers), 2) from streamers ss WHERE ss.platform_id = p.platform_id) as platform_avg, t.tag as team
FROM streamers s
inner join platforms p on p.platform_id = s.platform_id
left join team_members tm on tm.player_id = s.player_id and tm.left_at is NULL
left join teams t on t.team_id = tm.team_id
where s.followers > (select avg(ss.followers) from streamers ss WHERE ss.platform_id = p.platform_id)
order by s.followers DESC, s.nickname ASC