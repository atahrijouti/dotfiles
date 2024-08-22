HOME_USER="name-of-home-user"
## First remove all snap traces

sudo apt update
sudo apt upgrade


## Add users
### Users without home

sudo useradd -r -s /bin/false -u 1100 myfiles
sudo useradd -r -s /bin/false -u 1101 mymedia
sudo useradd -r -s /bin/false -u 1102 myprinter

### Groups

sudo groupadd -g 1100 myfiles
sudo groupadd -g 1101 mymedia
sudo groupadd -g 1102 myprinter
sudo groupadd -g 1200 samba

sudo usermod -a -G dialout,myfiles,mymedia,video,render,samba ${HOME_USER}


## fstab

sudo mkdir /hdd
sudo mkdir /hdd/files
sudo mkdir /hdd/media
sudo vim /etc/fstab

cat <<EOT >> /etc/fstab

/dev/sda1       /hdd/files     ext4 defaults   0       0
/dev/sdb1       /hdd/media      ext4 defaults   0       0
EOT

mount -a

## Samba


sudo apt install samba

sudo smbpasswd -a ${HOME_USER}
sudo smbpasswd -a mymedia
sudo smbpasswd -a myfiles
sudo smbpasswd -a myprinter

mkdir myshare
sudo chown ${HOME_USER}:samba myshare
mkdir myprinter
sudo chown myprinter:samba myprinter

cat <<EOT >> /etc/samba/smb.conf
[Media]
  path = /hdd/media
  writeable = yes
  browseable = yes
  valid users = @media
  force user = dockerjellyfin

[MyFiles]
  path = /hdd/files
  writeable = yes
  browseable = yes
  valid users = @myfiles
  force user = dockerfilerun

[${HOME_USER}]
  comment = ${HOME_USER} share folder
  follow symlinks = yes
  path = /home/${HOME_USER}/myshare
  wide links = yes
  browseable = yes
  writeable = yes
  valid users = ${HOME_USER}

[MyPrinter]
  path = /home/${HOME_USER}/myprinter
  valid users = myprinter, ${HOME_USER}
  browseable = yes
  writeable = yes
  force user = ${HOME_USER}
EOT

sudo service smbd restart


# Audio & Video
sudo apt install pulseaudio
sudo apt install vainfo intel-media-va-driver-non-free software-properties-common -y

## latest video drivers for intel could be fetched like so
# https://dgpu-docs.intel.com/installation-guides/ubuntu/ubuntu-focal.html

# sudo apt-get install -y gpg-agent wget
# wget -qO - https://repositories.intel.com/graphics/intel-graphics.key |
#   sudo apt-key add -
# sudo apt-add-repository \
#   'deb [arch=amd65] https://repositories.intel.com/graphics/ubuntu focal main'

# sudo apt-get update
# sudo apt-get install \
#   intel-opencl-icd \
#   intel-level-zero-gpu level-zero \
#   intel-media-va-driver-non-free libmfx2

## UFW

sudo ufw allow samba
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
# sudo ufw allow 8011
sudo ufw enable

# Docker

sudo apt update
sudo apt install apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt install docker-ce
sudo usermod -aG docker ${HOME_USER}

# run docker-compose

# run portainer in the same network as treasures
docker run -d \
 --name=portainer \
 --restart=unless-stopped \
 --network=treasures_default \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v /home/${HOME_USER}/docker-data/portainer:/data \
 portainer/portainer-ce

## fix QSV not working in some versions of jellyfin
## https://github.com/jellyfin/jellyfin/issues/5993#issuecomment-921702524
##
