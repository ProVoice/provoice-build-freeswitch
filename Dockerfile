# ProVoice packages build environment for FreeSWITCH using Docker
# MediaServe International B.V.
# https://github.com/ProVoice

FROM ubuntu:focal

SHELL ["/bin/bash", "-c"]
WORKDIR /app

ENV DEBIAN_FRONTEND noninteractive

RUN apt update
RUN apt install -y -f curl nodejs npm nano iputils-ping expect telnet grep sed devscripts debhelper build-essential equivs rsync figlet
RUN curl -LO https://dev.mysql.com/get/mysql-apt-config_0.8.16-1_all.deb
RUN apt install -y -f ./mysql-apt-config_0.8.16-1_all.deb
RUN apt update
RUN apt install -y -f mysql-client
RUN rm /var/lib/apt/lists/* /app/mysql-apt-config_0.8.16-1_all.deb -fr
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

COPY ./ ./

CMD ["/app/build-packages"]
