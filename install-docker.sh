# First import the GPG key
 
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
      --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
 
# Next, point the package manager to the official Docker repository
 
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
 
# Update the package database
 
sudo apt update

# Installing both packages will eliminate an unmet dependencies error when you try to install the 
# linux-image-extra-virtual by itself
 
sudo apt install linux-image-generic linux-image-extra-virtual
 
# Reboot the system so it would be running on the newly installed kernel image
 
#sudo reboot

# Install Docker
 
sudo apt install docker-engine
