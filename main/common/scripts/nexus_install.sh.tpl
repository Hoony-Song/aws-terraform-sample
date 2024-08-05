#!/bin/bash

# 의존성요소 설치 
sudo apt-get update -y
sudo apt-get -y install ca-certificates tzdata perl curl vim openjdk-8-jdk

# 초기 세팅 
sudo hostnamectl set-hostname ${nexus_host}
echo "HISTTIMEFORMAT=\"%F %T\"" | sudo tee --append /etc/profile
echo "export HISTTIMEFORMAT" | sudo tee --append /etc/profile
source /etc/profile
sudo swapoff -a

#방화벽
sudo ufw disable
sudo systemctl stop ufw

# [Amazon Linux 시간 설정]
sudo timedatectl set-timezone 'Asia/Seoul'

# device_path="/dev/nvme1n1"

# # Wait for the volume to be attached.
# while [ ! -b $device_path ]; do
#   echo "Waiting for $device_path..."
#   sleep 5
# done

# 마운트 추가 
sudo mkfs -t ext4 /dev/nvme1n1
sudo mkdir /data_dir
sudo mount /dev/nvme1n1 /data_dir


# fstab uuid 추가 
#echo "$(blkid | grep -o 'UUID="[a-z0-9-]*"' | tail -1)  /data_dir  ext4  defaults,nofail  0  2" | sudo tee --append /etc/fstab
UUID=$(sudo blkid -s UUID -o value /dev/nvme1n1)
echo "UUID=$UUID  /data_dir  ext4  defaults,nofail  0 2" | sudo tee --append /etc/fstab
sudo umount /data_dir
sudo mount -a

# sudo wget -P /data_dir https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo wget -O /data_dir/latest-unix.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo tar xvfz /data_dir/latest-unix.tar.gz -C /data_dir/

sudo mv /data_dir/nexus-* /data_dir/nexus

# 유저 추가 
sudo adduser --gecos "" --disabled-password nexus
sudo echo "nexus:Tobe1234!" | sudo chpasswd

# 권한 변경
sudo chown -R nexus:nexus /data_dir/nexus
sudo chown -R nexus:nexus /data_dir/sonatype-work

# 구동스크립트 작성
sudo sed -i 's/#run_as_user=""/run_as_user="nexus"/g' /data_dir/nexus/bin/nexus.rc

cat <<EOF | sudo tee /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=network.target
[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/data_dir/nexus/bin/nexus start
ExecStop=/data_dir/nexus/bin/nexus stop
User=nexus
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOF

# Data 디렉토리 변경
sudo sed -i 's|-XX:LogFile=../sonatype-work/nexus3/log/jvm.log|-XX:LogFile=/data_dir/sonatype-work/nexus3/log/jvm.log|g' /data_dir/nexus/bin/nexus.vmoptions
sudo sed -i 's|-Dkaraf.data=../sonatype-work/nexus3|-Dkaraf.data=/data_dir/sonatype-work/nexus3|g' /data_dir/nexus/bin/nexus.vmoptions
sudo sed -i 's|-Dkaraf.log=../sonatype-work/nexus3/log|-Dkaraf.log=/data_dir/sonatype-work/nexus3/log|g' /data_dir/nexus/bin/nexus.vmoptions
sudo sed -i 's|-Djava.io.tmpdir=../sonatype-work/nexus3/tmp|-Djava.io.tmpdir=/data_dir/sonatype-work/nexus3/tmp|g' /data_dir/nexus/bin/nexus.vmoptions

# 데몬 구동
sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus