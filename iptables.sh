#!/bin/bash
iptables-restore < /work/iptables_conf
service ntp restart
