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

# require 'san_juan'
# san_juan.role :app, %w[dj]
# before "deploy:restart", "god:all:reload"
# before "deploy:restart", "god:app:dj:restart"

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
end
