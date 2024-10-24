#!/bin/bash
# location: /global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/analysis/remap_files.sh
# sglanvil | Sept-19-2024

iyear=$1
source /global/common/software/e3sm/anaconda_envs/load_latest_e3sm_unified_pm-cpu.sh
weightsFile=/global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/analysis/map_ne30pg2_to_0.9x1.25_aave.20230801.nc
destDir=/pscratch/sd/s/sglanvil/S2S_POSTPROC/
fileListing=E3SM_S2S_eam.h2_files.txt

mkdir -p ${destDir}
#mkdir -p ${destDir}/PRECT/dailyAvg
#mkdir -p ${destDir}/TREFHT/dailyAvg
#mkdir -p ${destDir}/FLUT/dailyAvg
#mkdir -p ${destDir}/Q850/dailyAvg
#mkdir -p ${destDir}/U200/dailyAvg
#mkdir -p ${destDir}/U850/dailyAvg
#mkdir -p ${destDir}/V200/dailyAvg
#mkdir -p ${destDir}/V850/dailyAvg

for ifile in $(cat $fileListing); do
        if [[ ${ifile} == *${iyear}* ]]; then
                echo $ifile
                fileName=$(basename $ifile .nc)
                remappedFile=${destDir}/${fileName}_mapped.nc
                if [[ ! -f "${remappedFile}" ]]; then
                        echo "need to remap"
                        ncremap -m ${weightsFile} -in ${ifile} ${remappedFile}
                fi
                #ncks -O -v PRECT ${remappedFile} ${destDir}/PRECT/dailyAvg/PRECT_${fileName}.nc
                #ncks -O -v TREFHT ${remappedFile} ${destDir}/TREFHT/dailyAvg/TREFHT_${fileName}.nc
                #ncks -O -v FLUT ${remappedFile} ${destDir}/FLUT/dailyAvg/FLUT_${fileName}.nc
                #ncks -O -v Q850 ${remappedFile} ${destDir}/Q850/dailyAvg/Q850_${fileName}.nc
                #
                #ncks -O -v U200 ${remappedFile} ${destDir}/U200/U200_${fileName}.nc
                #ncks -O -v U850 ${remappedFile} ${destDir}/U850/U850_${fileName}.nc
                #ncks -O -v V200 ${remappedFile} ${destDir}/V200/V200_${fileName}.nc
                #ncks -O -v V850 ${remappedFile} ${destDir}/V850/V850_${fileName}.nc
                #ncra --mro -O -d time,,,4,4 ${destDir}/U200/U200_${fileName}.nc ${destDir}/U200/dailyAvg/U200_${fileName}.nc
                #ncra --mro -O -d time,,,4,4 ${destDir}/U850/U850_${fileName}.nc ${destDir}/U850/dailyAvg/U850_${fileName}.nc
                #ncra --mro -O -d time,,,4,4 ${destDir}/V200/V200_${fileName}.nc ${destDir}/V200/dailyAvg/V200_${fileName}.nc
                #ncra --mro -O -d time,,,4,4 ${destDir}/V850/V850_${fileName}.nc ${destDir}/V850/dailyAvg/V850_${fileName}.nc
                echo
        fi
done

