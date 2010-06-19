set :host, "brandizzle.aissac.ro"
set :deploy_to, "/home/brandizzle/brandizzle.aissac.ro"
set :branch, "staging"

set :user, "brandizzle"
set :use_sudo, false

set :shared_path, File.join(deploy_to, shared_dir)
set :shared_assets_path, File.join(deploy_to, 'assets')
