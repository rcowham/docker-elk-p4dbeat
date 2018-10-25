# --------------------------------------------------------------------------------
# Docker configuration for P4D
# --------------------------------------------------------------------------------

FROM ubuntu:14.04

MAINTAINER Robert Cowham (rcowham@perforce.com)

# Update Ubuntu
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y dnsutils curl git man unzip vim wget

# Add Perforce Package Source
RUN \
  wget -qO - https://package.perforce.com/perforce.pubkey | sudo apt-key add - && \
  echo "deb http://package.perforce.com/apt/ubuntu trusty release" > /etc/apt/sources.list.d/perforce.list && \
  apt-get update

# Create perforce user with UID to 1000 before p4d installation
RUN useradd --home-dir /p4 --create-home --uid 1000 perforce
RUN echo perforce:perforce | /usr/sbin/chpasswd

# Install p4dbeat

# Add external files
# USER perforce
ADD files/p4dbeat.yml /p4/
ADD files/p4dbeat /p4/
ADD files/go-tail.linux /p4/

ENTRYPOINT \
	/p4/p4dbeat -c /p4/p4dbeat.yml -e -d "*" && \
  bash

	# /p4/go-tail.linux -f /p4/logs/p4d.log && \
