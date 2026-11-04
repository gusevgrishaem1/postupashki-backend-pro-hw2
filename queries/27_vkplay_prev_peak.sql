-- 27. Пик онлайна против пика предыдущего эфира того же стримера.
-- Только площадка 'VK Play Live'; prev_peak — пик предыдущего по started_at эфира того
-- же стримера, delta — их разность; первый эфир каждого стримера не выводится.
--
-- Колонки: streamer, followers, started_at, title, peak_viewers, prev_peak, delta
-- Порядок: followers по убыванию, внутри стримера started_at по возрастанию
-- Строк:   592

WITH pre_q as (
SELECT s.nickname as streamer,
                      s.followers,
                      st.started_at,
                      st.title,
                      st.peak_viewers,
                      LAG(st.peak_viewers) OVER (PARTITION BY st.streamer_id ORDER BY st.started_at) as prev_peak
               FROM platforms p
                        INNER JOIN streamers s on s.platform_id = p.platform_id
                        INNER JOIN streams st on st.streamer_id = s.streamer_id
               WHERE p.name = 'VK Play Live'
               ) SELECT q.streamer, q.followers, q.started_at, q.title, q.peak_viewers, q.prev_peak, q.peak_viewers - q.prev_peak as delta
                 FROM pre_q q
                WHERE q.prev_peak IS NOT NULL
                ORDER BY q.followers DESC, q.started_at ASC