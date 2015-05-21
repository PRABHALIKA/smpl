# Define roles, user and IP address of deployment server
# role :name, %{[user]@[IP adde.]}
role :app, %w{deployer@10.18.83.134}
role :web, %w{deployer@10.18.83.134}
role :db, %w{deployer@10.18.83.134}

# Define server(s)
server '10.18.83.134', user: 'deployer', role: %w{app}
server '10.18.83.134', user: 'deployer', role: %w{db}
server '10.18.83.134', user: 'deployer', role: %w{web}
# SSH Options
# See the example commented out section in the file
# for more options.

set :ssh_options, {
	
    forward_agent: false,
    keys: %w(/home/knome/.ssh/id_rsa),
    auth_methods: %w(password),
    password: 'password',
    user: 'deployer'
}
set :deploy_to, "/home/deployer/apps/smpl"
before "deploy:restart", "fix:permission"

namespace :fix do
  task :permission do
  	on  roles(:app) do
    run  "chown -R deploy:deploy #{deploy_to}"
  	end
  end
  task :start do
    on roles(:app) do 
      run "cd #{current_path}; #{asset_env} rails s -e production "
    end 
  end
end


