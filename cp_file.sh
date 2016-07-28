#!/bin/bash


fileName=${1}
#fileName=/home/work/env-oc/hosts_bak/hosts   client 传过来，要覆盖标准的文件

coverFile=${2}
# /etc/hosts   将会被覆盖的文件

BackUpcoverFile=${3}  
# /etc/host_bak/hosts   备份覆盖的文件

sufix_date=`date +%Y%m%d%H%M`;


 cpHost()
{
 fileSize=`ls -l ${fileName} | awk '{print $5}'`
if [ "${fileSize}" == "0" ];then
      echo "${fileName} can not be null ! "
  else
	cp -rf ${coverFile}  ${BackUpcoverFile}_${sufix_date}
	    if [ $? -eq 0 ];then
		   \cp -rf ${fileName}  ${coverFile}
		fi
 fi
}
 
main()
{
   cpHost
}
main