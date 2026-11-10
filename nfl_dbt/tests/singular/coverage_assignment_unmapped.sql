{{ config(severity='warn', tags=['coverage_parse']) }}
{# Distinct raw coverage values with no row in the coverage_assignment_map seed. Expected to warn on the first run. #}
select * from {{ ref('diag_coverage_unmapped') }}
