#!/usr/bin/env bash

display_help() {
    echo ""
    echo "Install all requirements for deploy on rhaspberry pi"
    echo ""
    echo "  --create-directories Create all the directories required for ssl nginx and pi-hole"
    echo "  --generate-kpi Generate autosigned certificate + key for nginx"
    echo "  --filter-youtube-ads Create the youtube ads automation to blacklist ads in pi-hole"
    echo "  --help Display this help"
    echo ""
}

create_directories() {
    echo "Create directories"
    mkdir -p ./nginx/etc-ssl/private
    mkdir -p ./nginx/etc-ssl/public
    mkdir -p ./pi-hole/etc-dnsmasq.d
    mkdir -p ./pi-hole/etc-pihole
}

generate_kpi() {
    if [[ ! -d "./nginx/etc-ssl/private" ]]; then
        echo "nginx/etc-ssl/private is missing"
        exit
    fi
    if [[ ! -d "./nginx/etc-ssl/public" ]]; then
        echo "nginx/etc-ssl/public is missing"
        exit
    fi
    echo "BEGIN PKI GENERATION"
    openssl req -nodes -x509 -newkey rsa:4096 -keyout ./nginx/etc-ssl/private/key.pem -out ./nginx/etc-ssl/public/cert.pem -sha256 -days 365
    echo "PKI GENERATION ENDED"
}

start_server() {
    docker-compose up -d
}

filter_youtube_ads() {
    echo "PREPARING FILTER FOR YOUTUBE ADS"
    cd ..
    git clone https://github.com/greg95000/youTube_ads_4_pi-hole.git
    cd youTube_ads_4_pi-hole
    chmod a+x youtube_docker.sh
    echo "ADDING TO CRONTAB"
    sudo /bin/bash -c 'echo "0 */1 * * * sudo /home/pi/youTube_ads_4_pi-hole/youtube_docker.sh >/dev/null" >> /etc/crontab'
    echo "FILTER FOR YOUTUBE ADS ENDED GO BACK TO rhaspy-deploy-public"
    cd ../rhaspy-deploy-public/

}

main() {
    CREATE_DIRECTORY=false
    GENERATE_KPI=false
    for var in "$@"; do
        case $var in
            "--create-directories" )
                create_directories
                CREATE_DIRECTORY=true
            ;;
            "--generate-kpi" )
                generate_kpi
                GENERATE_KPI=true
            ;;
            "--filter-youtube-ads" )
                filter_youtube_ads
            ;;
            "--help" )
                display_help
                exit
            ;;
            * )
                display_help
                exit
            ;;
        esac
    done

    if [ "$CREATE_DIRECTORY" = true ] && [ "$GENERATE_KPI" = false ]; then
        exit
    fi

    start_server
}

main $@


