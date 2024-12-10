
/*
    Tables
*/

WITH raw_data AS (

    SELECT * FROM {{ source('persionio_core', 'payments') }}

),

formatted AS (
    SELECT
       -- PK
        CAST(payment_id AS STRING) AS payment_id,

        -- FK
        CAST(invoice_id AS STRING) AS invoice_id,

        --Timestamps
        CAST(payment_date AS DATETIME) AS payment_date,
        CAST(updated_at AS DATETIME) AS updated_at,

        --Details
        CAST(method AS STRING) AS payment_method,

        -- Price Information
        CAST(amount AS FLOAT) AS payment_amount,
        
        
    FROM raw_data 
)
SELECT
   *
FROM formatted

