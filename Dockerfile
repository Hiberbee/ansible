FROM ubuntu:20.04
RUN apt-get update --yes \
 && apt-get full-upgrade --yes \
 && apt-get install --yes \
      python3-pip \
 && pip3 install --upgrade --prefer-binary ansible
WORKDIR /etc/ansible
COPY . .
RUN ansible-playbook playbook.yml \
 && apt-get purge python3-wheel python3-setuptools --yes \
 && apt-get autoremove --yes \
 && apt-get autoclean --yes \
 && apt-get clean \
 && py3clean /usr \
 && rm -rf ~/.cache/pip/* /var/cache/apt/*
ENTRYPOINT ["fish", "-C"]
