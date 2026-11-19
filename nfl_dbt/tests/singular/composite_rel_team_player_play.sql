{{ config(severity='error', tags=['dim_team']) }}
with teams_player_play_joined as (
    select
        p.season,
        p.team_abbr,
        t.team_abbr team_match
    from {{ ref('silver_player_play') }} p
    left join {{ ref('dim_team') }} t
    on p.season = t.season and p.team_abbr = t.team_abbr
    
)
select
    *
from teams_player_play_joined
where team_match is null
