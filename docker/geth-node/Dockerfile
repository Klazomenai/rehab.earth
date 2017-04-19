FROM ethereum/client-go:alpine

# Source: http://ethdocs.org/en/latest/network/test-networks.html#the-genesis-file
ADD CustomGenesis.json /root/

RUN /geth --datadir ~/.ethereum/net99 init ~/CustomGenesis.json

ADD ./keystore/* /root/.ethereum/net99/keystore/

# Install solc as per the solc container:
# https://hub.docker.com/r/ethereum/solc/~/dockerfile/
# This is only to make initial playing easier, and need to be removed once
# it becomes part of the pipeline
RUN \
  apk --no-cache --update add build-base cmake boost-dev git                                                && \
  sed -i -E -e 's/include <sys\/poll.h>/include <poll.h>/' /usr/include/boost/asio/detail/socket_types.hpp  && \
  git clone --depth 1 --recursive -b release https://github.com/ethereum/solidity                           && \
  cd /solidity && cmake -DCMAKE_BUILD_TYPE=Release -DTESTS=0 -DSTATIC_LINKING=1                             && \
  cd /solidity && make solc && install -s  solc/solc /usr/bin                                               && \
  cd / && rm -rf solidity                                                                                   && \
  apk del sed build-base git make cmake gcc g++ musl-dev curl-dev boost-dev                                 && \
  rm -rf /var/cache/apk/*
