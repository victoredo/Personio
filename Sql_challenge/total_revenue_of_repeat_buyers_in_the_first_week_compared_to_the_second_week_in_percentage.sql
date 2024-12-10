
with 
/*this cte calculates the weekly revenue for each buyer. it uses date_trunc to truncate the date to the beginning of each week 
and then groups by the buyer id and this truncated week start date.*/
weekbuyers as (
    select 
        id_buyer,
        date_trunc('week', to_date(date_payment)) as week_start,
        sum(revenue) as weekly_revenue
    from  analytics.sandbox_edet.sales
    group by id_buyer, week_start
),

/*this cte identifies buyers who made purchases in more than one week. it groups by the buyer id 
and uses having count(distinct week_start) > 1 to filter only those buyers who appear in multiple weeks.*/
repeatbuyers as (
    select 
        id_buyer
    from weekbuyers
    group by id_buyer
    having count(distinct week_start) > 1
),

/*this cte calculates the total revenue for the repeat buyers in the first and second weeks. it filters buyers who are in the repeatbuyers cte 
and weeks that are either the first week or the second week (first week + 7 days) for these repeat buyers.
select min(week_start) from weekbuyers where id_buyer in (select id_buyer from repeatbuyers): this subquery fetches the earliest (minimum) week start date where a purchase was made by any repeat buyer. 
it identifies the first week when any of the repeat buyers made a purchase.
dateadd('day', 7, ): this function adds 7 days to the date returned by the subquery.
and week_start in ( ): this part of the where clause filters the rows in weekbuyers to include only those where week_start is either the first week or the second week, as calculated above.
*/
week1week2revenue as (
    select 
        week_start,
        sum(weekly_revenue) as total_revenue
    from weekbuyers
    where id_buyer in (select id_buyer from repeatbuyers)
    and week_start in (
        (select min(week_start) from weekbuyers where id_buyer in (select id_buyer from repeatbuyers)),
        dateadd('day', 7, (select min(week_start) from weekbuyers where id_buyer in (select id_buyer from repeatbuyers)))
       )
    group by week_start
)

/*the final query calculates the percentage change in revenue from the first week to the second week. 
it uses the lag() window function to get the previous row's total_revenue for the calculation.
total_revenue - lag(total_revenue) over (order by week_start)calculates the difference in revenue between the current week (second week) 
and the previous week (first week).
*/
select 
    100 * (total_revenue - lag(total_revenue) over (order by week_start)) / lag(total_revenue) over (order by week_start) as percent_change
from week1week2revenue
order by week_start
