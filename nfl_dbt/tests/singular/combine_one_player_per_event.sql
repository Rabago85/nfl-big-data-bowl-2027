{{ config(severity='error', tags=['silver_combine_tracking']) }}
select event_id, count(distinct nfl_id) as n_players
from {{ ref('silver_combine_tracking') }}
where entity_type = 'PLAYER'
group by event_id
having count(distinct nfl_id) <> 1
