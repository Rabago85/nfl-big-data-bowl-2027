{{ config(severity='error', tags=['silver_combine_tracking']) }}
with pairs as (select distinct nfl_id, draft_year from {{ ref('silver_combine_tracking') }} where nfl_id is not null)
select t.nfl_id, t.draft_year as tracking_draft_year, p.draft_year as players_draft_year
from pairs t
join {{ ref('silver_players') }} p on t.nfl_id = p.nfl_id
where t.draft_year <> p.draft_year
