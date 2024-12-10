with
/*The country_pair_revenue CTE calculates the total revenue between each pair of seller and buyer countries.*/
country_pair_revenue as (
    select 
        seller_country.country as seller_country,
        buyer_country.country as buyer_country,
        sum(sales.revenue) as total_revenue
    from analytics.sandbox_edet.sales
    inner join analytics.sandbox_edet.country as seller_country
        on sales.id_seller_country = seller_country.id_country
    inner join analytics.sandbox_edet.country as buyer_country
        on sales.id_buyer_country = buyer_country.id_country 
    group by seller_country, buyer_country
),

/*The AggregatedRevenue CTE aggregates the revenues for both directions between two countries. 
For instance, if france sells to germany and vice versa, the revenues for both directions are summed up*/
aggregatedrevenue as (
    select
        case 
            when seller_country < buyer_country then seller_country
            else buyer_country
        end as country_1,
        case 
            when seller_country > buyer_country then seller_country
            else buyer_country
        end as country_2,
        sum(total_revenue) as aggregated_revenue
    from country_pair_revenue
    group by country_1, country_2
)
/*The final SELECT statement sorts the aggregated revenues in descending order 
and fetches the topmost row(using the limit 1), which represents the pair of countries with the best relationship in terms of revenue.*/
select 
    country_1,
    country_2,
    aggregated_revenue
from aggregatedrevenue
order by aggregated_revenue desc
limit 1;
