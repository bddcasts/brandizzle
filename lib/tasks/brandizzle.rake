namespace :brandizzle do
  desc "reset the demo database hourly to keep cruft down to a minimum."
  task :reset_demo do
    Rake::Task["db:reset"].invoke
    Rake::Task["db:populate"].invoke
  end
end