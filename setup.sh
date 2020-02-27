#!/bin/bash

display_usage(){
	echo "Usage:\n
	./setup.sh <domain>"
}

setup_ad(){
	echo -e "\e[1m\e[32m[\e[1m\e[31m*\e[1m\e[32m] Updating System\e[0m\e[39m"
	sudo apt update -q
	sudo apt dist-upgrade -yq
	echo -e "\e[1m\e[32m[\e[1m\e[31m*\e[1m\e[32m] Installing required packages\e[0m\e[39m"
	sudo apt install samba smbclient winbind dnsutils bind9 krb5-admin-server krb5-kdc ufw -yq
	echo -e "\e[1m\e[32m[\e[1m\e[31m*\e[1m\e[32m] Stopping any SAMBA services\e[0m\e[39m"
	sudo systemctl stop smb.service smbd.service nmbd.service winbindd.service samba.service
	echo -e "\e[1m\e[32m[\e[1m\e[31m*\e[1m\e[32m] Cleaning up SAMBA\e[0m\e[39m"
	sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.org
	samba_dirs=$(smbd -b | egrep "LOCKDIR|STATEDIR|CACHEDIR|PRIVATE_DIR" | cut -d ":" -f 2 | tr -d " ")
	echo $samba_dirs[0]
}

if [[ $USER -ne "root" ]]
then
	echo -e "\e[1m\e[31mRun as root!\e[39m\e[0m"
	exit 1
fi

if [[ ($# == "--help") || ($# == "-h") ]]
then
	display_usage
	exit 1
fi

if [ $# -le 1 ]
then
	display_usage
	exit 1
fi

setup_ad "$1"
