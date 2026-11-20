{{ config(severity='error', tags=['dim_team']) }}
with teams_player_play_joined as (
    select
        t1.team_abbr team_match,
        t2.team_abbr possesion_team_match
    from (
        select
            season,
            team_abbr,
            possession_team
        from {{ ref('silver_player_play') }}
        ) p
    left join {{ ref('dim_team') }} t1
    on p.season = t1.season and p.team_abbr = t1.team_abbr
    left join {{ ref('dim_team') }} t2
    on p.season = t2.season and p.team_abbr = t2.team_abbr 
)
select
    *
from teams_player_play_joined
where team_match is null and possesion_team_match is null
