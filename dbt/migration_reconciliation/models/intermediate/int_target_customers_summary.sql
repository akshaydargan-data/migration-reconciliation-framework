select
    region,
    customer_status,
    count(*) as customer_count,
    sum(lifetime_value) as total_lifetime_value
from {{ ref('stg_target_customers') }}
group by
    region,
    customer_status