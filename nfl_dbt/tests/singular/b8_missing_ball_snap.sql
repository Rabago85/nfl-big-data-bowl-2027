{{ config(severity='warn', tags=['B8']) }}
{# Summary row if any tracked sequence has no ball_snap event ("most have exactly one"). #}
with seq as (
    select game_id, play_id, nfl_id,
           max(case when event = '{{ var("event_names")["ball_snap"] }}' then 1 else 0 end) as has_snap
    from {{ ref('silver_game_tracking') }}
    group by game_id, play_id, nfl_id
)
select count(*) as n_sequences, sum(1 - has_snap) as n_without_snap, avg(1 - has_snap) as share_without_snap
from seq
having sum(1 - has_snap) > 0
