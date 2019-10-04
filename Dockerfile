FROM centos:latest
MAINTAINER Patricio Felipe Caceres <desarrollos@nuruve.cl>


RUN yum -y update

RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm

RUN yum -y groupinstall development

RUN yum -y install epel-release wget git unzip openldap-devel libxml2-devel libxslt-devel git gcc kernel-headers yum-utils mlocate vim xmlsec1-devel\
		xmlsec1 openssl-devel python-cups xmlsec1-openssl poppler-cpp-devel poppler-utils xmlsec1-openssl-devel libtool-ltdl-devel libjpeg-devel bzip2-devel\
		libffi-devel python36u python36u-devel python36u-pip npm libxml++-devel nodejs-less htop xorg-x11-server-Xvfb python-xvfbwrapper

RUN useradd -ms /bin/bash odoo

RUN /usr/bin/python3.6 -m pip install pip --upgrade
RUN /usr/bin/python3.6 -m pip install psycogreen gdata 
#problemas con gevent_psycopg2

RUN npm install -g less less-plugin-clean-css

RUN echo "Se instalan dependencias para modulos DTE"
RUN /usr/bin/python3.6 -m pip install rsa cython future elaphe raven xmltodict dicttoxml pdf417gen cchardet py-wsse client suds-py3 urllib3
RUN /usr/bin/python3.6 -m pip install signxml pysftp num2words xlsxwriter Boto FileChunkIO rotate-backups oauthlib phonenumbers geojson shapely
RUN /usr/bin/python3.6 -m pip install suds requests_oauthlib oauthlib boto3
RUN /usr/bin/python3.6 -m pip install requests --upgrade

ADD https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox-0.12.5-1.centos7.x86_64.rpm /root
RUN yum localinstall /root/wkhtmltox-0.12.5-1.centos7.x86_64.rpm -y

ADD config-files/requirements.txt /

RUN sed -i "/lxml==3.7.1 ; sys_platform != 'win32' and python_version < '3.7'/d" /requirements.txt
RUN sed -i "/lxml==4.2.3 ; sys_platform != 'win32' and python_version >= '3.7'/d" /requirements.txt
RUN sed -i "s/lxml ; sys_platform == 'win32'/lxml/" /requirements.txt
RUN sed -i "s/psycopg2==2.7.3.1; sys_platform != 'win32'/psycopg2-binary; sys_platform != 'win32'/" /requirements.txt
RUN sed -i "s/requests==2.20.0/requests/" /requirements.txt

#echo "Se instalan dependencias de odoo"
RUN /usr/bin/python3.6 -m pip install -r /requirements.txt

RUN /usr/bin/python3.6 -m pip install signxml --upgrade


RUN /usr/bin/python3.6 -m pip install simplejson numpy xmltodict dicttoxml cchardet pdf417gen 

EXPOSE 8069 8072
USER odoo







