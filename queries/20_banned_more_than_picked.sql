-- 20. Герои, которых на патче банили чаще, чем брали.
-- Патч — matches.patch_id; в ответе пары с bans строго больше picks, diff = bans - picks.
--
-- Колонки: version, hero, bans, picks, diff
-- Порядок: diff по убыванию, затем hero по возрастанию, затем version по возрастанию
-- Строк:   99

WITH banned_heroes as (
    SELECT p.version, h.name as hero, count(mb.match_id) as bans
    FROM patches p
    INNER JOIN matches m on m.patch_id = p.patch_id
    INNER JOIN match_bans mb on mb.match_id = m.match_id
    INNER JOIN heroes h on h.hero_id = mb.hero_id
    GROUP BY p.version, h.name
), picked_heroes as (
    SELECT p.version, h.name as hero, count(mb.match_id) as picks
    FROM patches p
    INNER JOIN matches m on m.patch_id = p.patch_id
    INNER JOIN match_players mb on mb.match_id = m.match_id
    INNER JOIN heroes h on h.hero_id = mb.hero_id
    GROUP BY p.version, h.name
)
SELECT bh.version, bh.hero, bh.bans, ph.picks, bh.bans - ph.picks as diff
FROM banned_heroes bh
LEFT JOIN picked_heroes ph on bh.version = ph.version and bh.hero = ph.hero
WHERE bh.bans > ph.picks
ORDER BY bh.bans - ph.picks DESC, bh.hero ASC, bh.version ASC