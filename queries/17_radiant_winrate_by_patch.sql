-- 17. Доля побед светлой стороны по патчам.
-- Патч без единого матча не выводится; radiant_winrate — процент,
-- round(100.0 * radiant_wins / matches, 2).
--
-- Колонки: version, matches, radiant_wins, radiant_winrate
-- Порядок: radiant_winrate (округлённое) по убыванию, при равенстве version по возрастанию
-- Строк:   12

SELECT p.version, count(DISTINCT m.match_id) as matches, count(DISTINCT ma.match_id) as radiant_wins, round(100.0 * count(DISTINCT ma.match_id) / count(DISTINCT m.match_id), 2) as radiant_winrate
FROM patches p
INNER JOIN matches m on p.patch_id = m.patch_id
LEFT JOIN matches ma on p.patch_id = ma.patch_id and ma.winner = 'radiant'
GROUP BY p.version
ORDER BY round(100.0 * count(DISTINCT ma.match_id) / count(DISTINCT m.match_id), 2) DESC, p.version ASC