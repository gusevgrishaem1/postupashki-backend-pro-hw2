-- 30. Стоимость сборки из базовых составляющих против собственной цены предмета.
-- Берутся предметы со строками в item_recipe, сборка раскрывается до базовых (тех, у кого
-- строк в item_recipe нет, свитки тоже), количества по пути перемножаются; diff = parts_cost - cost.
--
-- Колонки: name, cost, parts_cost, base_parts, diff
-- Порядок: diff по убыванию, при равенстве name по возрастанию
-- Строк:   77

WITH RECURSIVE tree AS (
    SELECT
        ir.item_id AS root_id,
        ir.component_id,
        ir.quantity AS qty_total
    FROM item_recipe AS ir
    UNION ALL
    SELECT
        t.root_id,
        ir.component_id,
        t.qty_total * ir.quantity AS qty_total
    FROM tree AS t
    INNER JOIN item_recipe AS ir ON ir.item_id = t.component_id
)
SELECT
    i.name,
    i.cost,
    SUM(part.cost * t.qty_total) AS parts_cost,
    SUM(t.qty_total) AS base_parts,
    SUM(part.cost * t.qty_total) - i.cost AS diff
FROM tree AS t
INNER JOIN items AS i ON i.item_id = t.root_id
INNER JOIN items AS part ON part.item_id = t.component_id
WHERE NOT EXISTS (
    SELECT
        *
    FROM item_recipe AS r
    WHERE r.item_id = t.component_id
)
GROUP BY i.name, i.cost
ORDER BY diff DESC, i.name ASC;
