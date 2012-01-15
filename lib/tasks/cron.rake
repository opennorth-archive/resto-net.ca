task :cron => :environment do
  Rake::Task['data:montreal:update'].invoke
  Rake::Task['data:toronto:update'].invoke
end
