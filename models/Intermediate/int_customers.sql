{{
    config(
        materialized='incremental',
        unique_key='customer_id'
    )
}}
/*
    Tables
*/

WITH base AS (
    SELECT
        --PK 
        customer_id,

        --Details
        customer_name,
        customer_email,

        --Timestamps
        ingested_at,
        signup_date
    FROM {{ ref('base_customers') }}
    {% if is_incremental() %}

  where ingested_at >= (select coalesce(max(ingested_at), '1900-01-01') from {{ this }})

{% endif %}

)
SELECT 
    * 
FROM base
