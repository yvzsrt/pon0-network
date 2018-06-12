FROM ubuntu:16.04

ADD ./place_conf.sh /place_conf.sh
RUN chmod +x /place_conf.sh

ENV PATH=$PATH:/opt/cni/bin
VOLUME /opt/cni
WORKDIR /opt/cni/bin