# Define roles, user and IP address of deployment server
# role :name, %{[user]@[IP adde.]}
role :app, %w{knome@10.18.83.134}
role :web, %w{knome@10.18.83.134}
role :db, %w{knome@10.18.83.134}

# Define server(s)
server '10.18.83.134', user: 'knome', role: %w{app}
server '10.18.83.134', user: 'knome', role: %w{db}
server '10.18.83.134', user: 'knome', role: %w{web }
# SSH Options
# See the example commented out section in the file
# for more options.
set :ssh_options, {
	
    forward_agent: false,
    keys: %w(/home/knome/.ssh/id_rsa),
    auth_methods: %w(password),
    password: 'knome',
    user: 'knome'
}