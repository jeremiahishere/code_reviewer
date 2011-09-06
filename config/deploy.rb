require "bundler/capistrano"
set :application, "code_reviewer"
set :repository,  "git@github.com:jeremiahishere/code_reviewer.git"
set :deploy_to, "/srv/#{application}"
set :rails_env, :production

set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache


role :web, "jeremiahhemphill.com"                          # Your HTTP server, Apache/etc
role :app, "jeremiahhemphill.com"                          # This may be the same as your `Web` server
role :db,  "jeremiahhemphill.com", :primary => true # This is where Rails migrations will run

namespace :deploy do
  task :start do
    puts "not used"
  end

  task :stop do
    puts "not used"
  end

  task :restart do
    #run "service apache2 restart"
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :symlink do
    run "ln -s /srv/#{application}/shared/repos /srv/#{application}/current/repos"
  end
end


namespace :db do
  task :reset do
    run "cd /srv/#{application}/current && rake db:drop RAILS_ENV=#{rails_env} && rake db:create RAILS_ENV=#{rails_env} && rake db:migrate RAILS_ENV=#{rails_env} && rake db:seed RAILS_ENV=#{rails_env}"
  end  

  task :migrate do
    run "cd /srv/#{application}/current && rake db:create RAILS_ENV=#{rails_env} && rake db:migrate RAILS_ENV=#{rails_env}"
  end
end
after "deploy", "db:migrate"
