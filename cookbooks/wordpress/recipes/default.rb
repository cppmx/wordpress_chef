include_recipe 'updates'

execute "add host" do
    command "echo '192.168.56.20       db.unir.mx' >> /etc/hosts"
    action :run
end

case node['platform_family']
when 'debian', 'ubuntu'
    include_recipe 'wordpress::ubuntu_web'    # Instalamos el servidor web
    include_recipe 'wordpress::ubuntu_wp'     # Instalamos wordpress
when 'rhel', 'fedora'
    include_recipe 'wordpress::centos_web'    # Instalamos el servidor web
    include_recipe 'wordpress::centos_wp'     # Instalamos wordpress
end

# include_recipe 'wordpress::wp_cli'            # Ejecutamos la configuración inicial