FROM microsoft/azure-cli
MAINTAINER steve@bargelt.com

RUN apt-get update && apt-get install -y --no-install-recommends \
		cronie \
	&& rm -rf /var/lib/apt/lists/*

ADD backup.sh /backup.sh
#ADD restore.sh /restore.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

CMD ["/run.sh"]