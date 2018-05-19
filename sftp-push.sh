# 1st argument - rom directory
# 2nd argument - device name
# 3rd argument - file upload name
# Ex:- . sftp-push.sh /home/user/cardinal-aosp tissot Cardinal-AOSP-5.5-OREO-tissot-OFFICIAL-20180426.zip

#sudo apt install -y sshpass
cd ~
wget https://github.com/thelazyindian/Scripts/raw/master/sshpass
chmod +x sshpass
export SSHPASS= # Enter password here
cd $1/out/target/product/$2
~/sshpass -e sftp -oBatchMode=no -b - teamcardinal@frs.sourceforge.net << !
   cd /home/frs/project/cardinal-aosp/$2
   put $3
   bye
!

