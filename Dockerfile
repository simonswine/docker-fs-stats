FROM debian:wheezy

RUN apt-get update \
 && apt-get install -y curl bonnie++ \
 && apt-get clean \
 && rm /var/lib/apt/lists/*_*

RUN curl -L https://github.com/vektorlab/slackcat/releases/download/v1.1/slackcat-1.1-linux-amd64 > /usr/local/bin/slackcat \
 && chmod +x /usr/local/bin/slackcat

ADD run.sh /run.sh

CMD ["/bin/bash", "/run.sh"]

VOLUME /mnt/persistent
