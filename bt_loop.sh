#!/bin/bash
tf=12
cpu=6
pause=86400
symbol_list=SANDUSDT,LINKUSDT,ADAUSDT,AGIXUSDT,DOGEUSDT,FETUSDT,MANAUSDT,MATICUSDT,OPUSDT,RNDRUSDT,HBARUSDT,GALAUSDT
dir_git="./passivbot_optimizations"
dir_logs="./backtests"

#No need to change from here
IFS=,
export LC_ALL=C

while true
do
    git --git-dir=${dir_git}/.git pull | grep -q 'Already up to date.'
    if [[ $? == "0" ]]
    then
      echo "No new configs"
      sleep ${pause}
    else
      end_name=$(date +%Y-%m-%d_%H)
      for symbol in $symbol_list; do
          while [ $(jobs | wc -l) -ge $cpu ];
           do
              sleep 10
          done
          echo $symbol
          mkdir -p ${dir_logs}/$symbol
          ./bt.sh $symbol $tf >${dir_logs}/${symbol}/${end_name}.log 2>&1 &
      done
      sleep ${pause}
    fi
done
