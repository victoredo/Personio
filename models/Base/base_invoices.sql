
{{
    config(
            cluster_by=["created_at"]
    )
}}
/*
    Tables
*/

WITH raw_data AS (

    SELECT * FROM {{ source('persionio_core', 'invoices') }}
    {{ add_rows_limit() }} 

),

/*
    Formatted
*/

formatted AS (
    SELECT
         {{
            dbt_utils.generate_surrogate_key(
                [
                    'invoice_id','status'
                    
                ]
            )
        }} AS surrogate_key, --the invoice could have a slowly changing dimension due to the status
                             -- hence the need to create a surrogate key at the base layer-
        -- PK
        CAST(invoice_id AS STRING) AS invoice_id,

        --Fk
        CAST(customer_id AS STRING) AS customer_id,
        CAST(subscription_id AS STRING) AS subscription_id,

        --Timestamps
        CAST(created_at AS DATETIME) AS  created_at,
        CAST(updated_at AS DATETIME) AS updated_at,

        --Details
       CAST(status AS STRING) AS  invoice_status,
       CAST(billing_address AS STRING) AS billing_address,

        -- Price Information
        CAST(total_amount AS FLOAT) AS total_amount,
        CAST(tax_amount AS FLOAT) AS tax_amount
        
        
    FROM raw_data 
)
SELECT
    *
FROM formatted



