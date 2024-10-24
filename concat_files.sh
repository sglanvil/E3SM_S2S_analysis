#!/bin/bash

# location: /global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/analysis/concat_files.sh 
# Oct-22-2024 | sglanvil | E3SM S2S
# Concat "remapped, one-var-only" for each member so you end up with VAR(lon,lat,lead,init) for each member
# Also create a new init variable which is somewhat complicated (current startdate=1999-02-22)
source /global/common/software/e3sm/anaconda_envs/load_latest_e3sm_unified_pm-cpu.sh
varName=$1
imember=$2
hNum=$3
srcDir=/pscratch/sd/s/sglanvil/S2S_POSTPROC/${varName}/dailyAvg/
destDir=/pscratch/sd/s/sglanvil/S2S_POSTPROC/concatedFiles/

#ncecat -O ${srcDir}/*.${imember}.eam.${hNum}* ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.${hNum}.nc
datesArray=($(ls ${srcDir}/*.${imember}.eam.${hNum}* | sed -E 's/.*eam\.h[0-9]\.([0-9]{4}-[0-9]{2}-[0-9]{2})-00000\.nc/\1/'))
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
echo "Days since (comma-separated): $daysSinceString"

while true; do
        rm ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.${hNum}.nc.*.ncap2.tmp
        ncap2 -O -s "init[record]={${daysSinceString}}" ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.${hNum}.nc ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.${hNum}.nc
        sleep 10s
        if ! ls ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.${hNum}.nc.*.ncap2.tmp 1> /dev/null 2>&1; then
                echo "ncap2 succeeded..."
                break
        else
                echo "ncap2 failed (Killed). Retrying..."
                sleep 10s
        fi
done
sleep 10s
ncatted -a long_name,init,o,c,"initialization time" ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.${hNum}.nc
ncatted -a units,init,o,c,"days since 1999-02-22 00:00:00" ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.${hNum}.nc
ncatted -a calendar,init,o,c,"noleap" ${destDir}/${varName}_v21.LR.S2Ssmbb.ALLinits.${imember}.eam.${hNum}.nc
echo "Done"
