include_recipe 'updates'

case node['platform_family']
when 'debian', 'ubuntu'
    include_recipe 'database::ubuntu'
when 'rhel', 'fedora'
    include_recipe 'database::centos'
end