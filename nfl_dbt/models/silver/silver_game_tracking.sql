{{ config(liquid_clustered_by=['season', 'game_id', 'play_id', 'nfl_id']) }}
{# grain: one frame = (game_id, play_id, nfl_id, time), all three seasons.
   season comes from the source file name (game_tracking_<season>.csv); event is lower-cased.
   Exact duplicate frames are dropped; conflicting duplicates fail the unique test. #}
select distinct
    try_cast(regexp_extract(source_file, 'game_tracking_([0-9]{4})', 1) as int) as season,
    cast(game_id as bigint)     as game_id,
    cast(play_id as bigint)     as play_id,
    cast(nfl_id as bigint)      as nfl_id,
    cast(time as timestamp)     as time,
    cast(x as double)           as x,
    cast(y as double)           as y,
    cast(s as double)           as s,
    cast(a as double)           as a,
    cast(dis as double)         as dis,
    cast(o as double)           as o,
    cast(dir as double)         as dir,
    nullif(lower(trim(event)), '') as event,
    source_file
from {{ source('bronze', 'game_tracking_bronze') }}
