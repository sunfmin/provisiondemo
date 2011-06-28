require "bundler/setup"
require 'provisioning/capistrano'

set :application, "provisiondemo"
set :repository,  "git@github.com:sunfmin/provisiondemo.git"

set :scm, :git

set :deploy_to, "$HOME/app"
set :user, "app"
set :bundle_cmd, "/var/lib/gems/1.8/bin/bundle"

set :rails_env, "production"

role :web,  "175.41.244.168", :primary => true, :image_id => "ami-460fa447", :flavor_id => "t1.micro"
role :db,  "175.41.244.168"
role :app,  "175.41.244.168"

namespace :deploy do
  # unicorn scripts cribbed from https://github.com/daemon/capistrano-recipes/blob/master/lib/recipes/unicorn.rb
  desc "Restart unicorn"
  task :restart, :roles => :app do
    run "kill -USR2 `cat /home/app/app/shared/pids/unicorn.pid`" do |ch, stream, out|
      # is this block necessary?
    end
  end

  task :stop, :roles => :app do
    run "kill -QUIT `cat /home/app/app/shared/pids/unicorn.pid`" do |ch, stream, out|
      # is this block necessary?
    end
  end

  task :start, :roles => :app do
    run "cd #{current_path} && bundle exec unicorn -E #{rails_env} -D -c #{current_path}/config/system/unicorn.conf.rb" do |ch, stream, out|
      # is this block necessary?
    end
  end

  namespace :unicorn do
    [["TTIN", :add_worker, "Increase the Unicorn worker count by one"],
     ["TTOU", :remove_worker, "Decrease the Unicorn worker count by one"],
    ].each do |signal, task_name, description|
      desc description
      task task_name, :roles => :app do
        run "kill -#{signal} `cat /home/app/app/shared/pids/unicorn.pid`"
      end
    end
  end
end
