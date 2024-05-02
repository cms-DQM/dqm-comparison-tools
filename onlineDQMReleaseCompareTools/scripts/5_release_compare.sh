#!/bin/bash
# ./5_dqmclient_compare.sh s50

if [ ! $USER = dqmdev ]; then
  echo "$0: Please run as user dqmdev."
  exit
fi

if [ $# -eq 0 ]; then
  echo "$0: an example is ${0} s50"
  exit
else
  arg1=${1}
fi

dire0=$(pwd)
work0=/home/dqmdevlocal/DQMReleaseCompare

file0=$(ls | grep -E ^"tmp_${arg1}" | head -n 1)
if [ ! -f ${file0} ]; then
  echo "$0: tmp_${1} input template not found. Have to run release duplicate first."
  exit
fi
base0=$(cat ${file0} | head -n 1)
comp0=$(cat ${file0} | head -n 2 | tail -n 1)
base1=$(echo ${base0} | awk '{print $1}')
comp1=$(echo ${comp0} | awk '{print $1}')
base2=$(echo ${base0} | awk '{print $2}')
comp2=$(echo ${comp0} | awk '{print $2}')
base3=$(echo ${base0} | awk '{print $3}')
comp3=$(echo ${comp0} | awk '{print $3}')
if [[ ! ${base1} == compare_* ]] || [[ ! ${comp1} == compare_* ]]; then
  echo "$0: seems not using the compare_* DQM cmssw."
fi
if [ -z ${base3} ]; then
  base3=pp_run
fi
if [ -z ${comp3} ]; then
  comp3=pp_run
fi
topd0=${base1}_vs_${comp1}
inid0=${topd0}/input
outd0=${topd0}/output
sumd0=${topd0}/summary

cd ${work0}
if [ ! -d ${topd0} ]; then
  mkdir ${topd0}
fi
if [ ! -d ${inid0} ]; then
  mkdir ${inid0}
fi
if [ ! -d ${outd0} ]; then
  mkdir ${outd0}
else
  rm -rf ${outd0}
  mkdir ${outd0}
fi
if [ ! -d ${sumd0} ]; then
  mkdir ${sumd0}
else
  rm -rf ${sumd0}
  mkdir ${sumd0}
fi

cd ${dire0}
./4_release_run.sh ${base1} ${base2} ${base3}
mv ${work0}/streamlogs ${work0}/${inid0}/streamlogs_${base1}
./4_release_run.sh ${comp1} ${comp2} ${comp3}
mv ${work0}/streamlogs ${work0}/${inid0}/streamlogs_${comp1}

cd ${work0}/${inid0}
if [ -d streamout_${base1}_run${base2}_${base3}/ ]; then
  rm -rf streamout_${base1}_run${base2}_${base3}/
fi
if [ -d streamout_${comp1}_run${comp2}_${comp3}/ ]; then
  rm -rf streamout_${comp1}_run${comp2}_${comp3}/
fi
mv ../../streamout_${base1}_run${base2}_${base3}/ .
mv ../../streamout_${comp1}_run${comp2}_${comp3}/ .
base4=$(realpath "streamout_${base1}_run${base2}_${base3}")
comp4=$(realpath "streamout_${comp1}_run${comp2}_${comp3}")

cd /dqmdata/dqm_cmssw/${base1}/src
cmsenv

cd ${work0}
${work0}/onlineDQMReleaseCompareTools/python/relcompareDQMOutput.py -b ${base4} --base-run "000"${base2} -c ${comp4} --comp-run "000"${comp2} -o ${work0}/${outd0} -r "$CMSSW_VERSION" -j12 --comprel-name ${topd0} -s ${work0}/${sumd0}
echo "$0: ${work0}/onlineDQMReleaseCompareTools/python/relcompareDQMOutput.py -b ${base4} --base-run "000"${base2} -c ${comp4} --comp-run "000"${comp2} -o ${work0}/${outd0} -r "$CMSSW_VERSION" -j12 --comprel-name ${topd0} -s ${work0}/${sumd0}"
