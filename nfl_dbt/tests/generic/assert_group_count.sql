{% test assert_group_count(model, group_by_column, expected_key) %}
{%- set expected_count = var('expected')[expected_key] -%}

select
    {{ group_by_column }},
    count(*) as record_count
from {{ model }}
group by {{ group_by_column }}
having count(*) != {{ expected_count }}

{% endtest %}