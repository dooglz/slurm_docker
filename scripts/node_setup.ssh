THISHOST=$(hostname)
HOSTNAME=$(hostname -f)
if [ "$THISHOST" == "junker-hpc" ]; then
  echo "don't run this on the head node dummy!"
  exit 0
fi

echo setting up $HOSTNAME

sudo apt update
sudo apt upgrade -y

#install docker

sudo apt install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo "installing docker"
sudo apt update && sudo apt-get install -y docker-ce

#mount master nfs share
if [ ! -d "/mnt/share" ]; then
  sudo apt install -y nfs-common
  sudo mkdir /mnt/share
  sudo echo "192.168.1.1:/mnt/storage/share /mnt/share nfs rsize=8192,wsize=8192,timeo=14,intr" | sudo tee -a /etc/fstab
  sudo mount -a
else
  echo "looks like nfs mount is already here"
fi



sudo apt clean && sudo apt autoclean
