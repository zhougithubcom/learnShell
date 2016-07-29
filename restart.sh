#!/bin/bash
#########################
#author:anshsh
#date:20160226
#########################
branch=$1
if [ -z $branch ]; then
	echo "执行错误：传入参数为空，请确认后building"
	exit 0;
fi
work=/home/work
resin_work=$work/app/resin
src_work=$work/env-oc/workspace/$branch
warbak_work=$work/env-oc/bak_war
config_bak_work=$work/env-oc/configure_oc
config_work=$work/env-oc/workspace/$branch/WEB-INF/classes
resinidFile=$work/env-oc/resinid.txt

short_date=`date +%Y%m%d%H%M`;

#check resinidfile exists? otherwise , touch new file
if [ -f $resinidFile ]; then
    rm -f $resinidFile;
fi
touch $resinidFile
if [ $branch == 'ocapi-master-test'  ]; then
	echo "Start $branch building==========="
	
	sh $resin_work/bin/resin.sh stop --server oc-be0
	
	#search $branch process
	ps aux | grep resin | grep java | grep -v watchdog | grep oc-be | awk '{print $2}'>>$resinidFile
	#check $resinidfile empty?
	if [ -s $resinidFile ]; then
		ps aux | grep resin | grep java | grep -v watchdog | grep oc-be | awk '{print $2}' | xargs -r kill -9
	fi

	

	#clean source_oc file,first check work_dir exists?
	if [ ! -d $src_work ]; then
		echo "Fail info : $src_work not exists!"
		exit 1;
	fi
	cd $src_work
	#rm -rf ./*

	#check .war file exists?
	if [ ! -f $warbak_work/oc-web.war ]; then
		echo "Fail info : oc-web not exists!"
		exit 1;
	fi
	echo $pwd
	cp $warbak_work/oc-web.war ./
	jar -xf oc-web.war
	rm -f oc-web.war
#	cp $config_bak_work/application.properties $config_work/
	#bakup .war file to datafile
	mv $warbak_work/oc-web.war $warbak_work/oc-web.war.$short_date
	#start resin service
	sh $resin_work/bin/resin.sh start --server oc-be0
fi

if [ $? = 0 ]; then
	echo "$branch build Success ......"
fi
