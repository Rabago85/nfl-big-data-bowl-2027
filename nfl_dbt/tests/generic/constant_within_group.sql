{# B2: every listed column must hold a single value (NULL counts as a value) within each group. #}
{% test constant_within_group(model, group_by, columns) %}
select
  {{ group_by | join(', ') }}
  {%- for c in columns %},
  count(distinct coalesce(cast({{ c }} as string), '<<NULL>>')) as n_distinct_{{ c }}
  {%- endfor %}
from {{ model }}
group by {{ group_by | join(', ') }}
having
  {%- for c in columns %}
  count(distinct coalesce(cast({{ c }} as string), '<<NULL>>')) > 1{{ ' or' if not loop.last }}
  {%- endfor %}
{% endtest %}
