defmodule Tremtec.Date do
  use Gettext, backend: TremtecWeb.Gettext

  def format_full_date(nil), do: nil

  def format_full_date(date) when is_struct(date, DateTime) do
    Calendar.strftime(date, "%Y-%m-%d %H:%M")
  end

  def relative_date(nil), do: nil

  def relative_date(date) when is_struct(date, DateTime) do
    format_relative_time(date)
  end

  def relative_date(_), do: nil

  defp format_relative_time(date) do
    now = DateTime.utc_now()
    diff_seconds = DateTime.diff(now, date, :second)

    cond do
      diff_seconds < 60 ->
        gettext("Just now")

      diff_seconds < 3600 ->
        minutes = div(diff_seconds, 60)
        ngettext("%{count} minute ago", "%{count} minutes ago", minutes, count: minutes)

      diff_seconds < 86400 ->
        hours = div(diff_seconds, 3600)
        ngettext("%{count} hour ago", "%{count} hours ago", hours, count: hours)

      diff_seconds < 604_800 ->
        days = div(diff_seconds, 86400)
        ngettext("%{count} day ago", "%{count} days ago", days, count: days)

      true ->
        weeks = div(diff_seconds, 604_800)
        ngettext("%{count} week ago", "%{count} weeks ago", weeks, count: weeks)
    end
  end
end
