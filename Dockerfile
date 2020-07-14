ARG distro=ubuntu:20.04
FROM $distro
COPY entrypoint.sh /
WORKDIR /etc/ansible
RUN /entrypoint.sh
