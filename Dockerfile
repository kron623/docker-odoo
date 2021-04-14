FROM centos:7
MAINTAINER Patricio Felipe Caceres <desarrollos@nuruve.cl>

ENV LANG en_US.UTF-8

RUN yum update -y 

ADD https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox-0.12.5-1.centos7.x86_64.rpm /root
RUN yum -y install epel-release wget git \
        postgresql\
	unzip \
	openldap-devel \
	libxml2-devel \
	libxslt-devel \
	git \
	gcc \
	kernel-headers \
	yum-utils \
	mlocate \
	vim \
	xmlsec1-devel \
	xmlsec1 \
	openssl-devel \
	python-cups \
	xmlsec1-openssl \
	poppler-cpp-devel \
	poppler-utils \
	xmlsec1-openssl-devel \
	libtool-ltdl-devel \
	libjpeg-devel \
	bzip2-devel \
	libffi-devel \
	python3 \
	python3-devel \
	python3-pip \
	npm \
	nodejs-less \
	libxml++-devel \
	htop \
	xorg-x11-server-Xvfb \
	python-xvfbwrapper && \
	yum -y groupinstall development && \
	yum localinstall /root/wkhtmltox-0.12.5-1.centos7.x86_64.rpm -y && \
	yum clean all && \
    rm -rf /var/cache/yum /root/*

RUN useradd -ms /bin/bash odoo

RUN /usr/bin/python3.6 -m pip install --no-cache-dir pip --upgrade
RUN /usr/bin/python3.6 -m pip install --no-cache-dir psycogreen gdata 

# RUN npm install -g less less-plugin-clean-css

RUN echo "Se instalan dependencias para modulos DTE"
RUN /usr/bin/python3.6 -m pip install --no-cache-dir rsa cython future elaphe raven xmltodict dicttoxml pdf417gen cchardet py-wsse suds-py3 urllib3
RUN /usr/bin/python3.6 -m pip install --no-cache-dir signxml pysftp num2words xlsxwriter Boto FileChunkIO rotate-backups oauthlib phonenumbers geojson shapely
RUN /usr/bin/python3.6 -m pip install --no-cache-dir suds requests_oauthlib oauthlib boto3 business_calendar email-validator phonenumbers 
RUN /usr/bin/python3.6 -m pip install --no-cache-dir requests --upgrade

#ADD https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox-0.12.5-1.centos7.x86_64.rpm /root
#RUN yum localinstall /root/wkhtmltox-0.12.5-1.centos7.x86_64.rpm -y

ADD config-files/requirements.txt /

RUN sed -i "/lxml==3.7.1 ; sys_platform != 'win32' and python_version < '3.7'/d" /requirements.txt
RUN sed -i "/lxml==4.2.3 ; sys_platform != 'win32' and python_version >= '3.7'/d" /requirements.txt
RUN sed -i "s/lxml ; sys_platform == 'win32'/lxml/" /requirements.txt
RUN sed -i "s/psycopg2==2.7.3.1; sys_platform != 'win32'/psycopg2-binary; sys_platform != 'win32'/" /requirements.txt
RUN sed -i "s/requests==2.20.0/requests/" /requirements.txt

#echo "Se instalan dependencias de odoo"
RUN /usr/bin/python3.6 -m pip install --no-cache-dir -r /requirements.txt

RUN /usr/bin/python3.6 -m pip install --no-cache-dir signxml --upgrade


RUN /usr/bin/python3.6 -m pip install --no-cache-dir simplejson numpy xmltodict dicttoxml cchardet pdf417gen transbank-sdk inotify xlrd==1.2.0


EXPOSE 8069 8072
USER odoo







