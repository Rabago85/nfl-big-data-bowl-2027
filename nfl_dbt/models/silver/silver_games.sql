{# grain: one row per game (game_id). Preseason is flagged, never filtered. #}
{% set pre = var('preseason_season_types') %}
with typed as (
    select
        cast(game_id as bigint)              as game_id,
        cast(game_key as bigint)             as game_key,
        cast(season as int)                  as season,
        {{ clean_code('season_type') }}      as season_type,
        cast(week as int)                    as week,
        {{ clean_code('home_team_abbr') }}   as home_team_abbr,
        {{ clean_code('visitor_team_abbr') }} as visitor_team_abbr
    from {{ source('bronze', 'games_bronze') }}
),
deduped as (select distinct * from typed)
select
    *,
    {{ game_date_from_game_id('game_id') }} as game_date,
    coalesce(season_type in ('{{ pre | join("', '") }}'), false) as is_preseason
from deduped
