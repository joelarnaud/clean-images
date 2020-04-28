#!/bin/bash

#Description: check all the hardening
#Author: Joel M
#Date: April 2020

echo " *** MAKING THIS SYSTEM HARD FOR INTRUDER *** "

#set root password for maintenance mode
echo -e "\n 1. set root password for maintenance mode \n"
a=$(grep -n SINGLE /etc/sysconfig/init | awk -F: '{print$1}')
sed -i "${a}s/.*/SINGLE=\/sbin\/sulogin/" /etc/sysconfig/init
[ $? -eq 0 ] || echo -n "\n no root password asking in maintenance mode \n"
sleep 3

#set system not to boot in iteractive mode
echo -e "\n 2. set system not to boot in interactive mode \n"
b=$(grep -n PROMPT /etc/sysconfig/init | awk -F: '{print$1}')
sed -i "${b}s/=yes/=no/" /etc/sysconfig/init
[ $? -eq 0 ] || echo -n "\n system can boot in interactive mode \n"
sleep 3

#set selinux to enforcing
echo -e "\n 3. set up selinux to enforcing \n"
c=$(egrep -n 'SELINUX=e|SELINUX=p|SELINUX=d' /etc/selinux/config | awk -F: '{print$1}')
sed -i "${c}s/.*/SELINUX=enforcing/" /etc/selinux/config
[ $? -eq 0 ] || echo -n "\n selinux is not set in enforcing \n"
sleep 3

#set grub password
echo -e "\n 4. set grub password \n"
echo -e "\n enter grub password twice when required \n"
sleep 2
sed -i "/hiddenmenu/a password --encrypted $(grub-crypt)" /etc/grub.conf 
[ $? -eq 0 ] || echo -n "\n grub can be interrupted \n"
sleep 3

#securing a system base of service
echo -e "\n 5. securing a system base of services \n"
echo "provide infos about services you need to allow"
read d
sed -i "$ i\ ${d}" /etc/hosts.allow
[ $? -eq 0 ] || echo -n "\n no new service allowed \n"
sleep 2
echo "provide infos about services you need to deny" 
read e
sed -i "$ i\ ${e}" /etc/hosts.deny
[ $? -eq 0 ] || echo -n "\n no new service denied \n"
sleep 3

#enforce password policy
echo -e "\n 6. enforcing password policy \n"
echo " renew password after 60 days "
f=$(grep -n ^PASS_MAX_DAYS /etc/login.defs | awk -F: '{print$1}')
sed -i "${f}s/.*/PASS_MAX_DAYS    90/" /etc/login.defs
[ $? -eq 0 ] || echo -n "\n password policy is not enforce \n"
sleep 3
echo -e "\n *** INTRUDER CAN'T TAKE THIS SYSTEM ***\n"



 
