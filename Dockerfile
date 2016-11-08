FROM ubuntu:16.04

##################################
# install tools and dependencies #
##################################
ENV HOME=/root
RUN apt-get update -qq
RUN apt-get install -qq -y software-properties-common && add-apt-repository -y ppa:ethereum/ethereum 
RUN apt-get update -qq
RUN apt-get install -qq -y build-essential vim telnet wget git curl expect expect-dev unzip jq

################
# install solc #
################
RUN apt-get -y install solc

##################
# install parity #
##################
RUN wget -O /tmp/parity_1.3.10_amd64.deb http://d1h4xl4cr1h0mo.cloudfront.net/v1.3.10/x86_64-unknown-linux-gnu/parity_1.3.10_amd64.deb
RUN dpkg -i /tmp/parity_1.3.10_amd64.deb

#################
# install caddy #
#################

RUN mkdir /var/www && mkdir /etc/caddy && curl https://getcaddy.com | bash
COPY caddyfile /etc/caddy

###################
# install goreman #
###################
COPY bin/goreman /usr/local/bin/goreman

####################
# configure parity #
####################
RUN mkdir /etc/goreman
COPY Procfile /etc/goreman
COPY configure-parity.sh $HOME/configure-parity.sh
RUN $HOME/configure-parity.sh

#########################################################
# enode.sh  daemon to get enode and serve it from caddy #
#########################################################

COPY enode.sh /usr/local/bin/enode.sh
RUN chmod +x /usr/local/bin/enode.sh

##########
# volume #
##########
# you can find the volume by using `docker inspect command`
VOLUME /root
# Port for RPC. Used for 
EXPOSE 8545
# Port for P2P. Used for networking
EXPOSE 30303
# port for web server for static files with node id
EXPOSE 8001
# port for Parity UI
EXPOSE 8002

COPY run.goreman /usr/local/bin
CMD ["run.goreman"]