module ReportsHelper
  
  def reports_options
    options_for_select( %w{monthly yearly demographic trainer trainee route outcomes cases events}.map do |name|
      case name
      when "demographic"
        ["Age and ethnicity", name]
      else
        [name.capitalize, name]
      end
    end.insert(0, ["", ""]) )
  end

  def describe_date_range(start_date,end_date)
    if start_date + 1.day == end_date
      result = start_date.strftime('%A %B %e %Y')
    elsif start_date.day == 1 and (end_date + 1.day).day == 1
      if start_date + 1.month == end_date + 1.day # One calendar month
        result = start_date.strftime('Month of %B, %Y')
      elsif start_date + 3.months == end_date + 1.day && (start_date.month - 1).modulo(3) == 0 # A quarter
        quarter = (start_date.month - 1) / 3 + 1
        fiscal_quarter = quarter < 3 ? quarter + 2 : quarter - 2
        result = "#{start_date.strftime('%B')} to #{end_date.strftime('%B')}, #{end_date.year}"
        result += " (#{fiscal_quarter.ordinalize} Quarter of Fiscal Year #{describe_fiscal_year start_date})"
      elsif start_date + 12.months == end_date + 1.day && start_date.month == 7 # Full fiscal year
        result = "Fiscal Year #{start_date.year} through #{end_date.strftime('%B, %Y')}"
      elsif start_date + 12.months == end_date + 1.day && start_date.month == 1 # Full calendar year
        result = "Calendar Year #{start_date.year}"
      elsif start_date.year == end_date.year # Full months, all in the same calendar year
        result = "#{start_date.strftime('%B')} to #{end_date.strftime('%B')}, #{end_date.year}"
      else # Full months, traversing calendar years
        result = "#{start_date.strftime('%B')} #{start_date.year} to #{end_date.strftime('%B')} #{end_date.year}"
      end
    elsif start_date.month == end_date.month && start_date.year == end_date.year # Both dates in same month
      result = "#{start_date.strftime('%B %e')} to #{end_date.strftime('%e, %Y')}"
    elsif start_date.year == end_date.year # Both dates in same year
      result = "#{start_date.strftime('%B %e')} to #{end_date.strftime('%B %e, %Y')}"
    else #Everything else
      result = "#{start_date.strftime('%B %e %Y')} to #{end_date.strftime('%B %e %Y')}"
    end
    result
  end

  def describe_fiscal_year(date)
    date += 1.year if date.month > 6 
    "#{date.year-1}-#{date.strftime('%y')}"
  end

  def start_last_month
    (Date.today - Date.today.day.days + 1.day - 1.month).to_s
  end

  def end_last_month
    (Date.today - Date.today.day.days).to_s
  end
end
