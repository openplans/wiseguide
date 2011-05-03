module ApplicationHelper

  def last_updated(object)
    "Last updated %s By %s" % [object.updated_at, object.updated_by.email]
  end

end
