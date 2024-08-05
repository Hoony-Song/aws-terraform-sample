#!/bin/bash

# 의존성요소 설치 
sudo apt-get update -y
sudo apt-get -y install ca-certificates tzdata perl curl vim

# 초기 세팅 
sudo hostnamectl set-hostname ${gitlab_host}
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

sudo mkdir -p /data_dir/gitlab 


#Gitlab 설치 
sudo curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo apt-get install -y gitlab-ee=16.1.0-ee.0


sudo cat <<EOF | sudo tee /etc/gitlab/gitlab.rb
external_url 'https://${domain}'
letsencrypt['enable'] = false

alertmanager['enable'] = true
prometheus_monitoring['enable'] = true
prometheus['listen_address'] = 'localhost:9191'

grafana['enable'] = false
node_exporter['enable'] = false

git_data_dirs({ "default" => { "path" => "/data_dir/gitlab" } })

nginx['listen_port'] = 80
nginx['listen_https'] = false

nginx['client_max_body_size'] = '0'

nginx['proxy_set_headers'] = {
  "X-Forwarded-Proto" => "https",
  "X-Forwarded-Ssl" => "on",
  "Host" => "${domain}"
}
EOF


sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart

NEW_PASSWORD="${default_password}"
sudo gitlab-rails runner "user = User.where(id: 1).first; user.password = user.password_confirmation = '$NEW_PASSWORD'; user.save!"

sudo cat <<EOF | sudo tee /data_dir/gitlab_backup.sh
#!/bin/bash

# 오늘 날짜를 변수에 저장합니다.
TODAY=$(date +%Y%m%d)

# 백업 파일을 저장할 디렉토리를 설정합니다.
BACKUP_DIR=/data_dir/gitlab_backups/$TODAY

# 디렉토리를 생성합니다.
sudo mkdir -p $BACKUP_DIR

# 백업을 수행합니다.
sudo gitlab-backup create CRON=1

# 백업 파일을 이동합니다.
sudo mv /data_dir/gitlab/backups/*.tar $BACKUP_DIR
sudo cp /etc/gitlab/gitlab-secrets.json $BACKUP_DIR
sudo cp /etc/gitlab/gitlab.rb $BACKUP_DIR

# 5일 전의 백업 디렉토리를 삭제합니다.
sudo find /data_dir/gitlab_backups/* -mtime +3 -exec rm -rf {} \;
EOF

sudo chmod +x /data_dir/gitlab_backup.sh

(crontab -l 2>/dev/null; echo "* 23 * * * /data_dir/gitlab_backup.sh") | crontab -
