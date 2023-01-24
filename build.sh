#!/bin/bash
set -ex
#export VERSION=$(cat debian/changelog | head -n 1 | sed "s/.*(//g" | sed "s/).*//g")
export VERSION=$(curl https://linux-libre.fsfla.org/pub/linux-libre/releases/ | sed "s/.*href=\"//g;s/-gnu.*//g" | grep -e "^[0-9]" | grep -v "rc" | sort -V | tail -n 1)
if echo ${VERSION} | grep -e "\.[0-9]*\.0$" ; then
    export VERSION=${VERSION::-2}
fi
# Stage 0: set version
sed -i "s/9999/${VERSION}/g" debian/changelog
# Stage 1: Get version and fetch source code
# fetch source
wget https://gitlab.com/turkman/devel/sources/mklinux/-/raw/master/mklinux.sh -O mklinux
mkdir -p ./debian/linux-libre
ALLOWROOT=1 bash mklinux -i -v ${VERSION} -o "./debian/linux-libre" -t libre -c "https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/linux/trunk/config" -y 1
# decompress for initramfs-tools
find ./debian/linux-libre -type f -iname "*.ko.zst" -exec zstd -d --rm {} \;
