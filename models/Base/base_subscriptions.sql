{{
    config(
            cluster_by=["created_at"]
    )
}}

/*
    Tables
*/

WITH raw_data AS (

    SELECT * FROM {{ source('persionio_core', 'subscriptions') }}

),

/*
    Formatted
*/

formatted AS (
    SELECT
       {{
            dbt_utils.generate_surrogate_key(
                [
                    'subscription_id ', 'invoice_id','status'
                    
                ]
            )
        }} AS surrogate_key, --the subscription model can have slowly changing dimension due to the status.
                                -- hence, it is needed to create a surogate key to define the grain of the table
       
        CAST(subscription_id AS STRING) AS subscription_id,
        
        -- FK
        CAST(customer_id AS STRING) AS customer_id,
        CAST(product_id AS STRING) AS product_id,
        CAST(invoice_id AS STRING) AS invoice_id,
        
        -- Timestamps
        CAST(start_date AS DATETIME) AS start_date,
        CAST(end_date AS DATETIME) AS end_date,
        CAST(created_at AS DATETIME) AS created_at,
        CAST(updated_at AS DATETIME) AS updated_at,
        
        -- Details
        CAST(status  AS STRING) AS subscription_status,

        -- Price Information
        CAST(amount AS FLOAT) AS subscription_amount,
        CAST(discount_amount AS FLOAT) AS discount_amount
        
    FROM raw_data 
)
SELECT
    *
FROM formatted
