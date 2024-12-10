

/*
    Tables
*/

WITH raw_data AS (

    SELECT * FROM {{ source('persionio_core', 'products') }}

),

formatted AS (
    SELECT
        --PK
        CAST(product_id AS STRING) AS product_id,

        --Details

        CAST(product_name AS STRING) AS product_name,
        CAST(product_category AS STRING) AS product_category,
        
    FROM raw_data
)
SELECT
    *
FROM source;
