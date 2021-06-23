#!/usr/bin/env bash
set -e
set -o pipefail

if [[ -z "${VERSION}" ]]; then
  echo "No VERSION variable"
  exit 1
fi

if [[ -z "${AUR_VERSION}" ]]; then
  echo "No AUR_VERSION variable"
  exit 1
fi

pacman -Sy

echo "nobody ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

mkdir ~/.ssh
cp /keys/aur ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
eval $(ssh-agent)
ssh-keyscan -t rsa aur.archlinux.org >> ~/.ssh/known_hosts
ssh-add ~/.ssh/id_rsa

mkdir /aur
chmod 777 /aur

git clone ssh://aur@aur.archlinux.org/screenshotgun-git.git /aur
cd /aur
git config user.email "zzismd@gmail.com"
git config user.name "Vladimir Kosteley"

cp /deploy/aur/PKGBUILD /aur/PKGBUILD
sed -i -e "s/{AUR_VERSION}/$AUR_VERSION/g" /aur/PKGBUILD
sed -i -e "s/{VERSION}/$VERSION/g" /aur/PKGBUILD

rm /aur/.SRCINFO
sudo -u nobody sh -c "makepkg --printsrcinfo > /aur/.SRCINFO"

# Check build
cp -r /aur /build
chmod 777 /build
cd /build
sudo -u nobody makepkg -s --needed --noconfirm

cd /aur
git add .
git commit -m "Version: $VERSION"
git push
