{# B4 / O3. Grain: (column, side, lined_up_position). Share of rows where each role column is populated. #}
{% for c in var('role_columns') %}
select '{{ c }}' as column_name, side, lined_up_position,
       count(*) as n_rows,
       sum(case when {{ c }} is not null then 1 else 0 end) as n_non_null,
       sum(case when {{ c }} is not null then 1 else 0 end) * 1.0 / count(*) as share_non_null
from {{ ref('silver_player_play') }}
group by side, lined_up_position
{{ 'union all' if not loop.last }}
{% endfor %}
