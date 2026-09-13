select
    coalesce(s.order_date, t.order_date) as order_date,
    coalesce(s.channel, t.channel) as channel,

    s.order_count as source_order_count,
    t.order_count as target_order_count,
    coalesce(t.order_count, 0) - coalesce(s.order_count, 0) as order_count_diff,

    s.total_quantity as source_total_quantity,
    t.total_quantity as target_total_quantity,
    coalesce(t.total_quantity, 0) - coalesce(s.total_quantity, 0) as quantity_diff,

    s.total_revenue as source_total_revenue,
    t.total_revenue as target_total_revenue,
    coalesce(t.total_revenue, 0) - coalesce(s.total_revenue, 0) as revenue_diff,

    case
        when coalesce(t.order_count, 0) = coalesce(s.order_count, 0)
         and coalesce(t.total_quantity, 0) = coalesce(s.total_quantity, 0)
         and abs(coalesce(t.total_revenue, 0) - coalesce(s.total_revenue, 0)) <= 0.01
        then 'PASS'
        else 'FAIL'
    end as reconciliation_status

from {{ ref('int_source_orders_summary') }} s

full outer join {{ ref('int_target_orders_summary') }} t
    on s.order_date = t.order_date
   and s.channel = t.channel