with customer_duplicate_check as (

    select
        'customers' as dataset,
        'duplicate_customer_id' as check_name,
        count(*) - count(distinct customer_id) as issue_count
    from {{ ref('stg_target_customers') }}

),

customer_null_region_check as (

    select
        'customers' as dataset,
        'null_region' as check_name,
        count_if(region is null) as issue_count
    from {{ ref('stg_target_customers') }}

),

order_duplicate_check as (

    select
        'orders' as dataset,
        'duplicate_order_id' as check_name,
        count(*) - count(distinct order_id) as issue_count
    from {{ ref('stg_target_orders') }}

),

order_null_channel_check as (

    select
        'orders' as dataset,
        'null_channel' as check_name,
        count_if(channel is null) as issue_count
    from {{ ref('stg_target_orders') }}

),

all_checks as (

    select * from customer_duplicate_check
    union all
    select * from customer_null_region_check
    union all
    select * from order_duplicate_check
    union all
    select * from order_null_channel_check

)

select
    dataset,
    check_name,
    issue_count,
    case
        when issue_count = 0 then 'PASS'
        else 'FAIL'
    end as status
from all_checks