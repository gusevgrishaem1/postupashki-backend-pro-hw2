-- 17. Доля побед светлой стороны по патчам.
-- Патч без единого матча не выводится; radiant_winrate — процент,
-- round(100.0 * radiant_wins / matches, 2).
--
-- Колонки: version, matches, radiant_wins, radiant_winrate
-- Порядок: radiant_winrate (округлённое) по убыванию, при равенстве version по возрастанию
-- Строк:   12

SELECT
    pa.version,
    COUNT(*) AS matches,
    COUNT(*) FILTER (WHERE m.winner = 'radiant') AS radiant_wins,
    ROUND(
            100.0 * COUNT(*) FILTER (WHERE m.winner = 'radiant') / COUNT(*),
            2
    ) AS radiant_winrate
FROM patches AS pa
INNER JOIN matches AS m ON pa.patch_id = m.patch_id
GROUP BY pa.version
ORDER BY 100.0 * COUNT(*) FILTER (WHERE m.winner = 'radiant') / COUNT(*) DESC, pa.version ASC;
