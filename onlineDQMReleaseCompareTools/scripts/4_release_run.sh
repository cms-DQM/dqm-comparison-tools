#!/bin/bash
# ./4_release_run.sh playback_14_0_4_xxx 379446 pp_run
# contact: zhengchen.liang@cern.ch

conf0=onlineDQMReleaseCompareTools/templates/localtest_clients_all # using the template of client list to compare

ondr2=/fff/BUs/dqmrubu-c2a06-05-01_ramdisk/ # using the directory online run copied to

work0=/home/dqmdevlocal/DQMReleaseCompare

if [ ! $USER = dqmdev ]; then
  echo "$0: Please run as user dqmdev."
  exit
fi

if [ $# -eq 2 ]; then
  arg3=pp_run
elif [ $# -eq 3 ]; then
  arg3=${3}
fi

if [ $# -gt 1 ]; then
  if [ ! -d ${ondr2}run${2} ]; then
    echo "$0: run file run${2} non-exist at target directory ${ondr2}, please copy."
    exit
  fi
  cd /dqmdata/dqm_cmssw/${1}/src/
  cmsenv
  cd ${work0}
  if [ ! -d streamlogs ]; then
    mkdir streamlogs
  fi
  list1=$(cat ${conf0} | grep "^d" | awk '{print $2}' | awk -F'/' '{print $NF}' | grep "_cfg\.py$")
  while IFS= read -r i0; do
    cmsRun /dqmdata/dqm_cmssw/${1}/src/DQM/Integration/python/clients/${i0} runInputDir=${ondr2} runNumber=${2} runkey=${arg3} scanOnce=True > streamlogs/${i0}.log &
    echo "$0: cmsRun /dqmdata/dqm_cmssw/${1}/src/DQM/Integration/python/clients/${i0} runInputDir=${ondr2}run${2} runNumber=${2} runkey=${arg3} scanOnce=True &"
    sleep 1
  done <<< ${list1}
  wait
  if [ -d streamout_${1}_run${2}_${arg3}/ ]; then
    rm -rf streamout_${1}_run${2}_${arg3}/
  fi
  if [ -d upload/ ]; then
    mv upload/ streamout_${1}_run${2}_${arg3}/
  fi
elif [ $# -eq 0 ]; then
  ls -ltrh ${ondr2} | tail -n 10
  echo ""
  echo "---------- $(ls -ltrh ${ondr2} | tail -n 10 | awk '{print $NF}' | grep -E "^run" | tail -n 1) ----------"
  echo ""
  echo "$0: an example is ${0} playback_14_0_4_xxx 379446 pp_run"
fi
