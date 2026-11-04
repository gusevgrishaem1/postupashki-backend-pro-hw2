-- 25. Место стримера-профессионала в рейтинге своей страны.
-- Только стримеры с player_id и действующей записью в team_members; место по mmr
-- по убыванию и country_players считаются по всей players; player — ник из players.
--
-- Колонки: player, country, mmr, country_rank, country_players, team_tag, platform
-- Порядок: country по возрастанию, внутри страны country_rank по возрастанию
-- Строк:   16

WITH ranked_players as (
    SELECT
        p.player_id,
        p.nickname as player,
        p.country  as country,
        p.mmr      as mmr,
        RANK()  OVER (PARTITION BY country ORDER BY mmr DESC) as country_rank,
        COUNT(*) OVER (PARTITION BY country) as country_players
    FROM players p
)
SELECT rp.player, rp.country, rp.mmr, rp.country_rank, rp.country_players, t.tag as team_tag, pl.name  as platform
FROM ranked_players rp
INNER JOIN team_members tm on rp.player_id = tm.player_id and tm.left_at is NULL
INNER JOIN teams t on t.team_id = tm.team_id
INNER JOIN streamers s on s.player_id = rp.player_id
INNER JOIN platforms pl on pl.platform_id = s.platform_id
ORDER BY rp.country ASC, rp.country_rank ASC