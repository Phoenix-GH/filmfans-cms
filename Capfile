require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano3/unicorn'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/sidekiq'
require 'whenever/capistrano'
#require 'capistrano/sidekiq/monit'
require "whenever/capistrano"

Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
