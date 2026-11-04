-- 29. Полное дерево сборки Guardian Greaves, Bloodthorn, Harpoon и Hurricane Pike.
-- Строка на каждый путь вниз, сам корень не выводится; lvl с 1, qty — quantity последнего
-- шага, qty_total — произведение quantity по пути, path — имена от корня через ' > '.
--
-- Колонки: root_item, lvl, component, qty, qty_total, path
-- Порядок: root_item по возрастанию, затем path по возрастанию
-- Строк:   34

WITH RECURSIVE tree AS (
    SELECT
        i.name AS root_item,
        1 AS lvl,
        part.name AS component,
        ir.quantity AS qty,
        ir.quantity AS qty_total,
        i.name || ' > ' || part.name AS path,
        part.item_id AS component_id
    FROM items AS i
    INNER JOIN item_recipe AS ir ON ir.item_id = i.item_id
    INNER JOIN items AS part ON part.item_id = ir.component_id
    WHERE i.name IN ('Guardian Greaves', 'Bloodthorn', 'Harpoon', 'Hurricane Pike')
    UNION ALL
    SELECT
        t.root_item,
        t.lvl + 1,
        part.name AS component,
        ir.quantity AS qty,
        t.qty_total * ir.quantity AS qty_total,
        t.path || ' > ' || part.name AS path,
        part.item_id AS component_id
    FROM tree AS t
    INNER JOIN item_recipe AS ir ON ir.item_id = t.component_id
    INNER JOIN items AS part ON ir.component_id = part.item_id
)
SELECT
    root_item,
    lvl,
    component,
    qty,
    qty_total,
    path
FROM tree
ORDER BY root_item ASC, path ASC;
