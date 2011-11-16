class Customer < ActiveRecord::Base
  belongs_to :ethnicity
  has_many :customer_impairments, :dependent => :destroy
  has_many :impairments, :through => :customer_impairments
  has_many :kases, :dependent => :restrict
  has_many :customer_support_network_members, :dependent => :destroy
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  has_attached_file :portrait, 
    :styles => { :small => "250", :original => "1200x1200" },
    :path   => ":rails_root/uploads/:attachment/:id/:style/:basename.:extension",
    :url    => "/customers/:id/download_:style_portrait"

  validates_attachment_content_type :portrait, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/pjpeg']

  validates_presence_of :ethnicity_id
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates             :birth_date, :date => { :before => Proc.new { Date.today } }
  validates_presence_of :gender
  validates_presence_of :phone_number_1
  validates_format_of   :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :allow_blank => true
  validates_presence_of :address
  validates_presence_of :city
  validates_length_of   :state, :is => 2
  validates_format_of   :zip, :with => %r{\d{5}(-\d{4})?},:message => "should be 12345 or 12345-6789" 
  validates_presence_of :county

  cattr_reader :per_page
  @@per_page = 50
  
  scope :with_successful_exit_in_range_for_county, lambda{|start_date,end_date,county_code| where("customers.id IN (SELECT customer_id FROM kases WHERE disposition_id = ? AND close_date BETWEEN ? AND ? AND county = ?)",Disposition.successful.id,start_date,end_date,county_code)}

  def self.with_new_successful_exit_in_range_for_county(start_date,end_date,county_code)
    fy_start_date = Date.new(start_date.year - (start_date.month < 7 ? 1 : 0), 7, 1)
    self.with_successful_exit_in_range_for_county(start_date,end_date,county_code).where("customers.id NOT IN (SELECT customer_id FROM kases WHERE disposition_id = ? AND close_date BETWEEN ? AND ? AND county = ?)",Disposition.successful.id,fy_start_date,start_date - 1.day,county_code)
  end

  def self.search(term)
    if term.match /^[a-z]+$/i
      #a single word, either a first or a last name
      query, args = make_customer_name_query("first_name", term)
      lnquery, lnargs = make_customer_name_query("last_name", term)
      query += " or " + lnquery
      args += lnargs
      Rails.logger.debug "QUERY: #{query}"
      Rails.logger.debug "QUERY: #{args}"
    elsif term.match /^[a-z]+[ ,]\s*$/i
      comma = term.index(",")
      #a single word, either a first or a last name, complete
      term.gsub!(",", "")
      term = term.strip
      if comma
        query, args = make_customer_name_query("last_name", term, :complete)
      else
        query, args = make_customer_name_query("first_name", term, :complete)
      end
      Rails.logger.debug "QUERY: #{query}"
      Rails.logger.debug "QUERY: #{args}"
    elsif term.match /^[a-z]+\s+[a-z]$/i
      #a first name followed by either a middle initial or the first
      #letter of a last name

      first_name, last_name = term.split(" ").map(&:strip)

      query, args = make_customer_name_query("first_name", first_name, :complete)
      lnquery, lnargs = make_customer_name_query("last_name", last_name)

      query += " and " + lnquery 
      args += lnargs
      Rails.logger.debug "QUERY: #{query}"
      Rails.logger.debug "QUERY: #{args}"
    elsif term.match /^[a-z]+\s+[a-z]{2,}$/i
      #a first name followed by two or more letters of a last name

      first_name, last_name = term.split(" ").map(&:strip)

      query, args = make_customer_name_query("first_name", first_name, :complete)
      lnquery, lnargs = make_customer_name_query("last_name", last_name)
      query += " and " + lnquery
      args += lnargs
      Rails.logger.debug "QUERY: #{query}"
      Rails.logger.debug "QUERY: #{args}"
    elsif term.match /^[a-z]+\s*,\s*[a-z]+$/i
      #a last name, a comma, some or all of a first name

      last_name, first_name = term.split(",").map(&:strip)

      query, args = make_customer_name_query("last_name", last_name, :complete)
      fnquery, fnargs = make_customer_name_query("first_name", first_name)
      query += " and " + fnquery
      args += fnargs
      Rails.logger.debug "QUERY: #{query}"
      Rails.logger.debug "QUERY: #{args}"
    else
      query = ''
      args = []
    end

    conditions = [query] + args
    Rails.logger.debug "QUERY: #{conditions}"
    # raise "#{conditions}"
    Customer.where(conditions)
  end
  
  def self.make_customer_name_query(field, value, option=nil)
    value = value.downcase
    if option == :initial
      return "(LOWER(%s) = ?)" % field, [value]
    elsif option == :complete
      return "(LOWER(%s) = ? or 
dmetaphone(%s) = dmetaphone(?) or 
dmetaphone(%s) = dmetaphone_alt(?)  or
dmetaphone_alt(%s) = dmetaphone(?) or 
dmetaphone_alt(%s) = dmetaphone_alt(?))" % [field, field, field, field, field], [value, value, value, value, value]
    else
      like = value + "%"

      return "(LOWER(%s) like ? or 
dmetaphone(%s) LIKE dmetaphone(?) || '%%' or 
dmetaphone(%s) LIKE dmetaphone_alt(?)  || '%%' or
dmetaphone_alt(%s) LIKE dmetaphone(?)  || '%%'or 
dmetaphone_alt(%s) LIKE dmetaphone_alt(?) || '%%')" % [field, field, field, field, field], [like, value, value, value, value]

    end
  end

  def name
    return "%s %s" % [first_name, last_name]
  end
  
  def name_reversed
    return "%s, %s" % [last_name, first_name]
  end

  def age_in_years
    if birth_date.nil?
      return nil
    end
    today = Date.today
    years = today.year - birth_date.year #2011 - 1980 = 31
    if today.month < birth_date.month  || today.month == birth_date.month and today.day < birth_date.day #but 4/8 is before 7/3, so age is 30
      years -= 1
    end
    return years
  end

end
