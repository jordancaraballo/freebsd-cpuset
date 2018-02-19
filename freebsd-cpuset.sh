#!/bin/bash
# Script for FreeBSD that lets the user set interrupt loads to a specific amount of cores,
# or to balance the load to a specific cpu. This will take the amount of cpu's available
# in your system and set interrupts to your desired amount.
# Authors: Jordan A. Caraballo-Vega, John Jasen
# Precursor: Navdeep Parhar

### Usage options are listed below
usage="$(basename "$0") [-h] [-m name] [-i n] [-l n] - Script for FreeBSD to load interrupts to specific cores.
where:
    -h show usage help
    -m string with the name of the nic module e.g t6nex0 - Default t6nex0
    -i id of the initial core to balance the load e.g 0
    -l id of the final core to balance the load e.g 10"

### Parse options from command line
module='t6nex0'
while getopts m:i:l:h option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    m) module=$OPTARG;;
    i) initialCore=$OPTARG;;
    l) lastCore=$OPTARG;;
  esac
done
shift $((OPTIND - 1))

### Validate input
if [[ -z "$initialCore" || -z "$lastCore" || -z "$module" ]]; then
  echo "Refer to usage option -h"
  exit
fi

ncpu=$(sysctl -a | egrep -i hw.ncpu | cut -f2 -d: | cut -c2-)
irqlist=$(vmstat -ia | egrep $module | cut -f1 -d: | cut -c4-)
echo "Entered values: module $module, initial core: $initialCore, last core: $lastCore"
echo "Number of cpu: $ncpu"

if [[ $initialCore -lt 0 || $lastCore -ge $ncpu || -z "$irqlist" ]]; then
  echo "Values are not within the range. Check max amount of cores and modules availability"
  exit
fi

### Execute cpuset
i=$initialCore
for irq in $irqlist; do
  echo cpuset -core $i -irq $irq
  cpuset -l $i -x $irq
  i=$((i+1))
  [ $i -ge $lastCore ] && i=$initialCore
done
echo "Done. The load was balanced."
