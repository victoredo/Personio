
/*
    Tables
*/

WITH raw_data AS (

    SELECT * FROM {{ source('persionio_core', 'customers') }}

),

/*
    Formatted
*/

formatted AS (
    SELECT
        -- PK
        CAST(customer_id AS STRING) AS customer_id,

        --Timestamps
        Csst(created_at AS TIMESTAMP) AS signup_date,
        CAST(ingested_at AS DATETIME) AS ingested_at,

        --Details
        CAST(name AS STRING) AS customer_name,
        CAST(email AS STRING) AS customer_email,
        CAST(method AS STRING) AS payment_method,
        CAST(billing_address AS STRING) AS billing_address,
        CAST(subscriptions_id AS STRING) AS subscriptions_id
        
    FROM raw_data 
    {{ add_rows_limit() }} 
)

SELECT
    *
FROM formatted
