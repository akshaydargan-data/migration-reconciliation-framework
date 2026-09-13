select
    coalesce(s.region, t.region) as region,
    coalesce(s.customer_status, t.customer_status) as customer_status,

    s.customer_count as source_customer_count,
    t.customer_count as target_customer_count,
    coalesce(t.customer_count, 0) - coalesce(s.customer_count, 0) as customer_count_diff,

    s.total_lifetime_value as source_total_lifetime_value,
    t.total_lifetime_value as target_total_lifetime_value,
    coalesce(t.total_lifetime_value, 0)
        - coalesce(s.total_lifetime_value, 0) as lifetime_value_diff,

    case
        when coalesce(t.customer_count, 0) = coalesce(s.customer_count, 0)
         and abs(
                coalesce(t.total_lifetime_value, 0)
                - coalesce(s.total_lifetime_value, 0)
             ) <= 0.01
        then 'PASS'
        else 'FAIL'
    end as reconciliation_status

from {{ ref('int_source_customers_summary') }} s

full outer join {{ ref('int_target_customers_summary') }} t
    on s.region = t.region
   and s.customer_status = t.customer_status