{# Grain: one row per event_id that belongs to a duplicate (nfl_id, drill_name, attempt_raw) combination, with the rule applied. #}
select nfl_id, drill_name, attempt_raw, event_id, attempt_id, attempt,
       start_time, end_time, frames_player, chain_no, chain_event_count, combo_chain_count, combo_event_count,
       duplicate_resolution
from {{ ref('silver_combine_attempts') }}
where combo_event_count > 1
order by nfl_id, drill_name, attempt_raw, start_time
