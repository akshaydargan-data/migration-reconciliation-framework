with reconciliation_checks as (

    select
        dataset,
        'aggregate_reconciliation' as check_name,
        comparisons_failed as issue_count,
        reconciliation_status as status
    from {{ ref('reconciliation_summary') }}

),

quality_checks as (

    select
        dataset,
        check_name,
        issue_count,
        status
    from {{ ref('data_quality_summary') }}

),

all_checks as (

    select * from reconciliation_checks

    union all

    select * from quality_checks

)

select
    current_timestamp() as run_timestamp,
    dataset,
    check_name,
    issue_count,
    status
from all_checks
order by dataset, check_name