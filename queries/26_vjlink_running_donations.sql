-- 26. Нарастающая сумма донатов внутри каждого стрима Вжлинка за 2021 год.
-- Стримы Вжлинка, начавшиеся в 2021 году по UTC, строка на каждый донат; running_total —
-- нарастающая сумма донатов своего стрима по sent_at_sec.
--
-- Колонки: stream_id, title, sent_at_sec, donor, amount, running_total
-- Порядок: stream_id по возрастанию, внутри стрима sent_at_sec по возрастанию
-- Строк:   192

SELECT st.stream_id, st.title, sd.sent_at_sec, sd.nickname as donor, sd.amount,
       SUM(sd.amount) OVER (PARTITION BY st.stream_id ORDER BY sd.sent_at_sec, sd.donation_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM streamers s
INNER JOIN streams st on st.streamer_id = s.streamer_id
INNER JOIN stream_donations sd on sd.stream_id = st.stream_id
WHERE s.streamer_id = 17 and EXTRACT(YEAR FROM st.started_at AT TIME ZONE 'UTC')::int = 2021
ORDER BY st.stream_id ASC, sd.sent_at_sec ASC