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
