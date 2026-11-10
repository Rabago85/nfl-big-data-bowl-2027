{# B2 / O3. Grain: one row per player_play column. Share of plays where the column is constant across the play's rows. #}
{% set cols = var('play_level_core') + var('play_level_other') + var('role_columns') %}
{% for c in cols %}
select
    '{{ c }}' as column_name,
    count(*) as n_plays,
    sum(case when n_distinct = 1 then 1 else 0 end) as n_plays_constant,
    sum(case when n_distinct = 1 then 1 else 0 end) * 1.0 / count(*) as share_plays_constant
from (
    select game_id, play_id, count(distinct coalesce(cast({{ c }} as string), '<<NULL>>')) as n_distinct
    from {{ ref('silver_player_play') }}
    group by game_id, play_id
) t{{ loop.index }}
{{ 'union all' if not loop.last }}
{% endfor %}
