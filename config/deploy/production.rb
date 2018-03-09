# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}

set :stage, :production
set :deploy_to, '/home/ubuntu/apps/hotspotting'

set :unicorn_config_path, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, -> { File.join(current_path, 'tmp', 'pids', 'unicorn.pid') }
set :sidekiq_role, :sidekiq

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.

server '',
  user: 'ubuntu',
  roles: %w{web app cron},
  ssh_options: {
    forward_agent: true,
    port: 22
  }

server '',
  user: 'ubuntu',
  roles: %w{web app db},
  ssh_options: {
    forward_agent: true,
    port: 22
  }


server '',
  user: 'ubuntu',
  roles: %w{sidekiq},
  ssh_options: {
    forward_agent: true,
    port: 22
  }
