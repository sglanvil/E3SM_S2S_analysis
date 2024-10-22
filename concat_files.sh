#!/bin/bash

# location: /global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/analysis/concat_files.sh 
# Oct-22-2024 | sglanvil | E3SM S2S
# Concat "remapped, one-var-only" for each member so you end up with VAR(lon,lat,lead,init) for each member
# Also create a new init variable which is somewhat complicated

# check srcDir location 
# check h2 vs h3
# check first forecast date (currently 1999-02-22)

source /global/common/software/e3sm/anaconda_envs/load_latest_e3sm_unified_pm-cpu.sh
srcDir=/pscratch/sd/s/sglanvil/S2S_POSTPROC/${varName}/ # maybe need /dailyAvg/
destDir=/pscratch/sd/s/sglanvil/S2S_POSTPROC/concatedFiles/

varName=$1
imember=$2

ncecat -O ${srcDir}/*.${imember}.eam.h2* ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.h2.nc
datesArray=($(ls ${srcDir}/*.${imember}.eam.h2* | sed -E 's/.*eam\.h2\.([0-9]{4}-[0-9]{2}-[0-9]{2})-00000\.nc/\1/'))
daysSinceArray=()
for date in "${datesArray[@]}"; do
        seconds1=$(date -d "1999-02-22" +%s)
        seconds2=$(date -d "$date" +%s)
        daysSince=$(( (seconds2 - seconds1) / 86400 ))
        daysSinceArray+=("$daysSince")
done
IFS=','
daysSinceString="${daysSinceArray[*]}"
unset IFS
ncap2 -O -s "init[record]={${daysSinceString}}" ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.h2.nc ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.h2.nc
ncatted -a long_name,init,o,c,"initialization time" ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.h2.nc
ncatted -a units,init,o,c,"days since 1999-02-22 00:00:00" ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.h2.nc
ncatted -a calendar,init,o,c,"noleap" ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.h2.nc
