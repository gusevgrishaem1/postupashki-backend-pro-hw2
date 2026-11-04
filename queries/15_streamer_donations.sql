-- 15. Сколько донатов собрал каждый стример.
-- В ответе все стримеры: без донатов donations = 0 и total_amount = 0.00;
-- team — команда с left_at IS NULL, иначе пусто.
--
-- Колонки: streamer, platform, team, donations, total_amount
-- Порядок: total_amount по убыванию, при равенстве streamer по возрастанию
-- Строк:   40

SELECT
    s.nickname AS streamer,
    pl.name AS platform,
    t.name AS team,
    COUNT(sd.donation_id) AS donations,
    SUM(sd.amount) AS total_amount
FROM streamers AS s
INNER JOIN platforms AS pl ON pl.platform_id = s.platform_id
LEFT JOIN players AS p ON p.player_id = s.player_id
LEFT JOIN team_members AS tm ON tm.player_id = p.player_id AND tm.left_at IS NULL
LEFT JOIN teams AS t ON t.team_id = tm.team_id
INNER JOIN streams AS st ON st.streamer_id = s.streamer_id
LEFT JOIN stream_donations AS sd ON sd.stream_id = st.stream_id
GROUP BY s.nickname, pl.name, t.name
ORDER BY SUM(sd.amount) DESC, s.nickname ASC;
