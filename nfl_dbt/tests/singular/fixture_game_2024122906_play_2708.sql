{{ config(severity='error', tags=['fixture', 'silver_player_play']) }}
{# Known-answer fixture (handoff Section 4): game 2024122906, play 2708 has six rows. #}
with p as (
    select * from {{ ref('silver_player_play') }} where game_id = 2024122906 and play_id = 2708
),
expected as (
    select * from values
        ('TEN', 56572, 'T'), ('TEN', 55875, 'G'), ('TEN', 57128, 'T'),
        ('JAX', 57169, 'INTERIOR_LINE'), ('JAX', 57217, 'SLOT_CB'), ('JAX', 56025, 'SLOT_CB')
        as e(team_abbr, nfl_id, lined_up_position)
)
select 'row_count_not_6' as failed_check, count(*) as observed from p having count(*) <> 6
union all
select 'missing_expected_row', count(*) from expected e
  left join p on p.nfl_id = e.nfl_id and p.team_abbr = e.team_abbr and p.lined_up_position = e.lined_up_position
  where p.nfl_id is null having count(*) > 0
union all
select 'epa_not_-0.8359_on_all_rows', count(*) from p
  where expected_points_added is null or abs(expected_points_added + 0.8359) > 0.0001 having count(*) > 0
union all
select 'dropback_duration_wrong', count(*) from p
  where (team_abbr = 'TEN' and (dropback_duration is null or abs(dropback_duration - 1.914) > 0.0005))
     or (team_abbr = 'JAX' and dropback_duration is not null) having count(*) > 0
union all
select 'in_motion_wrong', count(*) from p
  where (team_abbr = 'TEN' and (in_motion_at_ball_snap is null or in_motion_at_ball_snap))
     or (team_abbr = 'JAX' and in_motion_at_ball_snap is not null) having count(*) > 0
union all
select 'cushion_not_on_exactly_one_row', count(*) from p where cushion is not null having count(*) <> 1
union all
select 'cushion_not_6.26_on_slot_cb', count(*) from p
  where cushion is not null and (lined_up_position <> 'SLOT_CB' or abs(cushion - 6.26) > 0.005) having count(*) > 0
