{{ config(severity='warn', tags=['B13']) }}
{# B13: s ~ dis / 0.1. Fails (one summary row) if too large a share of PLAYER frames violate it. #}
with d as (
    select s, dis,
           unix_micros(time) - unix_micros(lag(time) over (partition by event_id, entity_type order by time)) as dt_us
    from {{ ref('silver_combine_tracking') }}
    where entity_type = 'PLAYER'
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
