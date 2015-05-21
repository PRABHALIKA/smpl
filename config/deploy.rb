# Define the name of the application
set :application, 'smpl'

# Define where can Capistrano access the source repository
# set :repo_url, 'https://github.com/[user name]/[application name].git'
set :scm, :git
set :repo_url, 'https://github.com/PRABHALIKA/smpl.git'

# Define where to put your application code
set :deploy_to, "/home/deployer/apps/smpl"

set :pty, true

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