-- 21. Турнирные выступления с KDA выше шестикратного среднего.
-- KDA = (kills + assists)::numeric / GREATEST(deaths, 1); порог — строго больше шести
-- средних KDA по всей match_players; только матчи турниров; kda округлить до 2 знаков.
--
-- Колонки: match_id, tournament, player, hero, kda
-- Порядок: kda по убыванию, при равенстве match_id, затем slot
-- Строк:   60

SELECT
    m.match_id,
    tou.name AS tournament,
    p.nickname AS player,
    h.name AS hero,
    ROUND((mp.kills + mp.assists)::numeric / GREATEST(mp.deaths, 1), 2) AS kda
FROM matches AS m
INNER JOIN tournaments AS tou ON tou.tournament_id = m.tournament_id
INNER JOIN match_players AS mp ON mp.match_id = m.match_id
INNER JOIN players AS p ON p.player_id = mp.player_id
INNER JOIN heroes AS h ON h.hero_id = mp.hero_id
WHERE (mp.kills + mp.assists)::numeric / GREATEST(mp.deaths, 1) > 6 * (
    SELECT
        AVG((kills + assists)::numeric / GREATEST(deaths, 1))
    FROM match_players
)
ORDER BY kda DESC, m.match_id ASC, mp.slot ASC;
