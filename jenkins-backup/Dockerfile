FROM microsoft/azure-cli
MAINTAINER steve@bargelt.com

ADD backup.sh /backup.sh
#ADD restore.sh /restore.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

CMD ["/run.sh"]