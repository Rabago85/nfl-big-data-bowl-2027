{{ config(severity='error', tags=['silver_combine_attempts']) }}
{# After duplicate resolution, (nfl_id, drill_name, attempt) must identify exactly one logical attempt. #}
select nfl_id, drill_name, attempt, count(distinct attempt_id) as n_attempt_ids
from {{ ref('silver_combine_attempts') }}
group by nfl_id, drill_name, attempt
having count(distinct attempt_id) > 1
