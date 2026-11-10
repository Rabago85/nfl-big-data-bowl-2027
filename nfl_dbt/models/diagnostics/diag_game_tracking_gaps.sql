{# B6 / handoff 5.3. Grain: one irregular interval (sequence + gap). Says whether the gap touches a snap or pass_forward frame. #}
with seq as (
    select season, game_id, play_id, nfl_id, time, event,
           lag(time)  over (partition by game_id, play_id, nfl_id order by time) as prev_time,
           lag(event) over (partition by game_id, play_id, nfl_id order by time) as prev_event
    from {{ ref('silver_game_tracking') }}
)
select
    season, game_id, play_id, nfl_id,
    prev_time, time as time_after_gap,
    (unix_micros(time) - unix_micros(prev_time)) / 1000000.0 as gap_seconds,
    prev_event, event as event_after_gap,
    (coalesce(prev_event, '') in ('{{ var("event_names")["ball_snap"] }}', '{{ var("event_names")["pass_forward"] }}')
     or coalesce(event, '')  in ('{{ var("event_names")["ball_snap"] }}', '{{ var("event_names")["pass_forward"] }}')) as touches_snap_or_pass_forward
from seq
where prev_time is not null
  and unix_micros(time) - unix_micros(prev_time) <> {{ var('frame_interval_us') }}
