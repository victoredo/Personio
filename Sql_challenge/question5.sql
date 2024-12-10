-- Create a temporary table or subquery containing the updates
create temporary table analytics.sandbox_edet.countryupdates as (
  select 246 as id_country, 'SPACE' as region, 'Mars' as country
  union all
  select id_country, 'OCEA', country
  from analytics.sandbox_edet.country 
  where country in ('Australia', 'New Zealand')
);

-- Merge the updates into the main table
merge into analytics.sandbox_edet.country  as target
using analytics.sandbox_edet.countryupdates as source
on target.id_country = source.id_country
when matched then
  update set target.region = source.region
when not matched then
  insert (id_country, region, country)
  values (source.id_country, source.region, source.country);


-- delete the row with id_country = 0
delete from analytics.sandbox_edet.country where id_country = 0;