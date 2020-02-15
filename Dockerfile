# Copyright 2017 ~ 2025 the original author or authors. <wanglsir@gmail.com, 983708408@qq.com>
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#   Dockerfile Usage:
#
#   git clone https://github.com/wl4g/docker-redis-cluster.git
#   #git clone https://gitee.com/wl4g/docker-redis-cluster.git
#   cd docker-redis-cluster
#   docker build -t wl4g/redis-cluster:latest .
#
#   Container Usage:
#   @see:   https://github.com/wl4g/docker-redis-cluster/blob/master/README.md
#   @see:   https://gitee.com/wl4g/docker-redis-cluster/blob/master/README.md
#

# Build from commits based on redis:5
FROM ubuntu:latest

# General descriptive information
LABEL maintainer="Wanglsir <Wanglsir@gmail.com>"

# Environment Variables
ENV DEBIAN_FRONTEND noninteractive
ENV LANGUAGE "zh_CN.UTF-8"
ENV LANG "zh_CN.UTF-8"
ENV LC_ALL "zh_CN.UTF-8"
ENV REDIS_HOME "/usr/local/redis"
ENV REDIS_VERSION "5.0.7"
ENV REDIS_DATA "/mnt/disk1/redis"
ENV REDIS_LOG "/mnt/disk1/log/redis"

# Standard OS configuration
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone
RUN mkdir -p /etc/apt/
COPY sources.list /etc/apt/

# Install OS dependencies
RUN apt-get update  && apt-get install -y \
  net-tools locales wget gcc make g++

# Software application compilation and installation
#RUN wget -qO redis.tar.gz https://github.com/antirez/redis/archive/${REDIS_VERSION}.tar.gz
COPY redis.tar.gz /redis.tar.gz
RUN cd / \
  && tar -xf redis.tar.gz \
  && mv /redis-${REDIS_VERSION} /redis-src \
  && rm -rf /redis.tar.gz

RUN mkdir -p ${REDIS_HOME}/bin
RUN mkdir -p ${REDIS_HOME}/conf
RUN mkdir -p ${REDIS_HOME}/nodes
RUN mkdir -p ${REDIS_HOME}/run
RUN mkdir -p ${REDIS_DATA}
RUN mkdir -p ${REDIS_LOG}
RUN (cd /redis-src && make)
RUN cp /redis-src/src/redis-cli ${REDIS_HOME}/bin \
  && cp /redis-src/src/redis-server ${REDIS_HOME}/bin \
  && cp /redis-src/src/redis-benchmark ${REDIS_HOME}/bin \
  && cp /redis-src/src/redis-check-aof ${REDIS_HOME}/bin \
  && cp /redis-src/src/redis-check-rdb ${REDIS_HOME}/bin \
  && cp /redis-src/src/redis-sentinel ${REDIS_HOME}/bin
RUN rm -rf /redis-src

COPY redis.conf.tpl /redis.conf.tpl
COPY wrapper.sh /wrapper.sh
COPY redis-ctl /bin/redis-ctl
RUN chmod 755 /wrapper.sh
RUN chmod 755 /bin/redis-ctl

EXPOSE 6379/tcp
EXPOSE 6380/tcp
EXPOSE 6381/tcp
EXPOSE 7379/tcp
EXPOSE 7380/tcp
EXPOSE 7381/tcp
EXPOSE 16379/tcp
EXPOSE 16380/tcp
EXPOSE 16381/tcp
EXPOSE 17379/tcp
EXPOSE 17380/tcp
EXPOSE 17381/tcp

ENTRYPOINT ["/wrapper.sh"]
