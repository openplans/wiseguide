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
  
end
