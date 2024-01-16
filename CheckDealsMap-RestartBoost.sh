#!/bin/bash
source /opt/raid0/profile
Current=`date +%F%\t%T`
[ ! -f /opt/raid0/lotusminer-sealing/lotusminer/logs ] && echo "/opt/raid0/lotusminer-sealing/lotusminer/logs 不存在" && exit 1
DealsMapNub=`grep 'deals map' /opt/raid0/lotusminer-sealing/lotusminer/logs |tail -1|tr -s ':{} ' '\n' |grep bafy2bzace -c`
GivenValue=2
echo "$Current"
echo "DealsMap的数量：$DealsMapNub"
echo "如果最新的DealsMap的数量小于规定的值$GivenValue，才会触发重启boostd"
if [ "$DealsMapNub" -le "$GivenValue" ];then
	echo "执行 kill -9 `pgrep boostd` 后，会睡眠一段时间........."
	kill -9 `pgrep boostd` && sleep 6s && kill -9 `pgrep boostd` && sleep 60s
	if pgrep boostd ;then
           echo "pgrep boostd 进程存在" && exit 2
        else
	   echo "准备启动boostd中........."
	   bash /opt/raid0/boost/start_boost.sh >/dev/null && echo "Start boostd Success"
	   exit 3
        fi
fi
