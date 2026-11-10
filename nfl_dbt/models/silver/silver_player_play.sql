{# grain: one row per player-play = (game_id, play_id, nfl_id).
   - bronze typo visitor_team_win_probility_added -> visitor_team_win_probability_added
   - empty strings (pass_result) and trimmed-empty text become NULL; 'NA' nulls are already NULL in bronze
   - coverage_assignment* keep the raw value; family/side come from the coverage_assignment_map seed
   - NO_ASSIGNMENT stays a literal value, distinct from NULL
   - side: OFFENSE when team_abbr = possession_team, DEFENSE otherwise (NULL if either is NULL)
   - preseason is NOT filtered (is_preseason lives in silver_games) #}
with typed as (
    select
        cast(game_id as bigint)                          as game_id,
        cast(play_id as bigint)                          as play_id,
        cast(nfl_id as bigint)                           as nfl_id,
        {{ clean_code('team_abbr') }}                    as team_abbr,
        {{ clean_code('lined_up_position') }}            as lined_up_position,
        {{ clean_str('play_description') }}              as play_description,
        cast(quarter as int)                             as quarter,
        cast(down as int)                                as down,
        cast(yards_to_go as int)                         as yards_to_go,
        {{ clean_code('possession_team') }}              as possession_team,
        {{ clean_code('yardline_side') }}                as yardline_side,
        cast(yardline_number as int)                     as yardline_number,
        {{ clean_str('game_clock') }}                    as game_clock,
        cast(pre_snap_home_score as int)                 as pre_snap_home_score,
        cast(pre_snap_visitor_score as int)              as pre_snap_visitor_score,
        {{ clean_str('play_direction') }}                as play_direction,

        cast(pre_snap_home_team_win_probability as double)    as pre_snap_home_team_win_probability,
        cast(pre_snap_visitor_team_win_probability as double) as pre_snap_visitor_team_win_probability,
        cast(home_team_win_probability_added as double)       as home_team_win_probability_added,
        cast(visitor_team_win_probility_added as double)      as visitor_team_win_probability_added,
        cast(expected_points_added as double)                 as expected_points_added,
        cast(expected_points as double)                       as expected_points,

        {{ clean_str('offense_formation') }}             as offense_formation,
        {{ clean_str('receiver_alignment') }}            as receiver_alignment,
        {{ clean_code('pass_result') }}                  as pass_result,
        cast(pass_length as double)                      as pass_length,
        {{ clean_code('play_nullified_by_penalty') }}    as play_nullified_by_penalty,
        cast(penalty_yards as double)                    as penalty_yards,
        cast(pre_penalty_yards_gained as int)            as pre_penalty_yards_gained,
        cast(yards_gained as int)                        as yards_gained,
        {{ clean_str('team_coverage_man_zone') }}        as team_coverage_man_zone,
        {{ clean_str('team_coverage_type') }}            as team_coverage_type,
        cast(in_motion_at_ball_snap as boolean)          as in_motion_at_ball_snap,

        cast(target as boolean)                          as target,
        cast(rec_yards as double)                        as rec_yards,
        cast(rush_yards as double)                       as rush_yards,
        cast(yards_after_catch as double)                as yards_after_catch,
        cast(fumble as double)                           as fumble,
        cast(fumble_lost as double)                      as fumble_lost,
        {{ clean_str('route_ran') }}                     as route_ran,
        cast(separation_at_pass_forward as double)       as separation_at_pass_forward,
        cast(cushion as double)                          as cushion,
        cast(expected_yards_after_catch as double)       as expected_yards_after_catch,

        cast(dropback_duration as double)                as dropback_duration,
        cast(extended_sack_allowed as double)            as extended_sack_allowed,
        cast(pass_rushers_encountered as double)         as pass_rushers_encountered,
        cast(peak_pressure_probability_allowed as double) as peak_pressure_probability_allowed,
        cast(pressure_allowed as boolean)                as pressure_allowed,
        cast(sack_allowed as double)                     as sack_allowed,
        cast(time_to_pressure_allowed as double)         as time_to_pressure_allowed,

        cast(blitzing as boolean)                        as blitzing,
        cast(player_get_off as double)                   as player_get_off,
        cast(sack as double)                             as sack,
        cast(tackle as double)                           as tackle,
        cast(assist as double)                           as assist,
        cast(caused_forced_fumble as double)             as caused_forced_fumble,
        cast(recovered_fumble as boolean)                as recovered_fumble,
        cast(tackle_for_loss as boolean)                 as tackle_for_loss,
        cast(time_to_pressure as double)                 as time_to_pressure,
        cast(time_to_qb_hurry as double)                 as time_to_qb_hurry,
        {{ clean_str('coverage_assignment') }}           as coverage_assignment,
        {{ clean_str('coverage_assignment_at_snap') }}   as coverage_assignment_at_snap
    from {{ source('bronze', 'player_play_bronze') }}
),
deduped as (select distinct * from typed)
select
    d.*,
    {{ season_from_game_id('d.game_id') }} as season,
    case
        when d.team_abbr is null or d.possession_team is null then null
        when d.team_abbr = d.possession_team then 'OFFENSE'
        else 'DEFENSE'
    end as side,
    m1.coverage_family as coverage_family,
    m1.coverage_side   as coverage_side,
    m2.coverage_family as coverage_family_at_snap,
    m2.coverage_side   as coverage_side_at_snap
from deduped d
left join {{ ref('coverage_assignment_map') }} m1 on d.coverage_assignment = m1.raw_value
left join {{ ref('coverage_assignment_map') }} m2 on d.coverage_assignment_at_snap = m2.raw_value
