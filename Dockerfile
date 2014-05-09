FROM ubuntu:precise

ENV PATH /opt/nodejs/bin:$PATH
ENV APP_USER app_runner
ENV HOME /home/${APP_USER}

# use us-east cause CI is in us-east and it's more stable
# well unless you're trying this on local then you're out of luck.
RUN echo deb http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list
RUN echo deb http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list
RUN echo deb http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -yy build-essential libpq-dev curl wget tar autoconf python-setuptools git-core

RUN mkdir -p /opt/nodejs
RUN curl -s http://nodejs.org/dist/v0.8.25/node-v0.8.25-linux-x64.tar.gz | tar -v -C /opt/nodejs --strip-components=1 -xz
RUN curl -sSL https://npmjs.org/install.sh | clean=no sh

ADD github_rsa /root/.ssh/id_rsa
RUN echo "IdentityFile /root/.ssh/id_rsa" >> /etc/ssh/ssh_config
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

RUN useradd -U -m $APP_USER

WORKDIR /home/app_runner

ADD ./ ${HOME}/shover

RUN cd ${HOME}/shover && npm install

# Get rid of color in mocha for CI
RUN echo "--no-colors" >> ${HOME}/shover/test/mocha.opts