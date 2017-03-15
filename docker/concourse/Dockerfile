# Generic image with kernel updated due to:
# https://github.com/opencontainers/runc/issues/924#issuecomment-229207866
FROM concourse/concourse

MAINTAINER Klazomenai <klazomenai@rehab.earth>

LABEL com.docker.compose.project=concourse

RUN apt-get update
RUN apt-get install -y --install-recommends linux-generic-lts-wily

# Because everything needs to know about secrets. Need to sort out latest!
ADD http://releases.hashicorp.com/vault/0.6.5/vault_0.6.5_linux_amd64.zip /tmp/
RUN apt-get install -y unzip
RUN unzip /tmp/vault_0.6.5_linux_amd64.zip -d /usr/local/bin/
RUN chmod u+x /usr/local/bin/vault

CMD ["/sbin/init"]
