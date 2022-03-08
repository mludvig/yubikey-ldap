FROM debian:latest

RUN apt-get update && apt-get upgrade && apt-get install -y python3 python3-pip libldap2-dev libsasl2-dev

WORKDIR /app
COPY requirements.txt /app/
RUN pip3 install -r requirements.txt
COPY yubikey-ldap /app/
COPY yubikey-ldap.conf.sample /app/yubikey-ldap.conf