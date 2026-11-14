-- 16. Десятка самых банимых героев.
-- bans — строки match_bans, picks — строки match_players, bans_per_pick =
-- round(bans::numeric / picks, 2); первые десять берутся после сортировки.
--
-- Колонки: hero, bans, picks, bans_per_pick
-- Порядок: bans по убыванию, при равенстве hero по возрастанию
-- Строк:   10


with bans as (
    SELECT
        h.hero_id,
        h.name as hero,
        COUNT(mb.match_id) AS bans
    FROM heroes AS h
    LEFT JOIN match_bans AS mb ON mb.hero_id = h.hero_id
    GROUP BY h.hero_id, h.name
), pick as (
    SELECT
        h.hero_id,
        h.name AS hero,
        COUNT(DISTINCT mp.match_id) AS picks
    FROM heroes AS h
    LEFT JOIN match_players AS mp ON mp.hero_id = h.hero_id
    GROUP BY h.hero_id, h.name
)
SELECT
    b.hero,
    b.bans,
    p.picks,
    ROUND(b.bans::numeric / NULLIF(p.picks::numeric, 0), 2) AS bans_per_pick
FROM bans b
LEFT JOIN pick p on p.hero_id = b.hero_id
ORDER BY b.bans DESC, p.hero ASC
LIMIT 10;
