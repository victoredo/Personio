## Intermediate Layer
The intermediate layer normalizes denormalized data from the raw tables. 

### Normalize Customer:
Remove subscription and billing details, focusing solely on attributes directly related to the customer (e.g., customer_name, email, signup_date).
Establish relationships with other tables via customer_id.

### Subscription Data:
Clean and organize subscription data by separating key details (e.g., amount, discount, status).
Create metrics like start_date, end_date, and subscription lifecycle.

### Invoice and Payment Linking:
Link invoices to subscriptions  using subscription_id and payments 

### Models in Intermediate:

1. int_customers.sql: Normalized customer details.

2. nt_subscriptions.sql: Subscription details with lifecycle metrics.

3. int_invoice_payment.sql: Linked to subscriptions and payments.
