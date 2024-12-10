
WITH base AS (

    SELECT
        subscription_id,
        surrogate_key,
        invoice_id,
        product_id,
        start_date,
        end_date,
        subscription_status
    FROM {{ ref('stg_subscriptions') }}
)
SELECT * FROM base;
