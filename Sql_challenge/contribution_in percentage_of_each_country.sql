with
/*The CountrySales CTE calculates the total revenue (TOTAL_REVENUE) 
and the total number of items sold (TOTAL_ITEMS_SOLD) for each country. 
This is achieved by joining the Sales table with the Country table on the seller country ID. */
CountrySales as (
    select
        country.country,
        sum(sales.revenue) as total_revenue,
        count(sales.ID_ORDER) as total_items_sold
    from  analytics.sandbox_edet.sales 
    inner join analytics.sandbox_edet.country
    on sales.id_seller_country = country.id_country
    group by country.country
),

/*The TotalSales CTE calculates the grand total revenue and items sold across all countries.*/
totalsales as (
    select 
        sum(total_revenue) as grand_total_revenue,
        sum(total_items_sold) as grand_total_items
    from CountrySales
)

/*The final select statement calculates the contribution of each country in terms of revenue 
and items sold by dividing the country-specific totals by the grand totals.*/
select 
    country,
    (total_revenue / grand_total_revenue) * 100 as revenue_contribution,
    (total_items_sold / grand_total_items) * 100 as items_contribution
from CountrySales, TotalSales