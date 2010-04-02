set :application, "brandizzle"
set :host, "brandizzle.aissac.ro"

ssh_options[:forward_agent] = true
set :repository,  "git@git.aissac.ro:/brandizzle"

set :deploy_via, :remote_cache

# Customise the deployment
set :tag_on_deploy, false
set :build_gems, false
set :compress_assets, false

set :keep_releases, 6
after "deploy:update", "deploy:cleanup"
after "deploy:update_code", "deploy:link_config"
after "deploy:symlink", "deploy:update_crontab"

require 'san_juan'
san_juan.role :app, %w[delayed_job]
before "deploy:restart", "god:all:reload"
before "deploy:restart", "god:app:delayed_job:restart"

set :config_files, %w(database.yml)
namespace :deploy do
  desc 'symlink config files'
  task :link_config, :roles => :app do
    unless config_files.empty?
      config_files.each do |file|
        run "ln -nsf #{File.join(shared_path, "config/" + file)} #{File.join(release_path, "/config/" + file)}"
      end
    end
  end
  
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application} --set environment=#{rails_env}"
  end
end

namespace :bundler do
  task :symlink_vendor do
    run %Q{ rm -fr #{release_path}/vendor/bundler_gems}
    run %Q{ mkdir -p #{shared_path}/bundler_gems}
    run %Q{ ln -nfs #{shared_path}/bundler_gems #{release_path}/vendor/bundler_gems}
  end
 
  task :bundle_new_release do
    bundler.symlink_vendor
    run("cd #{release_path} && bundle install --relock")
  end
end
after 'deploy:update_code', 'bundler:bundle_new_release'
