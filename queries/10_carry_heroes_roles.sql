-- 10. Все роли героев, которые умеют быть керри.
-- Только герои с ролью 'carry'; у каждого выводятся все его роли, по строке на роль.
--
-- Колонки: name, primary_attr, attack_type, role
-- Порядок: name по возрастанию, внутри героя role по возрастанию
-- Строк:   47

SELECT h.name, h.primary_attr, h.attack_type, hr.role
FROM heroes h
inner join hero_roles hr on hr.hero_id = h.hero_id
WHERE exists(select * from hero_roles hr2 where hr2.hero_id = h.hero_id AND hr2.role = 'carry')
ORDER BY h.name ASC, hr.role ASC