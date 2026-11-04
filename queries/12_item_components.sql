-- 12. Сборные предметы внутри сборных предметов.
-- Пары «предмет — непосредственный компонент», где компонент сам встречается
-- в item_recipe.item_id; каждая пара один раз, component_cost — цена штуки.
--
-- Колонки: item_name, component_name, quantity, component_cost
-- Порядок: item_name по возрастанию, внутри предмета component_name по возрастанию
-- Строк:   36

SELECT
    i.name AS item_name,
    c.name AS component_name,
    ir.quantity,
    c.cost AS component_cost
FROM item_recipe AS ir
INNER JOIN items AS i ON i.item_id = ir.item_id
INNER JOIN items AS c ON c.item_id = ir.component_id
WHERE EXISTS (
    SELECT
        1
    FROM item_recipe AS cr
    WHERE cr.item_id = ir.component_id
)
ORDER BY i.name ASC, c.name ASC;
