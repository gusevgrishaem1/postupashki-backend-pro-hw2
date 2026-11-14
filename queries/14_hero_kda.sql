-- 14. Средние убийства, смерти и помощь у ходовых героев.
-- Только герои с games >= 420; средние — round(avg(x), 2) по numeric, два знака.
--
-- Колонки: hero, games, avg_kills, avg_deaths, avg_assists
-- Порядок: avg_kills (округлённое) по убыванию, при равенстве hero по возрастанию
-- Строк:   29

SELECT
    h.name AS hero,
    COUNT(m.match_id) AS games,
    ROUND(AVG(mp.kills), 2) AS avg_kills,
    ROUND(AVG(mp.deaths), 2) AS avg_deaths,
    ROUND(AVG(mp.assists), 2) AS avg_assists
FROM match_players AS mp
JOIN heroes AS h ON h.hero_id = mp.hero_id
JOIN matches AS m ON m.match_id = mp.match_id
GROUP BY h.name
HAVING COUNT(m.match_id) >= 420
ORDER BY ROUND(AVG(mp.kills), 2) DESC, h.name ASC;
