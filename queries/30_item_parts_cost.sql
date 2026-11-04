-- 30. Стоимость сборки из базовых составляющих против собственной цены предмета.
-- Берутся предметы со строками в item_recipe, сборка раскрывается до базовых (тех, у кого
-- строк в item_recipe нет, свитки тоже), количества по пути перемножаются; diff = parts_cost - cost.
--
-- Колонки: name, cost, parts_cost, base_parts, diff
-- Порядок: diff по убыванию, при равенстве name по возрастанию
-- Строк:   77

with recursive tree as (
    SELECT
    ir.item_id as root_id,
    ir.component_id,
    ir.quantity as qty_total
    from item_recipe ir
    union all
    select t.root_id, ir.component_id, t.qty_total * ir.quantity as qty_total
    FROM tree t
    inner join item_recipe ir on ir.item_id = t.component_id
) select
      i.name, i.cost,
      sum(part.cost * t.qty_total) as parts_cost,
      sum(t.qty_total) as base_parts,
      sum(part.cost * t.qty_total) - i.cost as diff
  from tree t
inner join items i on i.item_id = t.root_id
inner join items part on part.item_id = t.component_id
where not exists(
    select * from item_recipe r
             where r.item_id = t.component_id
)
group by  i.name, i.cost
order by diff DESC, i.name ASC