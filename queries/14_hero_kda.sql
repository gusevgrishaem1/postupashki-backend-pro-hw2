-- 14. Средние убийства, смерти и помощь у ходовых героев.
-- Только герои с games >= 420; средние — round(avg(x), 2) по numeric, два знака.
--
-- Колонки: hero, games, avg_kills, avg_deaths, avg_assists
-- Порядок: avg_kills (округлённое) по убыванию, при равенстве hero по возрастанию
-- Строк:   29

SELECT h.name as hero, count(m.match_id) as games,  round(avg(mp.kills), 2) as avg_kills,  round(avg(mp.deaths), 2) as avg_deaths,  round(avg(mp.assists), 2) as avg_assists
FROM match_players mp
JOIN heroes h on h.hero_id = mp.hero_id
JOIN matches m on m.match_id = mp.match_id
GROUP BY h.name
HAVING count(m.match_id) >= 420
ORDER BY  round(avg(mp.kills), 2) DESC, h.name ASC

