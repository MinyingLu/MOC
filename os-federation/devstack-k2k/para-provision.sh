#!/bin/sh

# concurrency is hard, let's have a beer

# This script is based onthe `para-vagrant.sh` script by Joe Miller, available at https://github.com/joemiller/sensu-tests/blob/master/para-vagrant.sh.
# see NOTICE file

# any valid parallel argument will work here, such as -P x.
MAX_PROCS="-j 10"

# Read parameter from vagrantconfig.yaml file
NUM_INSTANCE=$(grep num_instance vagrantconfig.yaml | awk -F: '/:/{gsub(/ /, "", $2); print $2}')
SMOKE_TEST_COMPONENTS=$(grep smoke_test_components vagrantconfig.yaml | awk -F[ '/,/{gsub(/ /, "", $2); print $2}' | awk -F] '{print $1}')
RUN_SMOKE_TESTS=$(grep run_smoke_tests vagrantconfig.yaml | awk -F: '/:/{gsub(/ /, "", $2); print $2}')

parallel_provision() {
    while read box; do
        echo $box
     done | parallel $MAX_PROCS -I"NODE" -q \
        sh -c 'LOGFILE="logs/NODE.out.txt" ;                                 \
                printf  "[NODE] Provisioning. Log: $LOGFILE, Result: " ;     \
                vagrant provision NODE > $LOGFILE 2>&1 ;                      \
                echo "vagrant provision NODE > $LOGFILE 2>&1" ;               \
                RETVAL=$? ;                                                 \
                if [ $RETVAL -gt 0 ]; then                                  \
                    echo " FAILURE";                                        \
                    tail -12 $LOGFILE | sed -e "s/^/[NODE]  /g";             \
                    echo "[NODE] ---------------------------------------------------------------------------";   \
                    echo "FAILURE ec=$RETVAL" >>$LOGFILE;                   \
                else                                                        \
                    echo " SUCCESS";                                        \
                    tail -5 $LOGFILE | sed -e "s/^/[NODE]  /g";              \
                    echo "[NODE] ---------------------------------------------------------------------------";   \
                    echo "SUCCESS" >>$LOGFILE;                              \
                fi;                                                         \
                exit $RETVAL'

    failures=$(egrep  '^FAILURE' logs/*.out.txt | sed -e 's/^logs\///' -e 's/\.out\.txt:.*//' -e 's/^/  /')
    successes=$(egrep '^SUCCESS' logs/*.out.txt | sed -e 's/^logs\///' -e 's/\.out\.txt:.*//' -e 's/^/  /')

    echo
    echo "Failures:"
    echo '------------------'
    echo "$failures"
    echo
    echo "Successes:"
    echo '------------------'
    echo "$successes"
}

## -- main -- ##

# cleanup old logs
mkdir logs >/dev/null 2>&1
rm -f logs/*

# spin up vms sequentially, because openstack provider doesn't support --parallel 
# This step will update `/etc/hosts` file in vms, because since version 1.5 vagrant up runs hostmanager before provision 
echo ' ==> Calling "vagrant up" to boot the vms...'
vagrant up --no-provision

# but run provision tasks in parallel
echo " ==> Beginning parallel 'vagrant provision' processes ..."
cat <<EOF | parallel_provision   
k2k-tuesday1
k2k-tuesday2
EOF

rm -f logs/*.tmp 
