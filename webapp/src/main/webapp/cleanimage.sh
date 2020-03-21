#!/bin/bash

#Description: script to clean up images
#Author: Joel M
#Date: March 2020


for i in $(docker images | awk '{print$3}' | grep -v IMAGE);
do 
docker rmi -f ${i}
done


