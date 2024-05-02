#!/bin/bash
# ./2_onlinerun_copy.sh 378673 1 92 # to copy an online run $1 from LS $2 LS to LS $3
# contact: zhengchen.liang@cern.ch

ondr1=/fff/BUs/dqmrubu-c2a06-01-01_ramdisk/ # online run copy from
ondr2=/fff/BUs/dqmrubu-c2a06-05-01_ramdisk/ # online run copy to

if [ $# -eq 3 ]; then
  if [ $2 -gt $3 ]; then
    exit
  fi
  for i0 in $(seq $2 $3); do
    ls1=$(printf "%04d" ${i0})
    echo "---------- Copying LS = ${ls1} ----------"
    if [ ! -d ${ondr2}run${1} ]; then
      sudo mkdir ${ondr2}run${1}
    fi
    sudo cp -r ${ondr1}run${1}/*${ls1}* ${ondr2}run${1}
  done
  echo "---------- Copy End ----------"
elif [ $# -eq 0 ]; then
  echo "$0: an example is ${0} 378673 1 92 # to copy an online run from a begin LS to an end LS"
fi
