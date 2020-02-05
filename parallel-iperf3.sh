#!/bin/bash
# Note: Specially designed for FreeBSD. Other OSs will need modifications.
# For FreeBSD install bash from ports - pkg install bash
# Script to paralelize iperf runs. Run from client or server side. Kill live sessions.
# Author: Jordan A Caraballo-Vega, jordancaraballo

### Usage options are listed below
usage="$(basename "$0") [-h] [-o (client|server|kill)] [-p n] [-n n] [-i ip_addr] [-t seconds] - Script for FreeBSD to start basic
paralelized iperf3 functionalities where:
    -h  show usage help
    -o  perform client, server or kill operations - Default client
    -p integer with the starting port e.g. 5100 - Default 5100
    -n integer with the number of ports to use e.g 10 - Default 10
    -i ip address to forward messages too. Only needed on server mode. - Default 172.16.2.2"
    -t time of the iperf3 test

# TODO: add kill all option:
# ps -aux | grep iperf3 | grep -v grep | awk '{print $2}' | xargs -r kill -9


### Parse options from command line
operation="client"
startport=5100
nport=10
ip="172.16.2.2"
time="120"

while getopts o:p:n:i:t:h option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    o) operation=$OPTARG;;
    p) startport=$OPTARG;;
    n) nport=$OPTARG;;
    i) ip=$OPTARG;;
    t) time=$OPTARG;;
  esac
done
shift $((OPTIND - 1))

### Performing operations
if [ $operation == "client" ]; then
    echo "Selected client operation...Starting service now..."
    for port in `seq 1 $nport`
    do
        iperf3 -c $ip -i 0 -N -l 64 -b 10000m -t $time -p $(($startport + port)) &
    done

elif [ $operation == "server" ]; then
    echo "Selected server operation...Starting service now..."
    for port in `seq 1 $nport`
    do
        iperf3 -s -p $(($startport + port)) &
    done
    echo "Done"

elif [ $operation == "kill" ]; then
    echo "Selected kill operation...Killing all instances now..."
    ps -aux | grep iperf3 | grep -v grep | awk '{print $2}' | xargs -r kill -9
    echo "Done..."

else
    echo "Invalid command for -o operation option. You may select between (client|server|kill)."
    exit
fi
