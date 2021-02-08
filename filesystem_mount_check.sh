#!/bin/bash
echo "Checking for mounting at `date`" >> /var/log/mounting_check.log
is_mounted=0
total_mount=0
>|/var/log/mounting_check.log
for mount_point in `cat /etc/fstab | awk '{print $1}' | grep -vE '#|swap' | grep '^/'`
do 
    echo "checking for ${mount_point}" >> /var/log/mounting_check.log
    for mount_check in `df -h | awk '{print $1}' | grep '^/'`
    do 
        if [ ${mount_check} == ${mount_point} ]
        then 
            is_mounted=1
            total_mount=`expr $total_mount + 1`
        fi
    done

    if [ $is_mounted -ne 1 ]
    then
        echo "Mount point not available for ${mount_point}" >> /var/log/mounting_check.log
    else
        echo "Mount point available for ${mount_point}" >> /var/log/mounting_check.log
    fi
done

if [ `cat /etc/fstab | awk '{print $1}' | grep -vE '#|swap' | grep '^/' | wc -l` -ne ${total_mount} ]
then
    #echo "Mounting is not available for server, please check /var/log/mounting_check.log logs for more info." | mail -s 
    echo "mount not available please check" >>/var/log/mounting_check.log
else
    echo "all mount are available" >> /var/log/mounting_check.log
fi

echo "Mount check completed at `date`" >> /var/log/mounting_check.log
