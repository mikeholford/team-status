module ApplicationHelper
  def short_time_ago(time)
    return "never" if time.blank?

    seconds = (Time.current - time).to_i
    seconds = 0 if seconds.negative?

    return "just now" if seconds < 60

    minutes = seconds / 60
    return "#{minutes}m ago" if minutes < 60

    hours = minutes / 60
    return "#{hours}h ago" if hours < 24

    days = hours / 24
    return "#{days}d ago" if days < 7

    weeks = days / 7
    "#{weeks}w ago"
  end

  def short_datetime(time)
    return "" if time.blank?

    time.strftime("%-d#{day_ordinal_suffix(time.day)} %B %l.%M%P")
  end

  def short_time_left(time)
    return "" if time.blank?

    seconds = (time - Time.current).to_i
    return "0m" if seconds <= 0

    minutes = seconds / 60
    return "#{minutes} min" if minutes < 60

    hours = minutes / 60
    return "#{hours}h" if hours < 24

    days = hours / 24
    "#{days}d"
  end

  private

  def day_ordinal_suffix(day)
    return "th" if (11..13).include?(day % 100)

    case day % 10
    when 1 then "st"
    when 2 then "nd"
    when 3 then "rd"
    else "th"
    end
  end
end
