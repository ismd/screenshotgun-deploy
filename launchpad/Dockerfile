FROM debian:stable

WORKDIR /deploy

COPY launchpad/ /deploy/launchpad/

RUN apt-get update
RUN apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y bzr-builddeb dh-make dput pbuilder ubuntu-dev-tools cmake qtbase5-dev qtbase5-private-dev

CMD ["/deploy/launchpad/deploy.sh"]
