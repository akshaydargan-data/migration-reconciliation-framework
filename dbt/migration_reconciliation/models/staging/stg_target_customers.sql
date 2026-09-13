select
    customer_id,
    cast(signup_date as date) as signup_date,
    lower(region) as region,
    lower(customer_status) as customer_status,
    lower(customer_segment) as customer_segment,
    lifetime_value
from {{ ref('target_customers') }}