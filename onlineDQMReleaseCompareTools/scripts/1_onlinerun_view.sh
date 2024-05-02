#!/bin/bash
# ./1_onlinerun_view.sh # to get the last online run number
# ./1_onlinerun_view.sh 378673 # to get the availble LSs of a run
# contact: zhengchen.liang@cern.ch

ondr1=/fff/BUs/dqmrubu-c2a06-01-01_ramdisk/ # online directory for DQM clients

if [ $# -eq 0 ]; then
  ls -ltrh ${ondr1} | tail -n 10
  last1=$(ls -ltrh ${ondr1} | tail -n 10 | awk '{print $NF}' | grep -E "^run" | tail -n 1 | cut -c4-)
  echo ""
  echo "---------- Last online run = ${last1} ----------"
  echo ""
elif [ $# -eq 1 ]; then
  if [ -z $(ls ${ondr1} | grep ${1}) ]; then
    echo "$0: Run ${1} is not stored online."
  else
    strm1=$(ls -ltrh ${ondr1}/run${1} | tail -n 2 | head -n 1 | awk '{print $NF}')
    if [ "$(echo ${strm1} | awk -F'.' '{print $NF}')" = "deleted" ]; then
      echo "$0: Last lumi of ${1} seems to be deleted please check."
    else
      mxls1=$(echo ${strm1} | awk -F'_' '{print $2}' | cut -c3-)
      echo ""
      echo "---------- Run ${1} current LS = 0001 to ${mxls1} ----------"
      echo ""
    fi
  fi
fi
