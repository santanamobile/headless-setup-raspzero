#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Este script deve ser executado como root."
  exit 1
fi

########################################
# Dispositivo de armazenamento
DEVICE="/dev/sdb"
# Credenciais de usuario
USERNAME="usuario"
PASSWORD="userpass"
########################################

BOOTFS="/mnt/bootfs"
ROOTFS="/mnt/rootfs"

if [ ! -d "${BOOTFS}" ]; then
    mkdir -p ${BOOTFS}
fi

if [ ! -d "${ROOTFS}" ]; then
    mkdir -p ${ROOTFS}
fi

if findmnt "${DEVICE}1" > /dev/null 2>&1; then
    umount ${DEVICE}1
fi

if findmnt "${DEVICE}2" > /dev/null 2>&1; then
    umount ${DEVICE}2
fi

mount ${DEVICE}1 ${BOOTFS}
mount ${DEVICE}2 ${ROOTFS}

# Ativa o servidor ssh na inicializacao
touch ${BOOTFS}/ssh

echo "${USERNAME}:$(echo ${PASSWORD} | openssl passwd -6 -stdin)" > ${BOOTFS}/userconf.txt

# Habilita o modo USB OTG na inicializacao
if ! grep -q "^dtoverlay=dwc2" "${BOOTFS}/config.txt"; then
    echo "dtoverlay=dwc2\n" | tee -a ${BOOTFS}/config.txt
fi;

# Habilita USB Serial Gadget Mode
if ! grep -q "^g_serial" "${BOOTFS}/cmdline.txt"; then
    sed -i 's/rootwait/& modules-load=dwc2,g_serial/' ${BOOTFS}/cmdline.txt
    cd ${ROOTFS}/etc/systemd/system/getty.target.wants
    ln -s /lib/systemd/system/getty@.service getty@ttyGS0.service
fi

sync

sleep 2

umount /mnt/*
