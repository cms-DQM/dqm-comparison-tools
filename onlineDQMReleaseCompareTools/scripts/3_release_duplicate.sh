#!/bin/bash
# ./3_release_duplicate.sh s50 1
# contact: zhengchen.liang@cern.ch

base_exp="140X_dataRun3_Express_v2"
base_hlt="140X_dataRun3_HLT_v3"
comp_exp="140X_dataRun3_Express_v2"
comp_hlt="140X_dataRun3_HLT_v3"
evt0=20 # how many minimal events to compare in each LS

if [ ! $USER = dqmdev ]; then
  echo "$0: Please run as user dqmdev."
  exit
fi

if [ $# -eq 0 ]; then
  echo "$0: an example is ${0} s50 (i.e. the template file in scripts/ please change accordingly to your compare)"
  exit
fi

cmsswdeploy0()
{
  /usr/bin/env python3 /opt/fff_dqmtools/utils/cmssw_deploy.py "$@"
}

file0=$(ls | grep -E ^${1} | head -n 1)
line1=$(cat ${file0} | head -n 1)
line2=$(cat ${file0} | head -n 2 | tail -n 1)
type1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{print $1}')
type2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{print $1}')
mmdd1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{print $2}')
mmdd2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{print $2}')
sevn1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{print $7}')
sevn2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{print $7}')
eght1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{print $8}')
eght2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{print $8}')
nine1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{print $9}')
nine2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{print $9}')
ten1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{print $10}')
ten2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{print $10}')
elv1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{print $11}')
elv2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{print $11}')

if false \
  || [[ -z ${sevn1} ]] \
  || ( [[ ${sevn1} =~ ^[a-zA-Z] ]] \
    && [[ -z ${eght1} ]] \
  ) \
  || ( [[ ${eght1} =~ ^[a-zA-Z] ]] \
    && [[ -z ${nine1} ]] \
  ) \
  || ( [[ ${nine1} =~ ^[a-zA-Z] ]] \
    && [[ -z ${ten1} ]] \
  ) \
  || ( [[ ${ten1} =~ ^[a-zA-Z] ]] \
    && [[ -z ${elv1} ]] \
  ) \
; then
  pnum1="-"
  vers1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
else
  if [[ ${sevn1} =~ ^[0-9] ]]; then
    vers1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=6; i++) printf "%s%s", $i, (i<6 ? "_" : "")}')
    pnum1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{for(i=7; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
  elif [[ ${eght1} =~ ^[0-9] ]]; then
    vers1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=7; i++) printf "%s%s", $i, (i<7 ? "_" : "")}')
    pnum1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{for(i=8; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
  elif [[ ${nine1} =~ ^[0-9] ]]; then
    vers1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=8; i++) printf "%s%s", $i, (i<8 ? "_" : "")}')
    pnum1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{for(i=9; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
  elif [[ ${ten1} =~ ^[0-9] ]]; then
    vers1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=9; i++) printf "%s%s", $i, (i<9 ? "_" : "")}')
    pnum1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{for(i=10; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
  elif [[ ${elv1} =~ ^[0-9] ]]; then
    vers1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=10; i++) printf "%s%s", $i, (i<10 ? "_" : "")}')
    pnum1=$(echo ${line1} | awk '{print $1}' | awk -F'_' '{for(i=11; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
  else
    echo "$0: please check your CMSSW version format for the base release."
    exit
  fi
fi
if false \
  || [[ -z ${sevn2} ]] \
  || ( [[ ${sevn2} =~ ^[a-zA-Z] ]] \
    && [[ -z ${eght2} ]] \
  ) \
  || ( [[ ${eght2} =~ ^[a-zA-Z] ]] \
    && [[ -z ${nine2} ]] \
  ) \
; then
  pnum2="-"
  vers2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
else
  if [[ ${sevn2} =~ ^[0-9] ]]; then
    vers2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=6; i++) printf "%s%s", $i, (i<6 ? "_" : "")}')
    pnum2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{for(i=7; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
  elif [[ ${eght2} =~ ^[0-9] ]]; then
    vers2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=7; i++) printf "%s%s", $i, (i<7 ? "_" : "")}')
    pnum2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{for(i=8; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
  elif [[ ${nine2} =~ ^[0-9] ]]; then
    vers2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=8; i++) printf "%s%s", $i, (i<8 ? "_" : "")}')
    pnum2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{for(i=9; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
  elif [[ ${ten2} =~ ^[0-9] ]]; then
    vers2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=9; i++) printf "%s%s", $i, (i<9 ? "_" : "")}')
    pnum2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{for(i=10; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
  elif [[ ${elv2} =~ ^[0-9] ]]; then
    vers2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{for(i=4; i<=10; i++) printf "%s%s", $i, (i<10 ? "_" : "")}')
    pnum2=$(echo ${line2} | awk '{print $1}' | awk -F'_' '{for(i=11; i<=NF; i++) printf "%s%s", $i, (i<NF ? "_" : "")}')
  else
    echo "$0: please check your CMSSW version format for the comp release."
    exit
  fi
fi
pull1=$(echo ${pnum1} | sed 's|_|,|g')
pull2=$(echo ${pnum2} | sed 's|_|,|g')
rnum1=$(echo ${line1} | awk '{print $2}')
rnum2=$(echo ${line2} | awk '{print $2}')
rkey1=$(echo ${line1} | awk '{print $3}')
rkey2=$(echo ${line2} | awk '{print $3}')
if [ -z ${rkey1} ] || [ -z ${rkey2} ]; then
  echo "$0: check your text input file ^${1}."
  exit
fi

dire0=$(pwd)
dply0=/dqmdata/dqm_cmssw
work0=/home/dqmdevlocal/DQMReleaseCompare

if [ $# -eq 1 ]; then
  cd ${dply0}
  if [ ${pull1} = "-" ]; then
    DEP1="compare_${type1}_${mmdd1}_CMSSW_${vers1}"
  else
    DEP1="compare_${type1}_${mmdd1}_CMSSW_${vers1}_${pnum1}"
  fi
  if [ -d ${DEP1} ]; then
    rm -rf ${DEP1}
  fi
  export DEP1="${DEP1}/src/"
  if [ ${pull1} = "-" ]; then
    cmsswdeploy0 make-release --use-tmp -l compare_${type1}_${mmdd1} -t CMSSW_${vers1} --no-build
  else
    cmsswdeploy0 make-release --use-tmp -l compare_${type1}_${mmdd1} -t CMSSW_${vers1} -p ${pull1} --no-build
  fi
  if [ ! -d ${DEP1} ]; then
    echo "$0: failed create ${DEP1}."
    exit
  fi
  cd ${DEP1}
  cmsenv
  if [ ${pull1} = "-" ]; then
    git cms-addpkg DQM/Integration
  fi
  modi0="DQM/Integration/python/config/FrontierCondition_GT_autoExpress_cfi.py"
  cat ${modi0} | awk -v ar0=${base_exp} '/^GlobalTag.globaltag/ {sub(/=.*/, "= \"" ar0 "\"")} {print}' > tmp && mv tmp ${modi0}
  modi0="DQM/Integration/python/config/FrontierCondition_GT_cfi.py"
  cat ${modi0} | awk -v ar0=${base_hlt} '/^GlobalTag.globaltag/ {sub(/=.*/, "= \"" ar0 "\"")} {print}' > tmp && mv tmp ${modi0}
  patn0="minEventsPerLumi.*cms.*untracked.*int32"
  repl0="s|(\([0-9]\+\))|\(${evt0}\)|g"
  sed -i "/${patn0}/ ${repl0}" DQM/Integration/python/config/inputsource_cfi.py
  patn0="process.*DQMmodules.*cms.*Sequence.*dqmSaverPB"
  repl0="s|(\([^)]*\))|\(process.dqmEnv * process.dqmSaver\)|g"
  sed -i "/${patn0}/ ${repl0}" DQM/Integration/python/clients/pixel_dqm_sourceclient-live_cfg.py
  patn0="process.*DQMCommon.*cms.*Sequence.*dqmEnvTr.*dqmSaverPB"
  repl0="s|(\([^)]*\))|\(process.dqmEnv * process.dqmEnvTr * process.dqmSaver\)|g"
  sed -i "/${patn0}/ ${repl0}" DQM/Integration/python/clients/sistrip_dqm_sourceclient-live_cfg.py
  patn0="process.*DQMCommon.*cms.*Sequence.*stripQTester.*trackingQTester.*dqmSaverPB"
  repl0="s|(\([^)]*\))|\(process.stripQTester * process.trackingQTester * process.dqmEnv * process.dqmEnvTr * process.dqmSaver\)|g"
  sed -i "/${patn0}/ ${repl0}" DQM/Integration/python/clients/sistrip_dqm_sourceclient-live_cfg.py
  scram b -j24
  cd ${dply0}
  if [ ${pull2} = "-" ]; then
    DEP2="compare_${type2}_${mmdd2}_CMSSW_${vers2}"
  else
    DEP2="compare_${type2}_${mmdd2}_CMSSW_${vers2}_${pnum2}"
  fi
  if [ -d ${DEP2} ]; then
    rm -rf ${DEP2}
  fi
  export DEP2="${DEP2}/src/"
  if [ ${pull2} = "-" ]; then
    cmsswdeploy0 make-release --use-tmp -l compare_${type2}_${mmdd2} -t CMSSW_${vers2} --no-build
  else
    cmsswdeploy0 make-release --use-tmp -l compare_${type2}_${mmdd2} -t CMSSW_${vers2} -p ${pull2} --no-build
  fi
  if [ ! -d ${DEP2} ]; then
    echo "$0: failed create ${DEP2}."
    exit
  fi
  cd ${DEP2}
  cmsenv
  if [ ${pull2} = "-" ]; then
    git cms-addpkg DQM/Integration
  fi
  modi0="DQM/Integration/python/config/FrontierCondition_GT_autoExpress_cfi.py"
  cat ${modi0} | awk -v ar0=${comp_exp} '/^GlobalTag.globaltag/ {sub(/=.*/, "= \"" ar0 "\"")} {print}' > tmp && mv tmp ${modi0}
  modi0="DQM/Integration/python/config/FrontierCondition_GT_cfi.py"
  cat ${modi0} | awk -v ar0=${comp_hlt} '/^GlobalTag.globaltag/ {sub(/=.*/, "= \"" ar0 "\"")} {print}' > tmp && mv tmp ${modi0}
  patn0="minEventsPerLumi.*cms.*untracked.*int32"
  repl0="s|(\([0-9]\+\))|\(${evt0}\)|g"
  sed -i "/${patn0}/ ${repl0}" DQM/Integration/python/config/inputsource_cfi.py
  patn0="process.*DQMmodules.*cms.*Sequence.*dqmSaverPB"
  repl0="s|(\([^)]*\))|\(process.dqmEnv * process.dqmSaver\)|g"
  sed -i "/${patn0}/ ${repl0}" DQM/Integration/python/clients/pixel_dqm_sourceclient-live_cfg.py
  patn0="process.*DQMCommon.*cms.*Sequence.*dqmEnvTr.*dqmSaverPB"
  repl0="s|(\([^)]*\))|\(process.dqmEnv * process.dqmEnvTr * process.dqmSaver\)|g"
  sed -i "/${patn0}/ ${repl0}" DQM/Integration/python/clients/sistrip_dqm_sourceclient-live_cfg.py
  patn0="process.*DQMCommon.*cms.*Sequence.*stripQTester.*trackingQTester.*dqmSaverPB"
  repl0="s|(\([^)]*\))|\(process.stripQTester * process.trackingQTester * process.dqmEnv * process.dqmEnvTr * process.dqmSaver\)|g"
  sed -i "/${patn0}/ ${repl0}" DQM/Integration/python/clients/sistrip_dqm_sourceclient-live_cfg.py
  scram b -j24
  cd ${dire0}
  if [ ${pull1} = "-" ]; then
    echo "compare_${type1}_${mmdd1}_CMSSW_${vers1} ${rnum1} ${rkey1}" > tmp_${file0}
  else
    echo "compare_${type1}_${mmdd1}_CMSSW_${vers1}_${pnum1} ${rnum1} ${rkey1}" > tmp_${file0}
  fi
  if [ ${pull2} = "-" ]; then
    echo "compare_${type2}_${mmdd2}_CMSSW_${vers2} ${rnum2} ${rkey2}" >> tmp_${file0}
  else
    echo "compare_${type2}_${mmdd2}_CMSSW_${vers2}_${pnum2} ${rnum2} ${rkey2}" >> tmp_${file0}
  fi
elif [ $# -eq 2 ]; then
  cd ${dply0}
  if [ ${pull1} = "-" ]; then
    DEP1="compare_${type1}_${mmdd1}_CMSSW_${vers1}"
  else
    DEP1="compare_${type1}_${mmdd1}_CMSSW_${vers1}_${pnum1}"
  fi
  if [ -d ${DEP1} ]; then
    rm -rf ${DEP1}
  fi
  if [ ${pull2} = "-" ]; then
    DEP2="compare_${type2}_${mmdd2}_CMSSW_${vers2}"
  else
    DEP2="compare_${type2}_${mmdd2}_CMSSW_${vers2}_${pnum2}"
  fi
  if [ -d ${DEP2} ]; then
    rm -rf ${DEP2}
  fi
  cd ${dire0}
  if [ -f tmp_${file0} ]; then
    rm tmp_${file0}
  fi
fi
