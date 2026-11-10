{{ config(severity='warn', tags=['B9']) }}
{# B9: non-preseason player_play rows per player must not exceed career offensive + defensive snaps
   and must be close to them (ratio >= b9_min_ratio). #}
select *
from {{ ref('diag_career_snaps_reconciliation') }}
where career_off_def_snaps > 0
  and ( player_play_rows_non_preseason > career_off_def_snaps + {{ var('thresholds')['b9_row_excess_tolerance'] }}
        or player_play_rows_non_preseason * 1.0 / career_off_def_snaps < {{ var('thresholds')['b9_min_ratio'] }} )
