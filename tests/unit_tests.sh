#!/bin/bash

# Levantar la máquina virtual
vagrant up

# Ejecutar las pruebas
vagrant ssh -c "cd /vagrant/test_database && chef exec rspec --format=documentation || exit 1"
vagrant ssh -c "cd /vagrant/test_wordpress && chef exec rspec --format=documentation || exit 1"
vagrant ssh -c "cd /vagrant/test_proxy && chef exec rspec --format=documentation || exit 1"

# Destruir la máquina virtual
vagrant destroy -f test
