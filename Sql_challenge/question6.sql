
/*WHERE MOD(id_buyer, 2) = 0: This filters the rows from the sales table where the id_buyer is an even number.
ARRAY_AGG(id_buyer): This aggregates the filtered id_buyer values into an array.
OBJECT_INSERT({}, 'Id_buyers', ARRAY_AGG(id_buyer)): This inserts the array of even id_buyer values into a new JSON object with the key 'Id_buyers'.
OBJECT_INSERT('Is_even', TRUE): This further updates the JSON object by adding a new key-value pair 'Is_even': TRUE.*/

select object_insert(object_insert({}, 'Id_buyers', array_agg(id_buyer)), 'Is_even', TRUE) as even_group
from  analytics.sandbox_edet.sales
where mod(id_buyer, 2) = 0

union

select object_insert(object_insert({}, 'Id_buyers', array_agg(id_buyer)), 'Is_even', FALSE) as odd_group
from  analytics.sandbox_edet.sales
where mod(id_buyer, 2) <> 0;