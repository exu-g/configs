# Putty

**Important: Putty has to be executed as root, otherwise it won't work**  

1. Find proper serial port using `ls /dev | grep tty` or `ls -l /sys/class/tty`  
2. Connect to it using `sudo putty /dev/<port> -serial -sercfg <baud rate>,8,n,1,N`  

root, root  
![](/home/marc/GitProjects/config/Dokumente/other-linux/apu2c4-router-apprenticeship-login.png)
