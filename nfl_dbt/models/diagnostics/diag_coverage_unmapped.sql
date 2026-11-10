{# Distinct coverage_assignment values with no row in the coverage_assignment_map seed. Fill the seed from this. #}
select 'coverage_assignment' as source_column, coverage_assignment as raw_value, count(*) as n_rows
from {{ ref('silver_player_play') }}
where coverage_assignment is not null and coverage_family is null
group by coverage_assignment
union all
select 'coverage_assignment_at_snap', coverage_assignment_at_snap, count(*)
from {{ ref('silver_player_play') }}
where coverage_assignment_at_snap is not null and coverage_family_at_snap is null
group by coverage_assignment_at_snap
