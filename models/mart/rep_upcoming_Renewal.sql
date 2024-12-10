WITH eligible_subscriptions AS (
    SELECT
        subscription_id,
        customer_id,
        product_id,
        start_date,
        end_date,
        subscription_status
    FROM {{ ref('dim_subscriptions') }}
    WHERE 
        -- Ensure the subscription is not cancelled or refunded
        subscription_status NOT IN ('cancelled', 'refunded')
        
        AND end_date >= CURRENT_DATE
),
upcoming_renewals AS (
    SELECT
        subscription_id,
        customer_id,
        product_id,
        end_date AS renewal_date,
        DATEDIFF(end_date, CURRENT_DATE) AS days_until_renewal
    FROM eligible_subscriptions
    WHERE 
        -- Check if the renewal date is within the next 30 days
        DATEDIFF(end_date, CURRENT_DATE) <= 30
)
SELECT
    r.subscription_id,
    r.customer_id,
    r.product_id,
    r.renewal_date,
    r.days_until_renewal,
    c.customer_name,
    c.customer_email,
    p.product_name
FROM upcoming_renewals r
LEFT JOIN {{ ref('dim_customers') }} c ON r.customer_id = c.customer_id
LEFT JOIN {{ ref('dim_products') }}  p ON r.product_id = p.product_id
ORDER BY r.days_until_renewal ASC;
