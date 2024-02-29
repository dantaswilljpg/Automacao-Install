#!/bin/bash

# Verificar se o whiptail está instalado
if ! command -v whiptail &> /dev/null; then
    echo "Instalando whiptail..."
    sudo apt-get install -y whiptail
fi

# Função para instalar o Docker
install_docker() {
    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Instalando o Docker..." 10 50
    sudo apt install docker.io
    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Docker instalado com sucesso!" 10 50

    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Iniciando o serviço do Docker..." 10 50
    sudo systemctl start docker
    sudo systemctl enable docker

    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Baixando a imagem do MySQL 5.7..." 10 50
    sudo docker pull mysql:5.7
    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Imagem do MySQL 5.7 baixada com sucesso!" 10 50

    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Criando e executando o container MySQL..." 10 50
    sudo docker run -d -p 3306:3306 --name magister -e "MYSQL_ROOT_PASSWORD=aluno" mysql:5.7
    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Container MySQL criado e em execução!" 10 50

    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Executando o script SQL dentro do container MySQL..." 10 50
    sleep 15
    sudo docker exec -i magister mysql -u root -paluno < /home/ubuntu/Assistentes-app/script.sql
    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Script SQL executado com sucesso!" 10 50

    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Dando permissão de execução ao arquivo java.sh..." 10 50
    chmod +x java.sh
    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Permissão concedida com sucesso!" 10 50

    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Executando o arquivo java.sh..." 10 50
    ./java.sh
    whiptail --title "Bem-vindo ao Sistema da Magister" --msgbox "Arquivo java.sh executado com sucesso!" 10 50
}

# Menu de opções usando whiptail
option=$(whiptail --title "Sistema de monitoramento Magister" --menu "Escolha uma opção para avançar:" 15 50 5 \
    1 "Instalar Docker e configurar MySQL" \
    2 "Sair" \
    3>&1 1>&2 2>&3)

# Verificando a opção selecionada
case $option in
    1)
        install_docker
        ;;
    2)
        whiptail --title "Saindo" --msgbox "Saindo do script. Nenhuma ação realizada." 10 50
        ;;
    *)
        whiptail --title "Erro" --msgbox "Opção inválida. Saindo do script." 10 50
        ;;
esac
