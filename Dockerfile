FROM ubuntu:20.04
COPY provision.sh /usr/local/bin/provision
WORKDIR /etc/ansible
RUN /usr/local/bin/provision \
 && ansible-playbook playbook.yml
