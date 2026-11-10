{# O5. Grain: one row per season. Share of tracked sequences that contain each key event, and sequence length. #}
with seq as (
    select season, game_id, play_id, nfl_id, count(*) as n_frames,
        max(case when event = '{{ var("event_names")["ball_snap"] }}'    then 1 else 0 end) as has_ball_snap,
        max(case when event = '{{ var("event_names")["pass_forward"] }}' then 1 else 0 end) as has_pass_forward,
        max(case when event = '{{ var("event_names")["pass_arrived"] }}' then 1 else 0 end) as has_pass_arrived,
        max(case when event = '{{ var("event_names")["tackle"] }}'       then 1 else 0 end) as has_tackle,
        max(case when event is not null then 1 else 0 end) as has_any_event
    from {{ ref('silver_game_tracking') }}
    group by season, game_id, play_id, nfl_id
)
select season, count(*) as n_sequences, avg(n_frames) as avg_frames, min(n_frames) as min_frames, max(n_frames) as max_frames,
       avg(has_ball_snap) as share_ball_snap, avg(has_pass_forward) as share_pass_forward,
       avg(has_pass_arrived) as share_pass_arrived, avg(has_tackle) as share_tackle, avg(has_any_event) as share_any_event
from seq
group by season
