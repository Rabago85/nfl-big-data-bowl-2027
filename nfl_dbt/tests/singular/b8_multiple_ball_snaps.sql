{{ config(severity='warn', tags=['B8']) }}
select game_id, play_id, nfl_id, count(*) as n_ball_snap
from {{ ref('silver_game_tracking') }}
where event = '{{ var("event_names")["ball_snap"] }}'
group by game_id, play_id, nfl_id
having count(*) > 1
