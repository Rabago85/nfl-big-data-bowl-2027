{# Like accepted_values, but the list lives in var('accepted')[key]. An empty list disables the test. #}
{% test accepted_values_var(model, column_name, key) %}
{%- set vals = var('accepted')[key] -%}
select {{ column_name }} as unexpected_value, count(*) as n_rows
from {{ model }}
where {{ column_name }} is not null
  {% if vals | length > 0 -%}
  and {{ column_name }} not in ({% for v in vals %}'{{ v }}'{{ ', ' if not loop.last }}{% endfor %})
  {%- else -%}
  and 1 = 0
  {%- endif %}
group by {{ column_name }}
{% endtest %}
