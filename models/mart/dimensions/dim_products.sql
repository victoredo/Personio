

/*
    Tables
*/

WITH source AS (

    SELECT * FROM {{ ref('base_products') }}

),

/*
    Formatted
*/

formatted AS (
    SELECT
        --PK
        product_id,

        --Details

        product_name,
       product_category
   FROM source
)

SELECT * FROM formatted