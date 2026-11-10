{{ config(severity='warn', tags=['B13']) }}
with d as (
    select s, dis,
           unix_micros(time) - unix_micros(lag(time) over (partition by game_id, play_id, nfl_id order by time)) as dt_us
    from {{ ref('silver_game_tracking') }}
),
stats as (
    select count(*) as n_checked,
           sum(case when abs(s - dis / 0.1) > {{ var('thresholds')['speed_dis_tolerance'] }} then 1 else 0 end) as n_off
    from d
    where dt_us = {{ var('frame_interval_us') }} and s is not null and dis is not null
)
select n_checked, n_off, n_off * 1.0 / n_checked as share_off
from stats
where n_checked > 0 and n_off * 1.0 / n_checked > {{ var('thresholds')['speed_dis_max_share'] }}
