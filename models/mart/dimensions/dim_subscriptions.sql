

/*
    Tables
*/

WITH source AS (

    SELECT * FROM {{ ref('int_subscriptions') }}

),

/*
    Formatted
*/

formatted AS (
    SELECT
       subscription_id,
        surrogate_key,
        invoice_id,
        product_id,
        start_date,
        end_date,
        subscription_status
   FROM source
)

SELECT * FROM formatted