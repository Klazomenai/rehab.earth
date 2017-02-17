#!/usr/bin/env bash

# Poll DigitalOcean for new droplets and save the new firewall rules
/opt/droplan/droplan

service iptables save
