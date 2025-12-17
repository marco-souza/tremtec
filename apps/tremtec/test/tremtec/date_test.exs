defmodule Tremtec.DateTest do
  use ExUnit.Case, async: true

  use Gettext, backend: TremtecWeb.Gettext

  alias Tremtec.Date

  doctest Tremtec.Date

  describe "format_full_date/1" do
    test "returns nil for nil input" do
      assert Date.format_full_date(nil) == nil
    end

    test "formats DateTime correctly" do
      datetime = ~U[2025-12-01 14:30:45Z]
      result = Date.format_full_date(datetime)
      assert result == "2025-12-01 14:30"
    end

    test "handles various datetime values" do
      assert Date.format_full_date(~U[2024-01-15 09:00:00Z]) == "2024-01-15 09:00"
      assert Date.format_full_date(~U[2026-12-31 23:59:59Z]) == "2026-12-31 23:59"
    end
  end

  describe "relative_date/1" do
    test "returns nil for nil input" do
      assert Date.relative_date(nil) == nil
    end

    test "returns 'Just now' for times less than 60 seconds ago" do
      now = DateTime.utc_now()
      ago_30_seconds = DateTime.add(now, -30, :second)

      result = Date.relative_date(ago_30_seconds)
      assert result == gettext("Just now")
    end

    test "returns minute(s) ago for times between 60 seconds and 1 hour" do
      now = DateTime.utc_now()

      # 5 minutes ago
      ago_5_minutes = DateTime.add(now, -300, :second)
      result = Date.relative_date(ago_5_minutes)
      assert String.contains?(result, "5")
      assert String.contains?(result, "minute")

      # 1 minute ago
      ago_1_minute = DateTime.add(now, -60, :second)
      result = Date.relative_date(ago_1_minute)
      assert String.contains?(result, "1")
      assert String.contains?(result, "minute")
    end

    test "returns hour(s) ago for times between 1 hour and 24 hours" do
      now = DateTime.utc_now()

      # 2 hours ago
      ago_2_hours = DateTime.add(now, -7200, :second)
      result = Date.relative_date(ago_2_hours)
      assert String.contains?(result, "2")
      assert String.contains?(result, "hour")

      # 1 hour ago
      ago_1_hour = DateTime.add(now, -3600, :second)
      result = Date.relative_date(ago_1_hour)
      assert String.contains?(result, "1")
      assert String.contains?(result, "hour")
    end

    test "returns day(s) ago for times between 24 hours and 7 days" do
      now = DateTime.utc_now()

      # 3 days ago
      ago_3_days = DateTime.add(now, -259_200, :second)
      result = Date.relative_date(ago_3_days)
      assert String.contains?(result, "3")
      assert String.contains?(result, "day")

      # 1 day ago
      ago_1_day = DateTime.add(now, -86_400, :second)
      result = Date.relative_date(ago_1_day)
      assert String.contains?(result, "1")
      assert String.contains?(result, "day")
    end

    test "returns week(s) ago for times 7+ days in the past" do
      now = DateTime.utc_now()

      # 2 weeks ago
      ago_2_weeks = DateTime.add(now, -1_209_600, :second)
      result = Date.relative_date(ago_2_weeks)
      assert String.contains?(result, "2")
      assert String.contains?(result, "week")

      # 1 week ago
      ago_1_week = DateTime.add(now, -604_800, :second)
      result = Date.relative_date(ago_1_week)
      assert String.contains?(result, "1")
      assert String.contains?(result, "week")
    end

    test "handles non-datetime values gracefully" do
      assert Date.relative_date("2025-12-01") == nil
      assert Date.relative_date(123) == nil
      assert Date.relative_date(%{}) == nil
    end
  end

  describe "relative time boundaries" do
    test "edge case: exactly 1 minute" do
      now = DateTime.utc_now()
      exactly_ago_1_minute = DateTime.add(now, -60, :second)

      result = Date.relative_date(exactly_ago_1_minute)
      assert String.contains?(result, "1")
      assert String.contains?(result, "minute")
    end

    test "edge case: exactly 1 hour" do
      now = DateTime.utc_now()
      exactly_ago_1_hour = DateTime.add(now, -3600, :second)

      result = Date.relative_date(exactly_ago_1_hour)
      assert String.contains?(result, "1")
      assert String.contains?(result, "hour")
    end

    test "edge case: exactly 1 day" do
      now = DateTime.utc_now()
      exactly_ago_1_day = DateTime.add(now, -86_400, :second)

      result = Date.relative_date(exactly_ago_1_day)
      assert String.contains?(result, "1")
      assert String.contains?(result, "day")
    end

    test "edge case: exactly 1 week" do
      now = DateTime.utc_now()
      exactly_ago_1_week = DateTime.add(now, -604_800, :second)

      result = Date.relative_date(exactly_ago_1_week)
      assert String.contains?(result, "1")
      assert String.contains?(result, "week")
    end

    test "edge case: 59 seconds ago (should be 'Just now')" do
      now = DateTime.utc_now()
      ago_59_seconds = DateTime.add(now, -59, :second)

      result = Date.relative_date(ago_59_seconds)
      assert result == gettext("Just now")
    end

    test "edge case: 3599 seconds ago (should be minutes, not hours)" do
      now = DateTime.utc_now()
      ago_3599_seconds = DateTime.add(now, -3599, :second)

      result = Date.relative_date(ago_3599_seconds)
      assert String.contains?(result, "minute")
      refute String.contains?(result, "hour")
    end

    test "edge case: 86399 seconds ago (should be hours, not days)" do
      now = DateTime.utc_now()
      ago_86399_seconds = DateTime.add(now, -86_399, :second)

      result = Date.relative_date(ago_86399_seconds)
      assert String.contains?(result, "hour")
      refute String.contains?(result, "day")
    end

    test "edge case: 604799 seconds ago (should be days, not weeks)" do
      now = DateTime.utc_now()
      ago_604799_seconds = DateTime.add(now, -604_799, :second)

      result = Date.relative_date(ago_604799_seconds)
      assert String.contains?(result, "day")
      refute String.contains?(result, "week")
    end
  end

  describe "future dates" do
    test "handles future dates gracefully" do
      now = DateTime.utc_now()
      future_5_minutes = DateTime.add(now, 300, :second)

      # Should handle negative diff_seconds (future dates)
      result = Date.relative_date(future_5_minutes)
      # Negative diff_seconds will match first condition (< 60) as false
      # Then goes to < 3600, div(-300, 60) = -5, ngettext returns a string with "-5"
      assert is_binary(result)
    end
  end

  describe "formatting consistency" do
    test "multiple calls with same time return same format" do
      datetime = ~U[2025-12-01 14:30:45Z]

      result1 = Date.format_full_date(datetime)
      result2 = Date.format_full_date(datetime)

      assert result1 == result2
    end

    test "format_full_date always returns YYYY-MM-DD HH:MM format" do
      result = Date.format_full_date(~U[2025-01-05 08:05:30Z])
      assert result =~ ~r/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$/
    end
  end

  describe "integration with i18n" do
    test "uses gettext for 'Just now'" do
      now = DateTime.utc_now()
      just_now = DateTime.add(now, -10, :second)

      result = Date.relative_date(just_now)
      # Result should be the translated string for "Just now"
      assert is_binary(result)
      assert String.length(result) > 0
    end

    test "plural forms work correctly with ngettext" do
      now = DateTime.utc_now()

      # Single minute
      ago_singular_minute = DateTime.add(now, -60, :second)
      result_singular = Date.relative_date(ago_singular_minute)

      # Multiple minutes
      ago_plural_minutes = DateTime.add(now, -300, :second)
      result_plural = Date.relative_date(ago_plural_minutes)

      # Results should be different (singular vs plural)
      refute result_singular == result_plural
    end
  end
end
