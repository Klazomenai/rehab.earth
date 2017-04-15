FROM ethereum/client-go:alpine

# Source: http://ethdocs.org/en/latest/network/test-networks.html#the-genesis-file
ADD CustomGenesis.json /root/

RUN /geth --datadir ~/.ethereum/net99 init ~/CustomGenesis.json
