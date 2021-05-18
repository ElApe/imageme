#!/bin/bash
#Mounts nfs share and images system drive to it using DD
mount backup:/mnt/$HOSTNAME /mnt

if grep -qs '/mnt ' /proc/mounts; then
        FC=$(ls /mnt/ | wc -l)
        echo "File Count: $FC"


        if [[ $FC -gt 2 ]]; then
                echo "$(ls -t /mnt/ | tail -1)"
                rm -f /mnt/"$(ls -t /mmnt/ | tail -1)"

        else
                echo "Less than two files"
        fi


         FREE=$(df -H /mnt | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 }')
         FREE=${FREE%?}

         if [[ $FREE -gt 2 ]]; then
               echo "Imaging"
               dd if=/dev/sda of=/mnt/$HOSTNAME\_$(date '+%Y-%m-%d').img
               #echo "Subject: Imaged $HOSTNAME" | sendmail nsharp@ussharps.co.uk
         else
               echo "Less than 20% space available"
         fi

else
         echo "Subject: Failed to mount backup drive on $HOSTNAME"
#| sendmail nsharpk@ussharps.co.uk
fi
umount /mnt

