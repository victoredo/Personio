### ER Diagram

```mermaid

erDiagram

    %% Entities

    DIM_SUBSCRIPTION {
        string subscription_id PK
        string customer_id FK
        string product_id FK
        date start_date
        date end_date
        string subscription_status
    }

    DIM_CUSTOMER {
        string customer_id PK
        string customer_name
        string customer_email
        date signup_date
    }

    DIM_PRODUCT {
        string product_id PK
        string product_name
        string product_category
    }


    FACT_FINANCIALS {
        string invoice_id PK
        string customer_id FK
        string subscription_id FK
        string product_id FK
        decimal total_amount
        decimal discount_amount
        decimal tax_amount
        decimal payment_amount
        decimal net_revenue
        decimal outstanding_balance
        date invoice_created_at
    }

    %% Relationships
    
    
    DIM_CUSTOMER ||--o{ FACT_FINANCIALS : customer_id
    DIM_PRODUCT ||--o{ FACT_FINANCIALS : product_id
    DIM_SUBSCRIPTION ||--o{ FACT_FINANCIALS : subscription_id
    DIM_CUSTOMER ||--o{ DIM_SUBSCRIPTION : customer_id
    DIM_PRODUCT ||--o{ DIM_SUBSCRIPTION : product_id
   

```
## Case Study: Subscription Data Pipeline for Customer Success
### Overview
This project demonstrates the design and implementation of a subscription-based data pipeline to support analytics and operational needs, particularly for the Customer Success team. The goal is to enable tracking of subscription renewals, cross-sell opportunities, and key business metrics like revenue, retention, and churn.

# Key Features
## Staging Layer:

Standardized raw data into clean, structured tables.
Includes tables for customers, subscriptions, invoices, payments, products, and events.

## Intermediate Layer:

Normalized entities such as customers, subscriptions, and invoice_payments.
Combines invoices and payments into a unified financial view.

## Mart Layer:

Dimensional models designed for analytical ease:
dim_customer, dim_product, and dim_subscription.
fact_financials consolidates financial metrics like revenue, payments, and discounts.

## Customer Success Use Case:

Highlights customers with upcoming subscription renewals and suggests cross-sell opportunities.
Data exposed via BI dashboards, email reports, and CRM integration.