require "config/capistrano_database_yml.rb"
require "config/capistrano_create_admin.rb"
require "config/capistrano_mailer.rb"
require "config/capistrano_backup_production.rb"

set :application, "mdm"
set :repository,  "git@github.com:wwiersem/mdm.git"
set :deploy_via, :copy

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server "174.132.88.71", :app, :web, :db, :primary => true 

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

set :deploy_to, "/home/wiebewie/rails_apps/mdm"
set :backup_dir, "/home/wiebew/backups"

set :user, "wiebewie"
set :scm_username, "wwiersem"
set :use_sudo, false
set :copy_exclude, ".git/*"
set :restart_via, :run


namespace :customs do
  task :symlink,  :roles => :app do
    # add shared certs and yml files to the current release
    run "ln -nfs #{shared_path}/certs #{release_path}/certs"
    run "ln -nfs #{shared_path}/config/company_info.yml #{release_path}/config/company_info.yml"
    run "ln -nfs #{shared_path}/config/payment_info.yml #{release_path}/config/payment_info.yml" 
    run "ln -nfs #{shared_path}/config/layout.yml #{release_path}/config/layout.yml" 
  end
end
after "deploy:symlink", "customs:symlink"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "export RAILS_ENV=production  && cd #{current_path} && /usr/bin/ruby /usr/bin/mongrel_rails start -p 12001 -d -e production -P log/mongrel.pid && /usr/bin/ruby script/delayed_job start", :via => fetch(:restart_via, :sudo)
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "export RAILS_ENV=production && cd #{current_path} && /usr/bin/ruby /usr/bin/mongrel_rails stop -P log/mongrel.pid && /usr/bin/ruby script/delayed_job stop", :via => fetch(:restart_via, :sudo)
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

  desc <<-DESC
    Shows maintenance screen, takes down the server, updates the code, starts the server and removes the maintenance screen.
  DESC
  task :default do
    namespace :web do
      disable
    end
    stop
    update
    start
    namespace :web do
      enable
    end
  end
  
end
