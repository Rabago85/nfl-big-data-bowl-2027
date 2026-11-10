{{ config(severity='warn', tags=['B10']) }}
select count(*) as n_players_without_tracking, {{ var('expected')['players_without_tracking'] }} as expected_n
from {{ ref('diag_missing_cohort_players') }}
having count(*) <> {{ var('expected')['players_without_tracking'] }}
