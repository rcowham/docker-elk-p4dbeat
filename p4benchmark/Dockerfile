# --------------------------------------------------------------------------------
# Docker configuration for P4D
# --------------------------------------------------------------------------------

FROM python:3.6.7-slim-jessie

MAINTAINER Robert Cowham (rcowham@perforce.com)

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y curl wget

# Create perforce user with UID to 1000 before p4d installation
RUN useradd --home-dir /p4 --create-home --uid 1000 perforce
RUN echo perforce:perforce | /usr/sbin/chpasswd
RUN cd /usr/local/bin && wget http://ftp.perforce.com/perforce/r18.1/bin.linux26x86_64/p4 && \
    chmod +x /usr/local/bin/p4

# Add external files
USER perforce
ADD files/config_p4_basic.yml /p4/
ADD files/createfiles.py /p4/
ADD files/p4_basic.py /p4/
ADD files/p4benchutils.py /p4/
ADD files/requirements.txt /p4/
ADD files/run_master.sh /p4/
ADD files/add_files.sh /p4/


USER root
RUN pip3 install -r /p4/requirements.txt

ENTRYPOINT \
  /p4/add_files.sh && \
  cd /p4 && locust -f p4_basic.py && \
	bash
