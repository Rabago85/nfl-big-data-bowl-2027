{{ config(liquid_clustered_by=['draft_year', 'event_id']) }}
{# grain: one frame = (event_id, entity_type, time). Exact duplicate frames are dropped; the
   attempt column is kept as attempt_raw (resolved attempt lives in silver_combine_attempts). #}
select distinct
    cast(draft_year as int)              as draft_year,
    {{ clean_str('event_id') }}          as event_id,
    cast(nfl_id as bigint)               as nfl_id,
    {{ clean_code('entity_type') }}      as entity_type,
    cast(time as timestamp)              as time,
    {{ clean_str('drill_type') }}        as drill_type,
    {{ clean_str('drill_name') }}        as drill_name,
    cast(attempt as int)                 as attempt_raw,
    cast(x as double)                    as x,
    cast(y as double)                    as y,
    cast(s as double)                    as s,
    cast(a as double)                    as a,
    cast(dis as double)                  as dis,
    cast(dir as double)                  as dir
from {{ source('bronze', 'combine_tracking_bronze') }}
