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
  
  def date_in_words(date)
    before, after = date.split(" to ")
    if before.to_date.today?
      "todays"
    elsif before.to_date == Time.now.yesterday.to_date
      "yesterdays"
    elsif before.to_date == 7.days.ago.to_date && after.to_date.today?
      "last seven days"
    elsif before.to_date == Time.now.at_beginning_of_month.to_date && after.to_date.today?
      "this months"
    elsif before.to_date == Time.now.last_month.at_beginning_of_month.to_date && after.to_date == Time.now.last_month.at_end_of_month.to_date
      "last months"
    elsif after.blank?
      show_day(before.to_date)
    elsif !after.blank? && after.to_date == Time.now.to_date
      ""
    elsif !after.blank?
      "#{show_day(before.to_date)} to #{show_day(after.to_date)}"
    else
      ""
    end
  end
end