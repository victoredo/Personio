
{{
    config(
            cluster_by=["created_at"],
            materialized='incremental'
    )
}}
/*
    Tables
*/

WITH raw_data AS (

    SELECT * FROM {{ source('persionio_core', 'events') }}
     {% if is_incremental() %}
        AND created_at > (SELECT MAX(created_at) FROM {{ this }}) 
    {% endif %}

),


/*
    Formatted
*/

formatted as (
    select 
       -- Timestamps
        CAST(created_at AS DATETIME) AS created_at,
        CAST(ingested_at AS DATETIME) AS ingested_at,

        --Details
        CAST(event_id AS STRING) AS event_id, 
        CAST(event_name AS STRING) AS event_name,
        CAST(json AS VARIANT) AS json 
    from  raw_data
)

SELECT
    *
FROM formatted

