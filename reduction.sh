#! /bin/bash
# 还原备份数据库文件
#备份文件 tar
file=$1
#文件名 
filename=$2 
DIR=/home/work/backup 
socket=/home/work/data/tmp/mysql3308.sock  # 多实例sock文件地址
MYCMD="mysql -uroot  -S ${socket}" # mysql连接

## 解压sql文件
cd ${DIR}
tar xvf $file
if [  $? = 0 ];then
	cd $filename
	pwd

## 还原数据库文件
for db in `ls /home/work/backup/${filename}`
do
    
	gunzip ${db}
	dbname=${db%%.sql*}
	if [ $? = 0 ];then
		echo ${dbname}
		 create_db_sql="CREATE DATABASE IF NOT EXISTS ${dbname} ;"
		`${MYCMD} -e "${create_db_sql}"`
		`${MYCMD} -e "reset master;"`
		${MYCMD} ${dbname} < ${dbname}.sql 
		
				
		$MYCMD << EOF

		grant all on xm_wps.* to xm_wps@"%" identified by "TomDXVz4g4hkw1fSnQFsZI0xlbKMKeHa";


		grant all on xm_wp.* to xmwp_w@"%" identified by "ao1PSru7QtAzSCfTMdYmMxWF7LDvp4x1"; 


		grant all on xm_wms3.* to xm_wms3@"%" identified by "D4SYBeQH_3WOF72I";


		grant all on xm_wms2_tm.* to wms2_tm_w@"%" identified by "D4SYBeQH_3WOF72I";


		grant all on xm_pss_dev.* to pss_w@"%" identified by "Jh8z965_HwiRlSfI";


		grant all on xm_notify.* to notify_w@"%" identified by "0NxYNLsL_2ey529yiioer";


		grant all on xm_cs.* to xm_cs_w@"%" identified by "cN0zjAv_2EfUQVzd";



		grant all on xm_buy_n.* to xiaomitest8@"%" identified by "xiaomitest8";

		grant all on *.* to oc_api_wr@"%" identified by "ff5e66b76340c5636aa40e7c6a46628f";

		EOF
	else
		echo "解析数据库名称出错！"
	fi
	
done
else
	echo "tar 出错！"
fi