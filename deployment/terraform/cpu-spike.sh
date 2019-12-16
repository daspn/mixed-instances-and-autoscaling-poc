#!/bin/bash
cd /tmp
wget ftp://fr2.rpmfind.net/linux/dag/redhat/el7/en/x86_64/dag/RPMS/stress-1.0.2-1.el7.rf.x86_64.rpm
yum -y localinstall stress-1.0.2-1.el7.rf.x86_64.rpm

cpuCount=$(nproc --all)
for i in $(seq 1 12)
do
    stress --cpu $cpuCount --timeout 45
    sleep 15s
done
