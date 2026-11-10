{# trim; empty string -> NULL. Used for free text and for pass_result (empty-string nulls). #}
{% macro clean_str(col) -%}
nullif(trim({{ col }}), '')
{%- endmacro %}

{# trim + upper-case a code; empty string -> NULL #}
{% macro clean_code(col) -%}
nullif(upper(trim({{ col }})), '')
{%- endmacro %}

{# game_id is YYYYMMDD## ; NFL season = year, minus 1 for Jan/Feb games #}
{% macro season_from_game_id(col) -%}
(try_cast(substr(cast({{ col }} as string), 1, 4) as int)
 - case when try_cast(substr(cast({{ col }} as string), 5, 2) as int) < 3 then 1 else 0 end)
{%- endmacro %}

{% macro game_date_from_game_id(col) -%}
to_date(try_to_timestamp(substr(cast({{ col }} as string), 1, 8), 'yyyyMMdd'))
{%- endmacro %}
