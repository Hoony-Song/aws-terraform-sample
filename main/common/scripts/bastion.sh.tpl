#!/bin/bash

# 의존성요소 설치 
sudo apt-get update -y
sudo apt-get -y install ca-certificates tzdata perl curl vim

# 초기 세팅 
sudo hostnamectl set-hostname ${bastion_host}
echo "HISTTIMEFORMAT=\"%F %T\"" | sudo tee --append /etc/profile
echo "export HISTTIMEFORMAT" | sudo tee --append /etc/profile
source /etc/profile
sudo swapoff -a

#방화벽
sudo ufw disable
sudo systemctl stop ufw

# [Amazon Linux 시간 설정]
sudo timedatectl set-timezone 'Asia/Seoul'

# gitlab 과 nexus ip hosts에 등록
sudo echo "${gitlab_ip} ${gitlab_host}" | sudo tee -a /etc/hosts
sudo echo "${nexus_ip} ${nexus_host}" | sudo tee -a /etc/hosts

# ssh 연결시 host key checking 비활성화 
sudo echo "StrictHostKeyChecking no" | sudo tee -a /etc/ssh/ssh_config


