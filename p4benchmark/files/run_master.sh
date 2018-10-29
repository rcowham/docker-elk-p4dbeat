#!/bin/bash
# Run the locust master on current host, waiting for specified number of 
# slaves to connect.

function bail () { echo -e "\nError: ${1:-Unknown Error}\n"; exit ${2:-1}; }

export P4BENCH_NUM_SLAVES=${P4BENCH_NUM_SLAVES:-Undefined}
export P4BENCH_NUM_SLAVES=${1:-$P4BENCH_NUM_SLAVES}
[[ $P4BENCH_NUM_SLAVES == Undefined ]] && \
   bail "Num_slaves parameter not supplied."

export P4BENCH_SCRIPT=${P4BENCH_SCRIPT:-Undefined}
export P4BENCH_SCRIPT=${2:-$P4BENCH_SCRIPT}
[[ $P4BENCH_SCRIPT == Undefined ]] && \
   bail "Benchmark script parameter not supplied."

total_slaves=$((2 * $P4BENCH_NUM_SLAVES))

pkill -9 locust

nohup locust -f locust_files/p4_$P4BENCH_SCRIPT.py --master --no-web --expect-slaves=$total_slaves -c $total_slaves -r 1 > master.out 2>&1 &
