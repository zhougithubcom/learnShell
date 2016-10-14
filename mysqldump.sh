#! /bin/bash
#目标机器 10.237.41.100

user=root # 数据库用户
pass=root # 用户密码
socket=/home/work/data/tmp/mysql3308.sock  # 多实例sock文件地址
MYCMD="mysql -u${user} -p${pass} -S ${socket}" # mysql连接
MYDUMP="/home/work/app/mysql/bin/mysqldump -u${user} -p${pass} -d -S ${socket}" # mysqldump连接

#备份时间
LOCALTM=`date +"%Y%m%d"`

#备份基础路径
BASEDIR=/home/work/data/mysql/backup/mysql-backup

#定义MySQL本地备份路径
BAKDIR=${BASEDIR}/${LOCALTM}/   # 保存的文件地址
if [ ! -d $BAKDIR ];then
	mkdir -p $BAKDIR
fi

#备份数据库
for database in `${MYCMD} -e "show databases;"|grep -Eiv 'sys|performance_schema|database|information_schema|mysql'`
do
	echo ${database}
	${MYDUMP} ${database}|gzip > ${BAKDIR}${database}.sql.gz
done


##压缩当天备份sql文件
cd ${BASEDIR}
echo pwd
tar cvf  ${LOCALTM}.tar  ./${LOCALTM}


##删除临时文件
#rm -rf ./${LOCALTM}


##复制文件到需要初始化数据库的目标机器

DIR=/home/work/backup

scp -r ${LOCALTM}.tar root@10.237.41.136:${DIR}

ssh root@10.237.41.136
/home/shell/reduction.sh ${LOCALTM}.tar ${LOCALTM}



