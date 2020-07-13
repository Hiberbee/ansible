FROM ubuntu:20.04 AS ubuntu
COPY provision.sh /usr/local/bin/provision
WORKDIR /etc/ansible
RUN /usr/local/bin/provision \
 && ansible-playbook playbook.yml

FROM debian:bullseye AS debian
COPY provision.sh /usr/local/bin/provision
WORKDIR /etc/ansible
RUN /usr/local/bin/provision \
 && ansible-playbook playbook.yml
