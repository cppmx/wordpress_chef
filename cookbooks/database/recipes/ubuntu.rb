db_user = node['config']['db_user']
db_pswd = node['config']['db_pswd']
db_ip   = node['config']['db_ip']
wp_ip   = node['config']['wp_ip']

# Instalar MySQL server
apt_package 'mysql-server' do
    action :install
end

# Habilitar el servicio MySQL
service 'mysql' do
    action [:enable, :start]
end

# Ejecutar comando para crear la base de datos
execute 'create_mysql_database' do
    command 'mysql -e "CREATE DATABASE wordpress;"'
    action :run
    not_if 'mysql -e "SHOW DATABASES;" | grep wordpress'
end

# Ejecutar comando para crear el usuario y otorgar permisos
execute 'create_mysql_user' do
    command "mysql -e \"CREATE USER '#{db_user}'@'#{wp_ip}' IDENTIFIED BY '#{db_pswd}'; GRANT ALL PRIVILEGES ON wordpress.* TO '#{db_user}'@'#{wp_ip}'; FLUSH PRIVILEGES;\""
    action :run
    not_if "mysql -e \"SELECT User, Host FROM mysql.user WHERE User = '#{db_user}' AND Host = '#{wp_ip}'\" | grep #{db_user}"
end

execute 'Bind to private interface' do
    command "sed -i 's/127.0.0.1/#{db_ip}/g' /etc/mysql/mysql.conf.d/mysqld.cnf"
    action :run
    notifies :restart, 'service[mysql]', :immediately
    only_if { ::File.exist?('/etc/mysql/mysql.conf.d/mysqld.cnf') }
end