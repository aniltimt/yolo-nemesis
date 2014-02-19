#$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user

set :application, "df_market_api"

set :user, "deploy"
set :use_sudo, false

set :repository,  "ssh://df-vpnc@tanker/stor/git/repositories/df_market_api.git"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :rails_env, "staging"

set :scm, :git
#set :scm_username, 'df-vpnc'
#set :scm_password, '3214M5'
#set :scm_verbose, true

set :rake, "bundle exec rake"
#ssh_options[:keys] = %w(~/.ssh/dfs.key)
#ssh_options[:forward_agent] = true
#default_run_options[:pty] = true  # Must be set for the password prompt from git to work

server "10.1.0.217", :app, :web, :db

set :whenever_environment, defer { rails_env }
set :whenever_identifier, defer { "#{application}_#{rails_env}" }
set :whenever_command, "source $HOME/.rvm/scripts/rvm && bundle exec whenever"

def run_wp cmd
  run "cd #{release_path} && #{cmd}"
end

namespace :deploy do
  task :share_links do
    run_wp "ln -nfs #{deploy_to}/#{shared_dir}/database.yml #{release_path}/config/database.yml"
  end

  task :stop do ; end

  task :start do ; end

  task :restart do
    run_wp "touch tmp/restart.txt"
  end
end

namespace 'bundle' do
  task 'install' do
    run_wp "bundle install"
  end
end

after 'deploy:update_code', 'deploy:share_links'

require "whenever/capistrano"
