default_run_options[:pty] = true
set :application, "Tida"
set :repository,  "git@bitbucket.org:babaru/conte.git"
set :domain, "106.187.93.197"

set :rvm_ruby_string, '1.9.3-head'
require "rvm/capistrano"
set :rvm_type, :system

set :scm, :git
set :scm_passphrase, "Mbi800716"

set :user, "app"
set :password, "Mbi800716"

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

ssh_options[:forward_agent] = true
set :branch, "master"

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/app/www_root/conte.sptida.com/rails"

set :use_sudo, false

# set :whenever_command, "bundle exec whenever"
# require "whenever/capistrano"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    command = "if [ -e /tmp/unicorn.conte.pid ]; then \
              #{try_sudo} kill -s QUIT `cat /tmp/unicorn.conte.pid` ; \
              fi;"
    run command
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

end

require 'bundler/capistrano'

after "deploy:update_code", "deploy:migrate"
after "deploy:create_symlink", "deploy:restart"
