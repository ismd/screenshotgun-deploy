#!/bin/bash
set -e
set -o pipefail

if [[ -z "${VERSION}" ]]; then
  echo "No VERSION variable"
  exit 1
fi

useradd ismd
bzr whoami "Vladimir Kosteley <zzismd@gmail.com>"

wget -q -O screenshotgun.tar.gz https://github.com/ismd/screenshotgun/archive/v${VERSION}.tar.gz
tar xzf screenshotgun.tar.gz

eval $(ssh-agent -s)
ssh-add /keys/launchpad

gpg --import /keys/launchpad.asc
gpg --import /keys/launchpad_public.asc

mkdir -p /launchpad
cd /launchpad

bzr dh-make --bzr-only screenshotgun $VERSION /deploy/screenshotgun-$VERSION

cd /launchpad/screenshotgun
chmod -R 777 /launchpad
sudo -u ismd dh_make -y -s -p screenshotgun_$VERSION
rm -rf debian
cp -r /deploy/launchpad/debian debian
sed -i -e "s/{version}/$VERSION/g" debian/changelog
sed -i -e "s/{date}/`date +'%a, %d %b %Y %H:%M:%S +0300'`/g" debian/changelog
sed -i -e "s/{distribution}/focal/g" debian/changelog

bzr add debian
bzr builddeb -S

cd /launchpad/build-area
pbuilder-dist bionic create
pbuilder-dist bionic build screenshotgun_$VERSION-1.dsc

mkdir ~/.ssh
ssh-keyscan -t rsa ppa.launchpad.net >> ~/.ssh/known_hosts
USER=ismd dput -c /deploy/launchpad/dput.cf ppa screenshotgun_$VERSION-1_source.changes
