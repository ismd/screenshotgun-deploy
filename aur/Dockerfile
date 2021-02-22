FROM archlinux:base

WORKDIR /deploy

COPY aur/ /deploy/aur/

RUN pacman -Syyu --noconfirm
RUN pacman -S --needed --noconfirm base-devel git openssh

CMD ["/deploy/aur/deploy.sh"]
