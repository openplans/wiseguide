namespace :legacy do
  desc 'Load legacy data into database'
  task :load => :environment do
    legacy_file = File.join(Rails.root, 'db', 'legacy.rb')
    load(legacy_file) if File.exist?(legacy_file)
  end
end
