FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y \
      wget \
      lsb-release \
      gnupg \
      netcat \
      procps

ENV DEBIAN_FRONTEND=noninteractive

RUN wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb && \
    dpkg -i mysql-apt-config_0.8.22-1_all.deb && \
    apt-get update && \
    apt-get install -y -qq \
      mysql-server && \
    rm mysql-apt-config_0.8.22-1_all.deb

COPY entrypoint.sh /

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
