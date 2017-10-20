FROM registry.centos.org/centos/centos:7

ENV SUMMARY="Base image for elastic 2.4"	\
    DESCRIPTION="This image provide elastic core and some utils \
such as plugin head and es-json-load bulk uploader in nodejs"
LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="elasticsearch 2.4 core" \
      name="elasticsearch-core-2.4-centos" \
      version="1" \
      release="1.0"

ADD elasticsearch-2.4.0.rpm run.sh /

RUN ["/bin/bash", "-c", "yum -y install epel-release"]
RUN ["/bin/bash", "-c", "yum -y install java-1.8.0-openjdk nss_wrapper gettext"]

RUN ["/bin/bash", "-c", "yum -y install /elasticsearch-2.4.0.rpm"]

#RUN sleep 10000000000


RUN ["/bin/bash", "-c", "ln -s /etc/elasticsearch/ /usr/share/elasticsearch/config"]
RUN ["/bin/bash", "-c", "ln -s /var/log/elasticsearch/ /usr/share/elasticsearch/logs"]
RUN ["/bin/bash", "-c", "chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/"]

RUN ["/bin/bash", "-c", "mkdir /home/elasticsearch"]
RUN ["/bin/bash", "-c", "chown -R elasticsearch:elasticsearch /home/elasticsearch/"]

RUN ["/bin/bash", "-c", "chown -R elasticsearch:elasticsearch /etc/elasticsearch/"]
RUN ["/bin/bash", "-c", "chmod +x /run.sh"]
RUN ["/bin/bash", "-c", "echo network.host: 0.0.0.0 >>  /usr/share/elasticsearch/config/elasticsearch.yml"]
RUN ["/bin/bash", "-c", "/usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head"]

RUN ["/bin/bash", "-c", "yum install -y nodejs npm net-tools"]
RUN ["/bin/bash", "-c", "npm install es-json-load -g"]
RUN ["/bin/bash", "-c", "chsh -s /bin/bash elasticsearch"]

