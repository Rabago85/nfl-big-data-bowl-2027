{# Fails rows whose value is outside var('thresholds')[threshold].{min,max}. NULLs pass. #}
{% test within_thresholds(model, column_name, threshold) %}
{%- set t = var('thresholds')[threshold] -%}
select *
from {{ model }}
where {{ column_name }} is not null
  and ({{ column_name }} < {{ t['min'] }} or {{ column_name }} > {{ t['max'] }})
{% endtest %}
