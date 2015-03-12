# config valid only for current version of Capistrano
lock '3.4.0'

set :deploy_user, ask('Server username:', nil)

set :stage, :production

set :application, 'katcodes.com'
set :repo_url, 'https://github.com/DUHitsKAT/katcodes.com.git'

set :use_sudo, false
set :rails_env, "production"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '~/katcodes.com'

# Default value for :scm is :git
# set :scm, :git
set :scm_verbose, true

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
#set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

server 'katcodes.com', user: fetch(:deploy_user), password: fetch(:password), roles: %w{web app db}, primary: true

namespace :deploy do
  after :started, :stop_passenger do
    on roles(:web), in: :sequence, wait: 5 do
      execute "RAILS_ENV=production cd #{release_path}/ && passenger stop --port 8010"
    end
  end
  after :finished, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      execute "RAILS_ENV=production cd #{release_path}/ && passenger start --port 8010 > /dev/null & disown"
      #execute :touch, release_path.join("tmp/restart.txt")
    end
  end
end
