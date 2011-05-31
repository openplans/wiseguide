require 'csv'
require 'legacy_helper'
require 'pp'

PHONE_TYPES = {'Home Phone' => 'Home','Cell Phone' => 'Cell','Business Phone'=>'Business','Business Phone 2'=>'Business','Other' => 'Other','Email - Home' => 'Home Email','Email - Business' => 'Business Email','EMERGENCY Phone' => 'Emergency','EMERGENCY Phone 2' => 'Emergency','TTY' => 'TTY'}
PHONE_ORDER = {'Home' => 1, 'Cell' => 2, 'Business' => 3, 'Other' => 4, 'Emergency' => 5, 'TTY' => 6}
EMAIL_ORDER = {'Home Email' => 1, 'Business Email' => 2}

i = 0
unknown_ethnicity = Ethnicity.find_by_name('Unknown')
bad_ethnicities = []
notes = {}

Customer.record_timestamps = false
CSV.foreach(File.join(Rails.root,'db','legacy','ridewise_customers.csv'),headers: true) do |r|
  id = r['Constituent ID']
  c = Customer.find_or_initialize_by_id(id)
  c.first_name = r['First Name']
  c.last_name = r['Last Name']
  c.gender = r['Gender']
  c.birth_date = fix_up_date(r['Birth Date'])
  c.address = r['Preferred Address Lines']
  c.city = r['Preferred City']
  c.state = r['Preferred State']
  c.zip = r['Preferred ZIP']

  ethnicity_comment = r['Constituent Specific Attributes Ethnicity Comments']
  if ethnicity_comment.present?
    notes[id] ||= [] 
    notes[id] << "Ethnicity comment: #{ethnicity_comment}" 
  end

  ethnicity_in = r['Constituent Specific Attributes Ethnicity Description']
  ethnicity = Ethnicity.find_by_name(ethnicity_in)
  if ethnicity.nil? 
    # ethnicity = Ethnicity.find_by_name()
    ethnicity = unknown_ethnicity 
    bad_ethnicities << ethnicity_in unless bad_ethnicities.include?(ethnicity_in)
  end
  c.ethnicity = ethnicity
  
  c.created_at = fix_up_date(r['Constituent Date Added'])
  c.updated_at = fix_up_date(r['Constituent Date Last Changed'])

  c.save!
  i += 1
  puts i
end
ActiveRecord::Base.connection.execute("SELECT setval('customers_id_seq',#{Customer.maximum(:id)})")
Customer.record_timestamps = false

cc = {}
CSV.foreach(File.join(Rails.root,'db','legacy','ridewise_customers.csv'),headers: true) do |r|
  id = r['Constituent ID']
  type = PHONE_TYPES[r['Preferred Phone Type']]
  metatype = (type =~ /email/i ? :email : :phone)
  phone = r['Preferred Phone Number']
  if phone.present?
    cc[id] ||= {} 
    cc[id][metatype] ||= {} 
    cc[id][metatype][type] = phone 
  end
end

cc.each do |key, value|
  c = Customer.find(key)
  if value.key?(:phone)
    phones = value[:phone].to_a
    phones.sort! {|x,y| PHONE_ORDER[x[0]] <=> PHONE_ORDER[y[0]]}
    c.phone_number_1 = phones[0].join(': ')
    c.phone_number_2 = phones[1].join(': ') if phones.size > 1
    if phones.size > 2
      phones[2..-1].each do |phone|
        notes[key] ||= []
        notes[key] << phone.join(': ')
      end
    end
  end
  if value.key?(:email)
    emails = value[:email].to_a
    emails.sort! {|x,y| EMAIL_ORDER[x[0]] <=> EMAIL_ORDER[y[0]]}
    c.email = emails[0][1]
    if emails.size > 1
      emails[1..-1].each do |email|
        notes[key] ||= []
        notes[key] << email.join(': ')
      end
    end
  end
  c.notes = notes[key].join("\n") unless notes[key].nil?
  c.save!
end


#cc.each_value do |c|
#  PP.pp c[:phone] if c.key?(:phone) && c[:phone].size > 2
#end
#
#cc.each_value do |c|
#  PP.pp c[:email] if c.key?(:email) && c[:email].size > 1 
#end

#PP.pp cc
