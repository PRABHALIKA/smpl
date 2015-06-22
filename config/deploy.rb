# Define the name of the application
set :application, 'smpl'

# Define where can Capistrano access the source repository
# set :repo_url, 'https://github.com/[user name]/[application name].git'
set :scm, :git
set :repo_url, 'https://github.com/PRABHALIKA/smpl.git'

# Define where to put your application code
set :deploy_to, "/home/deployer/apps/smpl"

set :pty, true
set :use_sudo, true

set :format, :pretty


set :rbenv_ruby, '2.1.2'

set :to_symlink,
  ["config/database.yml","public/assets"]

# Set the post-deployment instructions here.
# Once the deployment is complete, Capistrano
# will begin performing them as described.
# To learn more about creating tasks,
# check out:
# http://capistranorb.com/

# namespace: deploy do

#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       # Your restart mechanism here, for example:
#       execute :touch, release_path.join('tmp/restart.txt')
#     end
#   end
 desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "service thin restart"  ## -> line you should add
    end
  end
#================== tasks ====================
namespace :deploy do
  task :copy_config_files
  on roles (:app) do
    db_config = "#{path}/database.yml"
    thin_config = "#{path}/thin_config.yml"
    run "cp #{db_config} #{release_path}/config/database.yml"
    run "cp #{thin_config} #{release_path}/"
  end

  task :precompile do
    run "cd #{release_path}; source $HOME/.bash_profile && bundle exec rake assets:precompile RAILS_ENV=production"
  end

  task :migration do
    run "cd #{release_path}; source $HOME/.bash_profile && bundle exec rake db:migrate RAILS_ENV=production"
  end

  task :config_nginx do
    pre = File.basename(previous_release)
    cur = File.basename(release_path)
    run "#{sudo} sed 's/#{pre}/#{cur}/g' /etc/nginx/sites-available/default"
  end

  task :restart_thin_server do
    run "cd #{previous_release}; source $HOME/.bash_profile && thin stop -C thin_config.yml"
    run "cd #{release_path}; source $HOME/.bash_profile && thin start -C thin_config.yml"
  end

  task :restart_nginx do
    run "#{sudo} service nginx restart"
  end

end

after "deploy:finalize_update", 
# after this step, excute the following task
      "deploy:copy_config_files", 
      "deploy:precompile", 
      "deploy:config_nginx",
      "deploy:restart_thin_server"
      "deploy:restart_nginx"

#   after :publishing, :restart

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end

# end