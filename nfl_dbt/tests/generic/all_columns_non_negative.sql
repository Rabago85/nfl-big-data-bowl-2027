{% test all_columns_non_negative(model, exclude_columns=[]) %}

{%- set columns = adapter.get_columns_in_relation(model) -%}
{%- set numeric_cols = [] -%}

{%- for col in columns -%}
    {# Filter for numeric data types and skip excluded columns #}
    {%- if col.is_number() and col.name not in exclude_columns -%}
        {%- do numeric_cols.append(col.name) -%}
    {%- endif -%}
{%- endfor -%}

{%- if numeric_cols | length > 0 %}
select *
from {{ model }}
where
    {%- for col_name in numeric_cols %}
        {{ col_name }} < 0
        {%- if not loop.last %} or {% endif -%}
    {%- endfor %}
{%- else %}
-- Return 0 rows if there are no numeric columns to test
select 1 where 1 = 0
{%- endif %}

{% endtest %}
