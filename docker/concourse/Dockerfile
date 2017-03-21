# Generic image with kernel updated due to:
# https://github.com/opencontainers/runc/issues/924#issuecomment-229207866
FROM concourse/concourse

MAINTAINER Klazomenai <klazomenai@rehab.earth>

LABEL com.docker.compose.project=concourse

#
# Pre-requisites
#
RUN apt-get update
RUN apt-get install -y unzip supervisor git

#
# Prepping project cone init script. This should be done by Chef.
#
ADD scripts/init.sh /usr/local/bin

#
# Kernel updates required for Concourse
#
RUN apt-get update
RUN apt-get install -y --install-recommends linux-generic-lts-wily

#
# Consul required to make Concourse aware of its surrounding
# Need to sort out latest!
#
RUN mkdir -p /etc/consul.d/client/
ADD https://releases.hashicorp.com/consul/0.7.5/consul_0.7.5_linux_amd64.zip /tmp/
RUN unzip /tmp/consul_0.7.5_linux_amd64.zip -d /usr/local/bin/
RUN chmod u+x /usr/local/bin/consul

#
# Vauls, because ecause everything needs to know about secrets.
# Need to sort out latest!
#
ADD http://releases.hashicorp.com/vault/0.6.5/vault_0.6.5_linux_amd64.zip /tmp/
RUN unzip /tmp/vault_0.6.5_linux_amd64.zip -d /usr/local/bin/
RUN chmod u+x /usr/local/bin/vault

CMD ["/sbin/init"]
