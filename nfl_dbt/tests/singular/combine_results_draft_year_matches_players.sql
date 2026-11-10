{{ config(severity='error', tags=['silver_combine_results']) }}
select c.nfl_id, c.draft_year as combine_draft_year, p.draft_year as players_draft_year
from {{ ref('silver_combine_results') }} c
join {{ ref('silver_players') }} p on c.nfl_id = p.nfl_id
where c.draft_year <> p.draft_year
