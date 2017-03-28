#!/usr/bin/env bash

# If things exist cleanup as contianer has been bounced.
if [ -d /opt/rehab.earth ]; then rm -rf /opt/rehab.earth; fi
if [ -f /etc/rehab.earth.init ]; then rm -f /etc/rehab.earth.init; fi

cd /opt
git clone --depth 1 --branch $PROJECT_BRANCH https://github.com/Klazomenai/rehab.earth.git

cp -f /opt/rehab.earth/etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/
