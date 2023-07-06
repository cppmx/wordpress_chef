db_user = node['mysql']['user']
db_pswd = node['mysql']['password']

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
    command "mysql -e \"CREATE USER '#{db_user}'@'192.168.56.10' IDENTIFIED BY '#{db_pswd}'; GRANT ALL PRIVILEGES ON wordpress.* TO '#{db_user}'@'192.168.56.10'; FLUSH PRIVILEGES;\""
    action :run
    not_if "mysql -e \"SELECT User, Host FROM mysql.user WHERE User = '#{db_user}' AND Host = '192.168.56.10'\" | grep #{db_user}"
end

execute 'Bind to private interface' do
    command "sed -i 's/127.0.0.1/192.168.56.20/g' /etc/mysql/mysql.conf.d/mysqld.cnf"
    action :run
    notifies :restart, 'service[mysql]', :immediately
    only_if { ::File.exist?('/etc/mysql/mysql.conf.d/mysqld.cnf') }
end