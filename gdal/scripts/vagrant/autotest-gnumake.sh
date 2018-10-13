#!/bin/bash

# abort install if any errors occur and enable tracing
set -o errexit
set -o xtrace

NUMTHREADS=2
if [[ -f /sys/devices/system/cpu/online ]]; then
	# Calculates 1.5 times physical threads
	NUMTHREADS=$(( ( $(cut -f 2 -d '-' /sys/devices/system/cpu/online) + 1 ) * 15 / 10  ))
fi
#NUMTHREADS=1 # disable MP
export NUMTHREADS

rsync -a /vagrant/autotest/ /home/vagrant/autotest
echo rsync -a /vagrant/autotest/ /home/vagrant/autotest > /home/vagrant/autotest/resync.sh
chmod +x /home/vagrant/autotest/resync.sh

cd /home/vagrant/autotest
make clean >/dev/null
make -j $NUMTHREADS test
make test
cd ..
