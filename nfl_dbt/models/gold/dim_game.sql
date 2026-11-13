{# grain: one row per game (game_id). Preseason is flagged, never filtered. #}

with games as (
    select
        game_id,
        game_key,
        season,
        season_type,
        week,
        home_team_abbr,
        visitor_team_abbr,
        game_date,
        is_preseason
    from {{ ref('silver_games') }}
    )
select * from games
