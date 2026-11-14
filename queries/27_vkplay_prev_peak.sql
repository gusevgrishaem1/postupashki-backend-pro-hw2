-- 27. Пик онлайна против пика предыдущего эфира того же стримера.
-- Только площадка 'VK Play Live'; prev_peak — пик предыдущего по started_at эфира того
-- же стримера, delta — их разность; первый эфир каждого стримера не выводится.
--
-- Колонки: streamer, followers, started_at, title, peak_viewers, prev_peak, delta
-- Порядок: followers по убыванию, внутри стримера started_at по возрастанию
-- Строк:   592

WITH streams_with_previous_peak AS (
    SELECT
        s.nickname AS streamer,
        s.followers,
        st.started_at,
        st.title,
        st.peak_viewers,
        LAG(st.peak_viewers) OVER (PARTITION BY st.streamer_id ORDER BY st.started_at) AS prev_peak
    FROM platforms AS pl
    INNER JOIN streamers AS s ON s.platform_id = pl.platform_id
    INNER JOIN streams AS st ON st.streamer_id = s.streamer_id
    WHERE pl.name = 'VK Play Live'
)
SELECT
    sp.streamer,
    sp.followers,
    sp.started_at,
    sp.title,
    sp.peak_viewers,
    sp.prev_peak,
    sp.peak_viewers - sp.prev_peak AS delta
FROM streams_with_previous_peak AS sp
WHERE sp.prev_peak IS NOT NULL
ORDER BY sp.followers DESC, sp.started_at ASC;
