FROM ubuntu:18.04 as builder

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN set -ex \ 
     && apt update \
     && apt install -y --no-install-recommends --no-install-suggests \
     build-essential \
     cmake \
     git \
     ssh-client \
     curl \
     ca-certificates \
     libglu1-mesa-dev freeglut3-dev mesa-common-dev \
     libhdf5-dev \
     libhdf5-mpi-dev \
     ninja-build \
     && rm -rf /var/lib/apt/lists/*

# Copy SSH key for git private repos
# Need to have a private key wih no passphrase
ADD .ssh/id_rsa /root/.ssh/id_rsa
ADD .ssh/id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 600 /root/.ssh/id_rsa*
RUN ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts

## Anima
WORKDIR /music
RUN set -ex \
     && git clone --depth 1 -b music-v3.1 git@github.com:Inria-Visages/Anima-Public.git \
     && cd Anima-Public && mkdir build && cd build && cmake \
     -G Ninja \
     -DUSE_ANIMA_PRIVATE=ON \
     .. && ninja -j $(nproc) 

#RUN cd Anima-Public/build/Boost && ninja -j $(nproc) install
RUN cd Anima-Public/build/NLOPT && ninja -j $(nproc) install 
RUN cd Anima-Public/build/VTK && ninja -j $(nproc) install 
RUN cd Anima-Public/build/ITK && ninja -j $(nproc) install 
RUN cd Anima-Public/build/RPI && ninja -j $(nproc) install 
#RUN cd Anima-Public/build/TCLAP && ninja -j $(nproc) install 
RUN cd Anima-Public/build/TinyXML2 && ninja -j $(nproc) install 


#FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04
FROM tensorflow/tensorflow:latest-gpu

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN set -ex \ 
     && apt update \
     && apt install -y --no-install-recommends --no-install-suggests \
     git \
     ssh-client \
     ca-certificates \
     unzip \
     python3 python3-distutils \
     curl \
     && rm -rf /var/lib/apt/lists/*

# Install git lfs
RUN set -ex \
	&& curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh -o script-deb.sh \
	&& bash script-deb.sh \
	&& apt install git-lfs \
	&& git lfs install

# Copy SSH key for git private repos
# Need to have a private key wih no passphrase
ADD .ssh/id_rsa /root/.ssh/id_rsa
ADD .ssh/id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 600 /root/.ssh/id_rsa*
RUN ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts

WORKDIR /music

## Copy build artifacts in current image
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/bin /usr/local/bin

RUN mkdir anima
COPY --from=builder /music/Anima-Public/build/bin /music/anima
COPY --from=builder /music/Anima-Public/build/lib /usr/local/lib
RUN ldconfig

## Retrieve Anima-Scripts-Public
RUN set -ex \
     && git clone --depth 1 -b music-v3.1 git@github.com:Inria-Visages/Anima-Scripts-Public.git

## Retrieve Anima-Scripts
RUN set -ex \
     && git clone --depth 1 -b music-v3.1 git@github.com:Inria-Visages/Anima-Scripts.git

## Retrieve Anima-Scripts-Data-Public
RUN set -ex \
     && git clone --recursive -b music-v3.1 git@github.com:Inria-Visages/Anima-Scripts-Data-Public.git

COPY config.txt /root/.anima/

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py
RUN pip3 install theano nibabel keras tensorflow-gpu

RUN rm -rf /root/.ssh/
