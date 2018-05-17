# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

# If the environment differs from the stage name
set :application, 'uipost'

set :repo_url, 'git@github.com:uisport/uisport.git'
set :branch, "master"

set :user, "deploy"
set :rails_env, 'production'
set :deploy_via, :remote_cache
set :use_sudo, false

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :tmp_dir, "/home/uispost"
set :deploy_to, "/home/uispost"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

set :rvm1_map_bins, %w{rake gem bundle ruby}

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"


set :linked_dirs, fetch(:linked_dirs, []).push(
  'node_modules',
  'client/node_modules',
)
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# set :passenger_restart_with_touch, false

namespace :nginx do
  desc "restart nginx"
    task :restart, :clear_cache do
      on roles(:web), in: :groups, limit: 3, wait: 10 do
        within release_path do
          execute "sudo kill $(cat /opt/nginx/logs/nginx.pid)"
          execute "sudo /opt/nginx/sbin/nginx"
        end
      end
    end
end