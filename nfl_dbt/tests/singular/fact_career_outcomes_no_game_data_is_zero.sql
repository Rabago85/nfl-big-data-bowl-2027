{{ config(severity='error', tags=['fact_career_outcomes', 'B10']) }}
{# B10 in gold: players with no player_play rows must have all-zero career values.
   Fails if any value is non-zero OR null (a null means the join dropped the value). #}
select
    f.nfl_id,
    f.career_offensive_snaps,
    f.career_defensive_snaps,
    f.career_special_teams_snaps,
    f.career_games_active,
    f.career_games_started,
    f.ap_all_pro_1st_team,
    f.ap_all_pro_2nd_team,
    f.pro_bowl_original_ballot
from {{ ref('fact_career_outcomes') }} f
left anti join (select distinct nfl_id from {{ ref('silver_player_play') }}) p
    on f.nfl_id = p.nfl_id
where coalesce(f.career_offensive_snaps, -1)      <> 0
   or coalesce(f.career_defensive_snaps, -1)      <> 0
   or coalesce(f.career_special_teams_snaps, -1)  <> 0
   or coalesce(f.career_games_active, -1)         <> 0
   or coalesce(f.career_games_started, -1)        <> 0
   or coalesce(f.ap_all_pro_1st_team, -1)         <> 0
   or coalesce(f.ap_all_pro_2nd_team, -1)         <> 0
   or coalesce(f.pro_bowl_original_ballot, -1)    <> 0