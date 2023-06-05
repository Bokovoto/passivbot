#!/bin/bash
symbol=$1
tf=$2

we="0.9"
backtest_cfg="/home/galsky/passivbot/configs/backtest/default.hjson"
dir_bt="/home/galsky/passivbot/backtests"
dir_configsrc="/home/galsky/passivbot/passivbot_optimizations/configs/v5.9.5"
dir_configdst="/home/galsky/passivbot/configs/live"
activate_new=false

#No need to change from here
start=$(date --date='-'"$tf"' month' +%Y-%m-%d)
end=$(date +%Y-%m-%d)
end_name=$(date +%Y-%m-%d_%H)

#cleanup from last run
rm -fr ${dir_bt}/$symbol

#run backtest
mkdir -p ${dir_bt}/$symbol
index=1
for i in $(find ${dir_configsrc} -name config.json | grep $symbol); do
    sed -E 's/wallet_exposure_limit.*},$/wallet_exposure_limit": '"$we"'},/gm;t' "$i" >${dir_bt}/$symbol/config${index}.json
    sed -E 's/wallet_exposure_limit.*}}$/wallet_exposure_limit": '"$we"'}}/gm;t' "${dir_bt}/$symbol/config${index}.json" >${dir_bt}/$symbol/tmp.json
    sed -E 's/wallet_exposure_limit.*[0-9],$/wallet_exposure_limit": '"$we"',/gm;t' ${dir_bt}/$symbol/tmp.json >${dir_bt}/$symbol/config${index}.json
    rm ${dir_bt}/$symbol/tmp.json
    python3.8 backtest.py -s ${symbol} --start_date $start --end_date $end -bd ${dir_bt}/${symbol} ${dir_bt}/${symbol}/config${index}.json
    let index++
done

# Show Results
grep -R 'Net Total gain ' ${dir_bt}/${symbol}/*/$symbol/plots/* | sort -nk 6

#copy best profit
best=$(grep -R 'Net Total gain ' ${dir_bt}/${symbol}/*/${symbol}/plots/* | sort -nk 6 | tail -n 1 | grep -o ^.*\/)
bestname=$(grep -R 'Net Total gain ' ${dir_bt}/${symbol}/*/${symbol}/plots/* | sort -nk 6 | tail -n 1 | cut -d/ -f7)

diff -q -I config_name ${best}live_config.json ${dir_configdst}/${symbol}.json 1>/dev/null
if [[ $? == "0" ]]
then
  echo "No new better config"
else
  echo "${bestname} is new best config"
  cp ${best}live_config.json ${dir_configdst}/${symbol}_${end_name}.json
  cp ${best}backtest_result.txt ${dir_configdst}/${symbol}_${end_name}.txt
  cp ${best}balance_and_equity_sampled_long.png ${dir_configdst}/${symbol}_${end_name}.png
  cp ${best}wallet_exposures_plot.png ${dir_configdst}/${symbol}_${end_name}_we.png
  activ=$(grep -m1 "markup_range" ${dir_configdst}/${symbol}.json | cut -d' ' -f12 | cut -d, -f1 | { read ema ; grep -R $ema ${dir_bt}/$symbol/*/${symbol}/plots/*/live_config.json /dev/null ; } | grep -o ^.*\/ | tail -n 1)
  echo $activ
  cp ${activ}backtest_result.txt ${dir_configdst}/${symbol}.txt
  cp ${activ}balance_and_equity_sampled_long.png ${dir_configdst}/${symbol}.png
  #activate new best config
  if ${activate_new}
  then
    echo "activate new config"
    mv ${dir_configdst}/${symbol}.json ${dir_configdst}/${symbol}_${end_name}_old.json
    cp ${dir_configdst}/${symbol}_${end_name}.json ${dir_configdst}/${symbol}.json
    python manager restart $symbol -y
  fi
fi

