{# Model row count must equal var('expected')[expected_key] (within tolerance_pct). #}
{% test row_count_matches(model, expected_key, tolerance_pct=0) %}
{%- set expected = var('expected')[expected_key] -%}
select count(*) as actual_rows, {{ expected }} as expected_rows
from {{ model }}
having abs(count(*) - {{ expected }}) > {{ expected }} * {{ tolerance_pct }} / 100.0
{% endtest %}
