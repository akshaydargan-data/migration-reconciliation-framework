-- =============================================
-- ORDERS MIGRATION VALIDATION
-- Source: BigQuery
-- Target: Snowflake
-- =============================================


-- 1. ROW COUNT
SELECT
    COUNT(*) AS row_count
FROM orders;


-- 2. UNIQUE ORDER IDS
SELECT
    COUNT(DISTINCT order_id) AS distinct_order_ids
FROM orders;


-- 3. DUPLICATE ORDER IDS
SELECT
    order_id,
    COUNT(*) AS record_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 4. NULL CHECKS
SELECT
    COUNTIF(channel IS NULL) AS null_channels
FROM orders;


-- 5. DATE RANGE
SELECT
    MIN(order_date) AS min_order_date,
    MAX(order_date) AS max_order_date
FROM orders;


-- 6. BUSINESS-LEVEL RECONCILIATION
SELECT
    order_date,
    channel,
    COUNT(*) AS order_count,
    SUM(quantity) AS total_quantity,
    SUM(revenue) AS total_revenue
FROM orders
GROUP BY
    order_date,
    channel
ORDER BY
    order_date,
    channel;