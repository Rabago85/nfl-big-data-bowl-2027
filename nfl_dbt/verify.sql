-- Run after `dbt run` + `dbt test`. Paste the results (or screenshots) back into the thread.
-- 1. Load reconciliation (player_play 314,197 vs documented 316,338; combine_tracking 463,189 vs confirmed 456,328)
select * from nfl.silver_diag.diag_bronze_row_counts;
-- 2. Value profiles -> fills accepted lists in dbt_project.yml and the coverage seed
select * from nfl.silver_diag.diag_value_profiles order by source_column, n_rows desc;
select * from nfl.silver_diag.diag_coverage_unmapped order by n_rows desc;
-- 3. B2 / O3 / B4: which player_play columns are play-level vs role-level
select * from nfl.silver_diag.diag_play_column_grain order by share_plays_constant;
select * from nfl.silver_diag.diag_role_column_population order by column_name, side, lined_up_position;
-- 4. B3 EPA perspective
select * from nfl.silver_diag.diag_epa_wpa_sign;
-- 5. B6 / B12 / B13 / B14 / O4 / O5 tracking
select * from nfl.silver_diag.diag_game_tracking_gaps order by game_id, play_id;
select * from nfl.silver_diag.diag_tracking_summary order by season;
select * from nfl.silver_diag.diag_tracking_orientation;
select * from nfl.silver_diag.diag_sequence_events order by season;
select * from nfl.silver_diag.diag_tracking_coverage order by season, side;
-- 6. B9 / B10 / B11 / O2 / O6
select * from nfl.silver_diag.diag_career_snaps_reconciliation order by rows_to_snaps_ratio limit 25;
select * from nfl.silver_diag.diag_missing_cohort_players;
select nfl_position, combine_position, modal_lined_up_position, count(*) n
  from nfl.silver_diag.diag_position_disagreement
  where not (combine_eq_nfl and nfl_eq_modal_lined_up) group by 1,2,3 order by n desc;
select * from nfl.silver_diag.diag_rows_per_play order by metric, bucket;
select * from nfl.silver_diag.diag_preseason_share order by preseason_share desc;
-- 7. Combine duplicate-event decisions
select * from nfl.silver_diag.diag_combine_duplicate_events;
-- 8. Failing rows from warn/error tests live in nfl.silver_test_failures.*
show tables in nfl.silver_test_failures;
