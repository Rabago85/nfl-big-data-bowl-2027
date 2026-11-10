{# grain: one row per player (nfl_id). Snaps are regular season + playoffs (documented). #}
with typed as (
    select
        cast(nfl_id as bigint)                     as nfl_id,
        cast(career_offensive_snaps as int)        as career_offensive_snaps,
        cast(career_defensive_snaps as int)        as career_defensive_snaps,
        cast(career_special_teams_snaps as int)    as career_special_teams_snaps,
        cast(career_games_active as int)           as career_games_active,
        cast(career_games_started as int)          as career_games_started,
        cast(ap_all_pro_1st_team as int)           as ap_all_pro_1st_team,
        cast(ap_all_pro_2nd_team as int)           as ap_all_pro_2nd_team,
        cast(pro_bowl_original_ballot as int)      as pro_bowl_original_ballot
    from {{ source('bronze', 'player_career_successes_bronze') }}
)
select distinct * from typed
