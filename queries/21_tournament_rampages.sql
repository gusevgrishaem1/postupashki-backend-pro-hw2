-- 21. Турнирные выступления с KDA выше шестикратного среднего.
-- KDA = (kills + assists)::numeric / GREATEST(deaths, 1); порог — строго больше шести
-- средних KDA по всей match_players; только матчи турниров; kda округлить до 2 знаков.
--
-- Колонки: match_id, tournament, player, hero, kda
-- Порядок: kda по убыванию, при равенстве match_id, затем slot
-- Строк:   60

SELECT
    m.match_id, t.name as tournament, p.nickname as player, h.name as hero, round((mp.kills + mp.assists)::numeric / GREATEST(mp.deaths, 1), 2) AS kda
FROM matches m
INNER JOIN tournaments t on t.tournament_id = m.tournament_id
INNER JOIN match_players mp on mp.match_id = m.match_id
INNER JOIN players p on p.player_id = mp.player_id
INNER JOIN heroes h on h.hero_id = mp.hero_id
WHERE (mp.kills + mp.assists)::numeric / GREATEST(mp.deaths, 1) > 6 * (
      SELECT avg((kills + assists)::numeric / GREATEST(deaths, 1))
      FROM match_players)
ORDER BY kda DESC, m.match_id ASC, mp.slot ASC