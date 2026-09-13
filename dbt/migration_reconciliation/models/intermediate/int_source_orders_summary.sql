select
    order_date,
    channel,
    count(*) as order_count,
    sum(quantity) as total_quantity,
    sum(revenue) as total_revenue
from {{ ref('stg_source_orders') }}
group by
    order_date,
    channel