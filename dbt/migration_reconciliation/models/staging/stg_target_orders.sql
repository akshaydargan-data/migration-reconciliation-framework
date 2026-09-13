select
    order_id,
    customer_id,
    cast(order_date as date) as order_date,
    lower(channel) as channel,
    product,
    quantity,
    revenue
from {{ ref('target_orders') }}