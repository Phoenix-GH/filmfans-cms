
set :application, 'filmfans'
set :repo_url, 'git@bitbucket.org:micheal_phuoc/filmfans-cms.git'

role :app, %w{filmfans@158.69.12.123}
role :web, %w{filmfans@158.69.12.123}
role :db,  %w{filmfans@158.69.12.123}

set :tmp_dir, '/home/filmfans/tmp'
set :nginx_server_name, 'filmfans.themindstudios.com'

set :deploy_to, '/var/www/filmfans'
set :rvm_ruby_version, 'ruby-2.3.0@hotspotting'
set :rvm_custom_path, '/opt/rvm'

set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || "staging"
