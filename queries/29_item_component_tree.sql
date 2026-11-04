-- 29. Полное дерево сборки Guardian Greaves, Bloodthorn, Harpoon и Hurricane Pike.
-- Строка на каждый путь вниз, сам корень не выводится; lvl с 1, qty — quantity последнего
-- шага, qty_total — произведение quantity по пути, path — имена от корня через ' > '.
--
-- Колонки: root_item, lvl, component, qty, qty_total, path
-- Порядок: root_item по возрастанию, затем path по возрастанию
-- Строк:   34

with recursive tree as (
    select i.name as root_item, 1 as lvl, it.name as component, ir.quantity as qty, ir.quantity as qty_total, i.name || ' > ' || it.name as path, it.item_id as curr_id
    from items i
    inner join item_recipe ir on ir.item_id = i.item_id
    inner join items it on it.item_id = ir.component_id
    where i.name in ('Guardian Greaves', 'Bloodthorn', 'Harpoon',  'Hurricane Pike')
    union all
    select t.root_item, t.lvl + 1, it.name as component, ir.quantity as qty, t.qty_total *  ir.quantity as qty_total, t.path || ' > ' || it.name as path, it.item_id as curr_id
    from tree t
    inner join item_recipe ir on ir.item_id = t.curr_id
    inner join items it on ir.component_id = it.item_id
) select
          root_item, lvl, component, qty, qty_total ,path
  from tree
  order by root_item ASC, path ASC
