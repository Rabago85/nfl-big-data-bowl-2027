{{ config(severity='error', tags=['dim_team']) }}
with teams_games_joined as (
    select
        g.season,
        g.home_team_abbr,
        g.visitor_team_abbr,
        t1.team_abbr home_team_match,
        t2.team_abbr visitor_team_match
    from {{ ref('dim_game') }} g
    left join {{ ref('dim_team') }} t1
    on g.season = t1.season and g.home_team_abbr = t1.team_abbr
    left join {{ ref('dim_team') }} t2
    on g.season = t2.season and g.visitor_team_abbr = t2.team_abbr
)
select
    *
from teams_games_joined
where home_team_match is null or visitor_team_match is null
