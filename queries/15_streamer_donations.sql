-- 15. Сколько донатов собрал каждый стример.
-- В ответе все стримеры: без донатов donations = 0 и total_amount = 0.00;
-- team — команда с left_at IS NULL, иначе пусто.
--
-- Колонки: streamer, platform, team, donations, total_amount
-- Порядок: total_amount по убыванию, при равенстве streamer по возрастанию
-- Строк:   40

SELECT s.nickname as streamer, pl.name as platform, t.name as team, count(sd.donation_id) as donations, sum(sd.amount) as total_amount
FROM streamers s
INNER JOIN platforms pl on pl.platform_id = s.platform_id
LEFT JOIN players p on p.player_id = s.player_id
LEFT JOIN team_members mp on mp.player_id = p.player_id and mp.left_at IS NULL
LEFT JOIN teams t on t.team_id = mp.team_id
INNER JOIN streams str on str.streamer_id = s.streamer_id
LEFT JOIN stream_donations sd on sd.stream_id = str.stream_id
GROUP BY s.nickname, pl.name, t.name
ORDER BY sum(sd.amount) DESC, s.nickname ASC
