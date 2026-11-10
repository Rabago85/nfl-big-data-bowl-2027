{{ config(severity='warn', tags=['B6']) }}
{# B6: game tracking is uniform except the 8 known gaps. Warns when more irregular intervals are found. #}
select count(*) as n_irregular_intervals, {{ var('expected')['irregular_game_intervals'] }} as expected_irregular
from {{ ref('diag_game_tracking_gaps') }}
having count(*) > {{ var('expected')['irregular_game_intervals'] }}
