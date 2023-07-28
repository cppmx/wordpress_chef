# Instalar WP CLI
remote_file '/tmp/wp' do
  source 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Mover WP CLI a /bin
execute 'Move WP CLI' do
  command 'mv /tmp/wp /bin/wp'
  not_if { ::File.exist?('/bin/wp') }
end

# Hacer WP CLI ejecutable
file '/bin/wp' do
  mode '0755'
end

# Instalar Wordpress y configurar
execute 'Finish Wordpress installation' do
  command 'sudo -u vagrant -i -- wp core install --path=/opt/wordpress/ --url=localhost --title="UNIR Actividad Grupal 1001A" --admin_user=admin --admin_password="admin@UN1R" --admin_email=team1001A@unir.mx'
  not_if 'wp core is-installed', environment: { 'PATH' => '/bin:/usr/bin:/usr/local/bin' }
end