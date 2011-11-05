module AdminHelper
  def user_roles(level)
    levels = [["Admin", 100], ["Editor", 50], ["Viewer", 0]] 
    levels << ["Deleted", -1] if level == -1
    levels
  end
end
