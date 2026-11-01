-- 16. Десятка самых банимых героев.
-- bans — строки match_bans, picks — строки match_players, bans_per_pick =
-- round(bans::numeric / picks, 2); первые десять берутся после сортировки.
--
-- Колонки: hero, bans, picks, bans_per_pick
-- Порядок: bans по убыванию, при равенстве hero по возрастанию
-- Строк:   10

SELECT h.name as hero,
       count(DISTINCT mb.match_id) as bans,
       count(DISTINCT mp.match_id) as picks,
       round(count(DISTINCT mb.match_id)::numeric / nullif(count(DISTINCT mp.match_id), 0), 2) as bans_per_pick
FROM heroes h
LEFT JOIN match_players mp on mp.hero_id = h.hero_id
LEFT JOIN match_bans mb on mb.hero_id = h.hero_id
GROUP BY h.name
ORDER BY count(DISTINCT mb.match_id) DESC, h.name ASC
LIMIT 10;