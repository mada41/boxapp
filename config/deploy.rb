# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'Mothership'
set :repo_url, 'git@github.com:41studio/41staging.git'

# New Additions ======================
set :deploy_user, 'rails'
set :deploy_user_pass, 'simon12345'

set :pg_database, "#{fetch(:application)}_#{fetch(:stage)}"
set :pg_user, 'rails'
set :pg_password, 'simon12345'
set :pg_env, fetch(:stage)

set :pty, true
# ======================

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

namespace :logs do
  desc "tail rails logs" 
  task :rails do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end
end

namespace :setup do
  # First Installation Task Note :

  # == the user must be "sudoers and nopassw" before setup ======
  # $: adduser rails
  # $: echo "rails ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
  # $: sudo chown rails:rails /var/www/

  # == login as rails to generate and register ssh key to repo ==
  # $: ssh-keygen
  # $: eval `ssh-agent -s`
  # $: ssh-add
  # $: cat ~/.ssh/id_rsa.pub

  desc "install rvm with stable ruby"
  task :install_rvm do
    on roles(:app) do
      execute :sudo, "apt-get update"
      execute :sudo, "apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev"
      execute "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"
      execute "curl -sSL https://get.rvm.io | bash -s stable --ruby"
    end
  end

  desc "install postgresql and setup user"
  task :setup_postgresql do
    on roles(:app) do
      execute :sudo, "apt-get -y install postgresql postgresql-contrib libpq-dev"
    end
  end

  desc "install nginx"
  task :install_nginx do
    on roles(:app) do
      execute :sudo, "apt-get -y install nginx"
      execute :sudo, "service nginx start"
      execute :sudo, "chown #{fetch(:deploy_user)}:#{fetch(:deploy_user)} /var/"
      execute "mkdir -p #{fetch(:deploy_to)}"
    end
  end

  desc "Create db directory for generate database yml"
  task :create_db_directory_app do
    on roles(:app) do
      execute "mkdir -p /var/www/#{fetch(:application)}/db/"
      upload! StringIO.new(File.read("config/database.yml")), "#{fetch(:deploy_to)}/db/database.yml"
    end
  end

  desc "Drop database"
  task :drop_database do
    on roles(:app) do
      execute :sudo, "-u postgres bash -c \"psql -c 'DROP DATABASE IF EXISTS #{fetch(:pg_database)};'\""
    end
  end

end


# After Before callbacks
# before 'rvm:check', 'setup:install_rvm'
# before 'nginx:setup', 'setup:install_nginx'
# before 'postgresql:create_db_user', 'setup:setup_postgresql'
# before 'postgresql:generate_database_yml', 'setup:create_db_directory_app'
# before 'postgresql:create_database', 'setup:drop_database'


