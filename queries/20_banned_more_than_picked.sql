-- 20. Герои, которых на патче банили чаще, чем брали.
-- Патч — matches.patch_id; в ответе пары с bans строго больше picks, diff = bans - picks.
--
-- Колонки: version, hero, bans, picks, diff
-- Порядок: diff по убыванию, затем hero по возрастанию, затем version по возрастанию
-- Строк:   99

WITH banned_heroes AS (
    SELECT
        pa.version,
        h.name AS hero,
        COUNT(mb.match_id) AS bans
    FROM patches AS pa
    INNER JOIN matches AS m ON m.patch_id = pa.patch_id
    INNER JOIN match_bans AS mb ON mb.match_id = m.match_id
    INNER JOIN heroes AS h ON h.hero_id = mb.hero_id
    GROUP BY pa.version, h.name
), picked_heroes AS (
    SELECT
        pa.version,
        h.name AS hero,
        COUNT(mp.match_id) AS picks
    FROM patches AS pa
    INNER JOIN matches AS m ON m.patch_id = pa.patch_id
    INNER JOIN match_players AS mp ON mp.match_id = m.match_id
    INNER JOIN heroes AS h ON h.hero_id = mp.hero_id
    GROUP BY pa.version, h.name
)
SELECT
    bh.version,
    bh.hero,
    bh.bans,
    ph.picks,
    bh.bans - ph.picks AS diff
FROM banned_heroes AS bh
LEFT JOIN picked_heroes AS ph ON bh.version = ph.version AND bh.hero = ph.hero
WHERE bh.bans > ph.picks
ORDER BY bh.bans - ph.picks DESC, bh.hero ASC, bh.version ASC;
