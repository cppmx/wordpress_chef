#!/bin/bash

function unit_tests_on_vm()
{
    local VAGRANT_CMD=$(which vagrant)

    if [[ "$VAGRANT_CMD" == "" ]]; then
        echo "No se encontro el comando vagrant en el sistema"
        exit 1
    fi

    export TESTS=true

    echo -e "\n########## Ejecutando las pruebas unitarias en una VM ##########"

    $VAGRANT_CMD up

    # Ejecutar las pruebas
    $VAGRANT_CMD ssh -c "cd /vagrant/cookbooks/database && chef exec rspec --format=documentation"
    $VAGRANT_CMD ssh -c "cd /vagrant/cookbooks/wordpress && chef exec rspec --format=documentation"
    $VAGRANT_CMD ssh -c "cd /vagrant/cookbooks/proxy && chef exec rspec --format=documentation"

    # Destruir la máquina virtual
    $VAGRANT_CMD destroy -f test

    unset TESTS

    echo "########## Fin de las pruebas unitarias en una VM ##########"
}

function run_tests_on_a_conatiner()
{
    local DOCKER_CMD=$(which docker)
    local DOCKER_IMAGE="cppmx/chefdk:latest"
    local TEST_CMD="chef exec rspec --format=documentation"

    if [[ "$DOCKER_CMD" == "" ]]; then
        echo "No se encontro el comando docker en el sistema"
        exit 1
    fi

    $DOCKER_CMD run --rm -v $1:/cookbooks $DOCKER_IMAGE $TEST_CMD
}

function unit_tests_on_a_conatiner()
{
    local DATABASE="$(pwd)/cookbooks/database"
    local WORDPRESS="$(pwd)/cookbooks/wordpress"
    local PROXY="$(pwd)/cookbooks/proxy"

    echo -e "\n########## Ejecutando las pruebas unitarias en Docker ##########"

    echo "Probando las recetas de Database"
    run_tests_on_a_conatiner $DATABASE

    echo "Probando las recetas de Wordpress"
    run_tests_on_a_conatiner $WORDPRESS

    echo "Probando las recetas de Proxy"
    run_tests_on_a_conatiner $PROXY

    echo "########## Fin de las pruebas unitarias en Docker ##########"
}

function itg_tests()
{
    local KITCHEN_CMD=$(which kitchen)

    cd $1
    $KITCHEN_CMD test
}

function all_itg_tests()
{
    local COOKBOOKS=$(pwd)/cookbooks

    itg_tests $COOKBOOKS/database
    itg_tests $COOKBOOKS/wordpress
    itg_tests $COOKBOOKS/proxy
}

function manual()
{
    # Menú de inicio
    echo "Seleccione una opción:"
    echo "1. Ejecutar pruebas unitarias en una VM"
    echo "2. Ejecutar pruebas unitarias en un contenedor"
    echo "3. Ejecutar pruebas de integración e infraestructura"
    echo "4. Salir"
    read -p "Opción: " OPTION

    case $OPTION in
        1) unit_tests_on_vm ;;
        2) unit_tests_on_a_conatiner ;;
        3) all_itg_tests ;;
        4) echo "Hasta luego :)" && exit 0 ;;
        *) echo "Opción inválida. Saliendo..." ;;
    esac
}

if [[ "$1" == "" ]]; then
    manual
elif [[ "$1" == "vm" ]]; then
    unit_tests_on_vm
elif [[ "$1" == "docker" ]]; then
    unit_tests_on_a_conatiner
elif [[ "$1" == "database" ]]; then
    itg_tests $(pwd)/cookbooks/database
elif [[ "$1" == "wordpress" ]]; then
    itg_tests $(pwd)/cookbooks/wordpress
elif [[ "$1" == "proxy" ]]; then
    itg_tests $(pwd)/cookbooks/proxy
else
    echo "Opción inválida"
    exit 1
fi
