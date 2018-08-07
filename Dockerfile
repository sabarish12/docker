OM ubuntu:18.04

MAINTAINER Chaos Sumo, Inc. "http://www.chaossumo.com"

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

RUN apt-get update && apt-get install -y apt-transport-https locales

# Set the timezone.
ENV TZ=America/New_York
RUN apt-get install -y tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update

# make sure the package repository is up to date and update ubuntu
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  locale-gen en_US.UTF-8

# Build dependencies
RUN apt-get install -y python software-properties-common

# Gradle
RUN apt-get install -y git
RUN apt-get install -y gradle

# Python Selenium
RUN dpkg-reconfigure tzdata
RUN apt-get install -y python-setuptools python-dev python-pip
RUN apt-get install -y python-xvfbwrapper
RUN apt-get install -y chromium-chromedriver
RUN apt-get install -y firefoxdriver
RUN apt-get install -y openjdk-11-jdk
RUN pip install -U pip

RUN pip install -U selenium
RUN apt-get -y install wget
RUn bash -c "cd /usr/local/bin && wget https://github.com/mozilla/geckodriver/releases/download/v0.19.1/geckodriver-v0.19.1-linux64.tar.gz -O - | tar -xz"

ENV PATH $PATH:/usr/lib/chromium-browser/

COPY gradle.properties /root/.gradle/gradle.properties

COPY test.py /root/test.py
RUN chmod u+x /root/test.py

