CREATE DATABASE IF NOT EXISTS customer_churn_analysis;

USE customer_churn_analysis;

SELECT DATABASE();
USE customer_churn_analysis;

CREATE TABLE customer_master (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(20),
    age INT,
    email VARCHAR(150),
    city VARCHAR(100),
    state VARCHAR(100),
    region VARCHAR(50),
    city_tier VARCHAR(30),
    signup_date DATE,
    acquisition_channel VARCHAR(50),
    email_opt_in VARCHAR(20),
    loyalty_member VARCHAR(20),
    preferred_device VARCHAR(50),

    total_orders INT,
    total_quantity INT,
    total_revenue DECIMAL(12,2),
    average_order_value DECIMAL(12,2),

    first_purchase_date DATE,
    last_purchase_date DATE,
    days_since_last_purchase INT,

    churn_status VARCHAR(30),
    customer_status VARCHAR(30),

    total_deliveries INT,
    delayed_deliveries INT,
    delivery_delay_rate DECIMAL(8,2),
    avg_delivery_delay_days DECIMAL(8,2),
    avg_delivery_rating DECIMAL(8,2),
    avg_delivery_attempts DECIMAL(8,2),

    campaigns_received INT,
    campaigns_opened INT,
    campaigns_clicked INT,
    campaigns_converted INT,
    campaigns_unsubscribed INT,

    total_marketing_cost DECIMAL(12,2),
    avg_discount_offered DECIMAL(8,2),
    open_rate DECIMAL(8,2),
    click_rate DECIMAL(8,2),
    conversion_rate DECIMAL(8,2),
    unsubscribe_rate DECIMAL(8,2),

    is_repeat_customer INT,
    historical_clv DECIMAL(12,2),
    clv_segment VARCHAR(30),

    first_purchase_month VARCHAR(20),
    risk_segment VARCHAR(30),
    winback_priority VARCHAR(30)
);
SHOW TABLES;
USE customer_churn_analysis;

SHOW TABLES;
USE customer_churn_analysis;

SHOW TABLES;
SELECT DATABASE();

SHOW TABLES;
SHOW TABLES FROM customer_churn_analysis;
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name = 'customer_master';
USE customer_churn_analysis;

SHOW TABLES;
USE customer_churn_analysis;

SELECT COUNT(*) AS total_customers
FROM customer_master;
SELECT *
FROM customer_master
LIMIT 5;
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM customer_master;
SHOW WARNINGS;
SHOW WARNINGS LIMIT 20;



SELECT 
    risk_segment,
    COUNT(*) AS customers
FROM customer_churn_analysis.customer_master
GROUP BY risk_segment;

SELECT
    CASE
        WHEN days_since_last_purchase >= 60 THEN 'High Risk'
        WHEN days_since_last_purchase >= 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_segment,
    COUNT(*) AS customers
FROM customer_churn_analysis.customer_master
WHERE total_orders > 0
GROUP BY
    CASE
        WHEN days_since_last_purchase >= 60 THEN 'High Risk'
        WHEN days_since_last_purchase >= 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END;
    
    
    UPDATE customer_churn_analysis.customer_master
SET risk_segment =
    CASE
        WHEN days_since_last_purchase >= 60 THEN 'High Risk'
        WHEN days_since_last_purchase >= 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END
WHERE total_orders > 0;


SELECT
    risk_segment,
    COUNT(*) AS customers
FROM customer_churn_analysis.customer_master
GROUP BY risk_segment;


SELECT
    COUNT(*) AS null_risk_customers,
    SUM(CASE WHEN total_orders = 0 THEN 1 ELSE 0 END) AS never_purchased
FROM customer_churn_analysis.customer_master
WHERE risk_segment IS NULL;


SELECT 
    winback_priority,
    COUNT(*) AS customers
FROM customer_churn_analysis.customer_master
GROUP BY winback_priority;



UPDATE customer_churn_analysis.customer_master
SET winback_priority =
    CASE
        WHEN risk_segment = 'High Risk'
             AND clv_segment = 'High Value'
            THEN 'Critical'

        WHEN risk_segment = 'High Risk'
             AND clv_segment = 'Medium Value'
            THEN 'High'

        WHEN risk_segment = 'Medium Risk'
             AND clv_segment = 'High Value'
            THEN 'High'

        WHEN total_orders > 0
            THEN 'Standard'

        ELSE NULL
    END;
    
    SELECT
    winback_priority,
    COUNT(*) AS customers
FROM customer_churn_analysis.customer_master
GROUP BY winback_priority;