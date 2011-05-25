require 'csv'

CSV.foreach(File.join(Rails.root,'db','legacy','ridewise_customers.csv'),headers: true) do |r|
  Customer.find_or_initialize_by_id(r['Constituent ID'])
end
