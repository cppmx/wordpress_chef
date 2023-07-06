case node['platform_family']
when 'debian', 'ubuntu'
    execute "apt-get update" do
        command "apt update -y && apt upgrade -y"
        action :run
    end
when 'rhel', 'fedora'
    execute "dnf update" do
        command "sudo dnf update -y && sudo dnf upgrade -y"
        action :run
    end
end