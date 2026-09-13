with customer_results as (

    select
        'customers' as dataset,
        sum(source_customer_count) as source_row_count,
        sum(target_customer_count) as target_row_count,
        sum(target_customer_count) - sum(source_customer_count) as row_count_diff,
        count_if(reconciliation_status = 'PASS') as comparisons_passed,
        count_if(reconciliation_status = 'FAIL') as comparisons_failed
    from {{ ref('customers_reconciliation') }}

),

order_results as (

    select
        'orders' as dataset,
        sum(source_order_count) as source_row_count,
        sum(target_order_count) as target_row_count,
        sum(target_order_count) - sum(source_order_count) as row_count_diff,
        count_if(reconciliation_status = 'PASS') as comparisons_passed,
        count_if(reconciliation_status = 'FAIL') as comparisons_failed
    from {{ ref('orders_reconciliation') }}

)

select
    dataset,
    source_row_count,
    target_row_count,
    row_count_diff,
    comparisons_passed,
    comparisons_failed,
    case
        when row_count_diff = 0
         and comparisons_failed = 0
        then 'PASS'
        else 'FAIL'
    end as reconciliation_status
from customer_results

union all

select
    dataset,
    source_row_count,
    target_row_count,
    row_count_diff,
    comparisons_passed,
    comparisons_failed,
    case
        when row_count_diff = 0
         and comparisons_failed = 0
        then 'PASS'
        else 'FAIL'
    end as reconciliation_status
from order_results