#!/bin/bash
# location: /global/homes/s/sglanvil/S2S/E3SM_S2S_Forecasts/analysis/loop_years.sh

#for iyear in {1999..2018}; do
#        echo ${iyear}
#       bash remap_files.sh "$iyear" > out_h3_${iyear} 2>&1 &
#done

varName=V850
hNum=h3
for imember in {001..011}; do
        echo ${imember}
        bash concat_files.sh "$varName" "$imember" "$hNum" > concat_${varName}_${imember} 2>&1 &
        sleep 30s
done

echo "Done with loop."

