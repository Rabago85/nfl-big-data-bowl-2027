{{ config(severity='error', tags=['fact_career_outcomes', 'B10']) }}
select count(*) as n_players_without_player_play, {{ var('expected')['players_without_tracking'] }} as expected_n
from {{ ref('fact_career_outcomes') }} f
left anti join (select distinct nfl_id from {{ ref('silver_player_play') }}) p on f.nfl_id = p.nfl_id
having count(*) <> {{ var('expected')['players_without_tracking'] }}