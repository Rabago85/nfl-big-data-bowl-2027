{{ config(severity='error', tags=['B6']) }}
{# B6: combine tracking is uniformly 0.1 s within each (event_id, entity_type) sequence. #}
with d as (
    select event_id, entity_type, time,
           unix_micros(time) - unix_micros(lag(time) over (partition by event_id, entity_type order by time)) as dt_us
    from {{ ref('silver_combine_tracking') }}
)
select event_id, entity_type, count(*) as n_irregular, min(dt_us) as min_dt_us, max(dt_us) as max_dt_us
from d
where dt_us is not null and dt_us <> {{ var('frame_interval_us') }}
group by event_id, entity_type
