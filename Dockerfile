FROM ubuntu:14.04

##################################
# install tools and dependencies #
##################################
ENV HOME=/root
RUN apt-get update -qq
RUN apt-get install -y -qq build-essential software-properties-common vim telnet wget git curl expect expect-dev axel

################
# install solc #
################
RUN apt-get -y install build-essential git cmake libgmp-dev libboost-all-dev \
    libjsoncpp-dev
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN add-apt-repository -y ppa:ethereum/ethereum-dev
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install libcryptopp-dev libjsoncpp-dev
RUN git clone --recursive https://github.com/ethereum/solidity.git
RUN cd solidity && mkdir build && cd build && cmake .. && make && make install
RUN echo 'export LD_LIBRARY_PATH=/usr/local/lib' >> /etc/profile.d/solc.sh

##################
# install parity #
##################
ENV PARITY_DEB_URL=https://vanity-service.ethcore.io/github-data/latest-parity-deb
ENV file=/tmp/parity.deb
RUN curl -Lk $PARITY_DEB_URL > $file
RUN sudo dpkg -i $file
RUN rm $file

####################
# configure parity #
####################
RUN mkdir /etc/goreman
COPY Procfile /etc/goreman
COPY configure-parity.sh $HOME/configure-parity.sh
RUN chmod +x $HOME/configure-parity.sh
RUN $HOME/configure-parity.sh

##################
# install golang #
##################

RUN axel https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz && \
       	tar xzvf go1.6.2.linux-amd64.tar.gz && \
       	mv go /usr/local 

RUN echo 'export PATH=/opt/go/bin:/usr/local/go/bin:$PATH' >> /etc/profile.d/go.sh && \
       	mkdir /opt/go && echo 'export GOPATH=/opt/go' >> /etc/profile.d/go.sh

ENV PATH=/opt/go/bin:/usr/local/go/bin:$PATH
ENV GOPATH=/opt/go
ENV LD_LIBRARY_PATH=/usr/local/lib

#################
# install caddy #
#################

RUN mkdir /var/www && mkdir /etc/caddy
RUN curl https://getcaddy.com | bash
COPY caddyfile /etc/caddy

################
# install etcd #
################

RUN curl -L https://github.com/coreos/etcd/releases/download/v3.0.6/etcd-v3.0.6-linux-amd64.tar.gz -o etcd-v3.0.6-linux-amd64.tar.gz && \
tar xzvf etcd-v3.0.6-linux-amd64.tar.gz && cd etcd-v3.0.6-linux-amd64 && \
mv ./etc* /usr/local/bin && mkdir /root/.etcd
RUN go get github.com/mattn/goreman

##########
# volume #
##########
# you can find the volume by using `docker inspect command`
VOLUME /root

# you need to specify -p 8545:8545 -p 30303:30303  in `docker run` to expose it to 0.0.0.0
EXPOSE 8545
EXPOSE 30303
# port for web server for static files with node id
EXPOSE 8001
# parity dapps ui 
EXPOSE 8002

COPY run.goreman /usr/local/bin
CMD ["run.goreman"]