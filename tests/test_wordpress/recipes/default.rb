db_ip = "127.0.0.1"

execute "add host" do
    command "echo '#{db_ip}       db.unir.mx' >> /etc/hosts"
    action :run
end

case node['platform_family']
when 'debian', 'ubuntu'
    execute "update" do
        command "apt update -y && apt upgrade -y"
        action :run
    end
    include_recipe 'test_wordpress::ubuntu_web'    # Instalamos el servidor web
    include_recipe 'test_wordpress::ubuntu_wp'     # Instalamos wordpress
when 'rhel', 'fedora'
    execute "update" do
        command "sudo dnf update -y && sudo dnf upgrade -y"
        action :run
    end
    include_recipe 'test_wordpress::centos_web'    # Instalamos el servidor web
    include_recipe 'test_wordpress::centos_wp'     # Instalamos wordpress
end

# include_recipe 'wordpress::wp_cli'            # Ejecutamos la configuración inicial