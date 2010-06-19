set :host, "brandpulseapp.com"
set :deploy_to, "/home/brandpulse/app"
set :branch, "production"

set :user, "brandpulse"
set :use_sudo, false

set :shared_path, File.join(deploy_to, shared_dir)
set :shared_assets_path, File.join(deploy_to, 'assets')
