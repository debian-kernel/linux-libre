#!/bin/bash
set -ex
#export VERSION=$(cat debian/changelog | head -n 1 | sed "s/.*(//g" | sed "s/).*//g")
export VERSION=$(curl https://linux-libre.fsfla.org/pub/linux-libre/releases/ | sed "s/.*href=\"//g;s/-gnu.*//g" | grep -e "^[0-9]" | sort -V | tail -n 1)
if echo ${VERSION} | grep -e "\.0$" ; then
    export VERSION=${VERSION::-2}
fi
# Stage 1: Get version and fetch source code
# fetch source
wget -c http://linux-libre.fsfla.org/pub/linux-libre/releases/${VERSION}-gnu/linux-libre-${VERSION}-gnu.tar.xz
# extrack if directory not exists
[[ -d linux-${VERSION} ]] || tar -xf linux-libre-${VERSION}-gnu.tar.xz
echo 1 > .stage
# Enter source
cd linux-${VERSION}

# Redefine version
#export VERSION=$(cat ../debian/changelog | head -n 1 | sed "s/.*(//g" | sed "s/).*//g")
export VERSION=$(curl https://linux-libre.fsfla.org/pub/linux-libre/releases/ | sed "s/.*href=\"//g;s/-gnu.*//g" | grep -e "^[0-9]" | sort -V | tail -n 1)

# Stage 2: Build & Install source code (Like archlinux)
pkgdir=../debian/linux-libre
mkdir -p "$pkgdir"
wget https://gitlab.com/sulinos/devel/sulin-sources/-/raw/master/mklinux -O mklinux
chmod +x mklinux
bash mklinux "$pkgdir"
mv debian/linux-libre/boot/linux-${VERSION} debian/linux-libre/boot/vmlinuz-${VERSION}
