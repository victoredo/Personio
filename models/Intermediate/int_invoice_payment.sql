
/*
    Tables
*/
WITH invoices AS (
    SELECT
        invoice_id,
        surrogate_key,
        customer_id,
        subscription_id,
        created_at,
        total_amount,
        tax_amount
    FROM {{ ref('base_invoices') }}
),
subscriptions AS (
    SELECT
        subscription_id,
        discount_amount
    FROM {{ ref('base_subscriptions') }}
),
payments AS (
    SELECT
        payment_id,
        payment_date,
        
    FROM {{ ref('base_payments') }}

)

/*
    Formatted
*/
formatted AS (
SELECT
    i.invoice_id,
    i.customer_id,
    i.surrogate_key,
    i.subscription_id,
    p.payment_id,
    i.created_at,
    i.total_amount,
    i.tax_amount,
    COALESCE(s.discount_amount, 0) AS discount_amount
    COALESCE(i.total_amount - s.discount_amount, 0) AS net_amount,
FROM invoices i
LEFT JOIN subscriptions s ON i.subscription_id = s.subscription_id 
LEFT JOIN payments p ON i.invoice_id = p.payment_invoice_id;
)

SELECT * FROM formatted