#!/bin/bash
# Adds files to depot for benchmarking
# Assumes environment of /p4 and that server is on port p4.helix:1666 
# in a parallel Docker container (part of same docker-compose setup)

function bail () { echo -e "\nError: ${1:-Unknown Error}\n"; exit ${2:-1}; }

ws_root=/p4/test_ws
mkdir $ws_root
cd $ws_root

export P4PORT=p4.helix:1666
export P4USER=bruno
export P4CLIENT=test_ws

p4 --field "View=//depot/... //test_ws/..." client -o | p4 client -i

python3.6 /p4/createfiles.py -d $ws_root -l 5 5 -c

p4 rec 
p4 submit -d "Initial files"
