FROM ubuntu:20.04 AS ubuntu
COPY entrypoint.sh /
WORKDIR /etc/ansible
RUN /entrypoint.sh

FROM debian:10 AS debian
COPY entrypoint.sh /
WORKDIR /etc/ansible
RUN /entrypoint.sh

FROM centos:8 AS centos
COPY entrypoint.sh /entrypoint.sh
WORKDIR /etc/ansible
RUN /entrypoint.sh
