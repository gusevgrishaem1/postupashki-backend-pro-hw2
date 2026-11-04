-- 17. Доля побед светлой стороны по патчам.
-- Патч без единого матча не выводится; radiant_winrate — процент,
-- round(100.0 * radiant_wins / matches, 2).
--
-- Колонки: version, matches, radiant_wins, radiant_winrate
-- Порядок: radiant_winrate (округлённое) по убыванию, при равенстве version по возрастанию
-- Строк:   12

SELECT
    pa.version,
    COUNT(DISTINCT m.match_id) AS matches,
    COUNT(DISTINCT ma.match_id) AS radiant_wins,
    ROUND(100.0 * COUNT(DISTINCT ma.match_id) / COUNT(DISTINCT m.match_id), 2) AS radiant_winrate
FROM patches AS pa
INNER JOIN matches AS m ON pa.patch_id = m.patch_id
LEFT JOIN matches AS ma ON pa.patch_id = ma.patch_id AND ma.winner = 'radiant'
GROUP BY pa.version
ORDER BY ROUND(100.0 * COUNT(DISTINCT ma.match_id) / COUNT(DISTINCT m.match_id), 2) DESC, pa.version ASC;
