Vagrant.configure("2") do |config|
    config.vm.define "database" do |db|
        db.vm.box = ENV["BOX_NAME"] || "ubuntu/focal64"  # Utilizamos una imagen de Ubuntu 20.04 por defecto
        db.vm.hostname = "db.unir.mx"
        db.vm.network "private_network", ip: "192.168.56.20"

        db.vm.provision "chef_solo" do |chef|
        chef.install = "true"
        chef.arguments = "--chef-license accept"
        chef.add_recipe "database"
        end
    end

    config.vm.define "wordpress" do |sitio|
        sitio.vm.box = ENV["BOX_NAME"] || "ubuntu/focal64"  # Utilizamos una imagen de Ubuntu 20.04 por defecto
        sitio.vm.hostname = "wordpress.unir.mx"
        sitio.vm.network "private_network", ip: "192.168.56.10"

        sitio.vm.provision "chef_solo" do |chef|
        chef.install = "true"
        chef.arguments = "--chef-license accept"
        chef.add_recipe "wordpress"
        end
    end
end