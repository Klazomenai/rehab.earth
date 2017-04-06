FROM ruby:2.2.6

MAINTAINER Klazomenai <klazomenai@rehab.earth>

LABEL com.docker.compose.project=ruby

ADD vault /usr/local/bin/
RUN chmod u+x /usr/local/bin/vault

ADD terraform /usr/local/bin/
RUN chmod u+x /usr/local/bin/terraform
