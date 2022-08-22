FROM ubuntu:20.04
MAINTAINER "hudengjun@copr.netease.com"
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

#stage0: install compile toolchain
COPY ./sources.list /etc/apt/sources.list
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="Asia/Shanghai" apt-get install -y tzdata  && \ 
    apt-get install -y wget git curl zip unzip tar && \ 
    apt-get install -y build-essential &&  \ 
    apt-get install -y ninja-build valgrind gdb && \ 
    apt-get install -y libipc-run-perl pkg-config && \ 
    apt-get install -y make python3 python3-pip && \
    apt-get install -y autoconf libtool

#stage1: install java maven
RUN wget --no-check-certificate https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz -P /tmp/openjdk 
RUN tar xf /tmp/openjdk/openjdk-11+28_linux-x64_bin.tar.gz -C /opt 

ENV MVN_VERSION=3.8.6
ENV CMAKE_VERSION=3.22.2
ENV https_proxy=http://dl-proxy.service.163.org:8123
RUN wget --no-check-certificate https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz -P /tmp/mvn && \
    tar xf /tmp/mvn/apache-maven-${MVN_VERSION}-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-${MVN_VERSION} /opt/maven && rm -rf /tmp/mvn/* && \ 
    curl -L -o cmake-linux.sh  https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh && \
    sh cmake-linux.sh -- --skip-license --prefix=/usr/local


ENV JAVA_HOME=/opt/jdk-11
ENV PATH="${JAVA_HOME}/bin:/opt/maven/bin:${PATH}"

#stage2 install g++10.2 gdb-10.2 cmake 3.22.2 ninja valgrind-3.16+ systemtap

# stage3: install vcpkg and basic lib
#RUN rm -rf /var/lib/apt
RUN git clone --depth 1  --branch 2022.04.12 https://github.com/microsoft/vcpkg /opt/vcpkg && cd /opt/vcpkg  &&\
    bash ./bootstrap-vcpkg.sh && ./vcpkg update
RUN /opt/vcpkg/vcpkg update
RUN /opt/vcpkg/vcpkg install protobuf abseil openssl "c-ares" re2 && \
    /opt/vcpkg/vcpkg install gtest gflags glog grpc abseil benchmark && \
    /opt/vcpkg/vcpkg install boost-core boost-asio boost-filesystem && \
    /opt/vcpkg/vcpkg install tbb antlr4 cppitertools && \
    /opt/vcpkg/vcpkg install ParallelSTL yaml-cpp xxhash cityhash && \
    /opt/vcpkg/vcpkg install rapidjson jsoncons utfcpp cpp-base64 && \
    /opt/vcpkg/vcpkg install librdkafka nlohmann-json magic-enum rapidxml fmt libuuid

# install python3 for folly 
RUN  /opt/vcpkg/vcpkg install gperftools && \ 
    /opt/vcpkg/vcpkg install continuable libcds roaring folly roaring libuv && \
    /opt/vcpkg/vcpkg install "prometheus-cpp[push]" --recurse hiredis && \
    /opt/vcpkg/vcpkg install boost-stacktrace breakpad && \
    /opt/vcpkg/vcpkg install bshoshany-thread-pool

# stage4: install some user latest libs for dev
RUN apt-get install -y flex bison && \ 
    /opt/vcpkg/vcpkg update && /opt/vcpkg/vcpkg install brpc braft --recurse && \ 
    /opt/vcpkg/vcpkg install spdlog boost-logic boost-outcome && \
    /opt/vcpkg/vcpkg install arrow parquet


#stage5: install project specify lib
#install debug and performance toolchain
RUN git clone  https://github.com/hudengjunai/vcpkg_libs.git /tmp/vcpkg_libs && \ 
    cp -r /tmp/vcpkg_libs/cmake/* /opt/vcpkg/ports && \ 
    /opt/vcpkg/vcpkg install "redis-plus-plus[cxx17]" curlpp poco modern-cpp-kafka datasketches && \ 
    /opt/vcpkg/vcpkg install rtdsync nanobench  boost-bimap fruit


# stage6: install bcc bpf and some user defined libs

RUN apt-get install -y arping iperf netperf && \ 
    apt-get install -y zlib1g-dev libelf-dev libfl-dev libedit-dev  && \ 
    apt-get install -y libllvm13 llvm-13-dev libclang-13-dev  && \ 
    apt-get install -y luajit luajit-5.1-dev && \ 
    apt-get install -y binutils-dev libelf-dev libcap-dev

RUN git clone https://github.com/iovisor/bcc.git /opt/bcc && \ 
    cd /opt/bcc && git checkout v0.24.0 && mkdir -p build &&  \ 
    cd build && cmake .. -DCMAKE_PREFIX_PATH=/usr/lib/llvm-13 && \ 
    make -j20 && make install && cmake -DPYTHON_CMD=python3 .. && \ 
    make -j20 && make install
