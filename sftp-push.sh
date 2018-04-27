# 1st argument - rom directory
# 2nd argument - device name
# 3rd argument - file upload name
sudo apt install -y sshpass
export SSHPASS= # Enter password here
cd $1/out/target/product/$2
sshpass -e sftp -oBatchMode=no -b - teamcardinal@frs.sourceforge.net << !
   cd /home/frs/project/cardinal-aosp/$2
   put $3
   bye
!
cd ~/
