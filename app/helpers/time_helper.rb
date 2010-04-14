module TimeHelper
  def format_date_time(date)
    returning("") do |d|
      d << show_day(date)
      d << " - "
      d << format_time(date)
    end
  end
  
  def format_time(date)
    date.strftime("%I:%M%p")
  end
  
  def show_day(day)
    if day.today?
      "Today"
    elsif day.year == Time.now.year
      day.strftime('%B %d')
    else
      day.strftime('%B %d, %Y')
    end
  end
end