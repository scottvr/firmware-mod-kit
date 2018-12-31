#!/bin/bash

FSIMG="$1"
ROOTFS="$2"
ROOTFS_CREATED=0

if [ "$FSIMG" == "" ] || [ "$FSIMG" == "-h" ]
then
	echo "Usage: $(basename $0) <linux filesystem file> [output directory]\n"
	exit 1
fi

if [ "$ROOTFS" == "" ]
then
	ROOTFS="./linux-root"
fi

FSIMG=$(readlink -f $FSIMG)
ROOTFS=$(readlink -f $ROOTFS)

if [ ! -e $ROOTFS ]
then
	mkdir -p $ROOTFS
	mkdir -p ${ROOTFS}.mnt
	ROOTFS_CREATED=1
fi

${SUDO} mount ${FSIMG} ${ROOTFS}.mnt 2>/dev/null
cd $ROOTFS && ${SUDO} cp -pR ${ROOTFS}.mnt/* . 2>/dev/null
${SUDO} umount ${ROOTFS}.mnt 2>/dev/null
rm -rf ${ROOTFS}.mnt

if [ "$(ls $ROOTFS)" == "" ] && [ "$ROOTFS_CREATED" == "1" ]
then
	rm -rf $ROOTFS
	rm -rf ${ROOTFS}.mnt
fi
