default_run_options[:pty] = true

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, 'ruby-1.9.2-p290@myidea'        # Or whatever env you want it to run in.

set :use_sudo, false

set :application, "myidea"

set :repository,  "git://github.com/danjiang/myidea.git"
set :scm, :git

set :deploy_to, "/var/www/myidea"

server "myidea.danthought.com", :app, :web, :db, :primary => true

namespace :deploy do
  task :copy_database_configuration do 
    production_db_config = "~/database.yml" 
    run "cp #{production_db_config} #{release_path}/config/database.yml"
  end
  after "deploy:update_code", "deploy:copy_database_configuration"

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
