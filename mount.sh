#!/bin/bash

#SAMBA Default username
CIFS_NAME="USERNAME"
#MOUNT_ORGN will be mounted into MOUNT_DEST
MOUNT_DEST=/home/user
MOUNT_ORGN=//192.168.0.1/backup

function usage {
	echo "$0 OPTIONS"
	echo "	-m	mount"
	echo "	-u	unmount"
	return
}
function mount {
	echo "Mounting"
	echo "Origin: $MOUNT_ORGN"
	echo "Target: $MOUNT_DEST"
	echo "Username: $CIFS_NAME"
	echo -n "Password: "
	read -s CIFS_PSWD
	echo ""
	sudo mount -t cifs -o username=$CIFS_NAME,password=$CIFS_PSWD $MOUNT_ORGN $MOUNT_DEST 
	if (( $? != 0 )) ; then
		echo 'ERROR! mount failed.'
	else
		echo 'Mount success!'
		ls -lh $MOUNT_DEST
		touch $MOUNT_DEST/../$(basename $MOUNT_DEST).mounted
	fi
}
function unmount {
	echo "Unmounting $MOUNT_DEST"
	sudo umount $MOUNT_DEST
	rm $MOUNT_DEST/../$(basename $MOUNT_DEST).mounted >&2
}

if [ $# -eq 0 ] ; then
	#Auto mount/unmount when no any parameter given
	if [ -f $MOUNT_DEST/../$(basename $MOUNT_DEST).mounted ] ; then
		unmount
	else
		mount
	fi
fi

while getopts "mu" opt ; do 
	case $opt in
		u)
			unmount ;;
		m)
			mount ;;
		*)
			usage;
			exit 1;
	esac
done

# shift $(( $OPTIND - 1))
# file=$1
# echo "$file"