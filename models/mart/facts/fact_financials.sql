
{{
  config(
    materialized = 'incremental',
    cluster_by=["created_at"],
    unique_key = 'invoice_id',
    
  )
}}
/*
    Tables
*/

WITH source AS (

    SELECT * FROM {{ ref('int_invoice_payment') }}
     {% if is_incremental() %}
        AND created_at > (SELECT MAX(created_at) FROM {{ this }}) 
    {% endif %}

),

/*
    Formatted
*/

formatted AS (
    SELECT
       --PK
        surrogate_key,

        --FK
        invoice_id,
        customer_id,
        subscription_id,
        payment_id,

        --Timestamp
        created_at,

        -- Price Information
        total_amount,
        tax_amount,
        discount_amount,
        net_amount
   FROM source
)

SELECT * FROM formatted