set :application, "myidea"

set :repository,  "git://github.com/danjiang/myidea.git"
set :scm, :git

set :deploy_to, "/var/www"

server "myidea.danthought.com", :app, :web, :db, :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
