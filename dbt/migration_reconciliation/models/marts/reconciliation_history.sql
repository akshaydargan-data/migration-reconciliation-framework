{{
    config(
        materialized='incremental'
    )
}}

select
    run_timestamp,
    dataset,
    check_name,
    issue_count,
    status
from {{ ref('reconciliation_report') }}

{% if is_incremental() %}

where run_timestamp > (
    select coalesce(max(run_timestamp), '1900-01-01'::timestamp)
    from {{ this }}
)

{% endif %}