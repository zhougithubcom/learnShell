# !/bin/bash
###################
#@in_url 输入的url
#@in_ip 输入的ip
##########################
in_url=${1}
in_ip=${2}
 
# change host
updateHost()
{
# read 
  inner_host=`cat /etc/hosts | grep ${in_url} | awk '{print $1}'`
  if [ "${inner_host}"  ==  "${in_ip}"  ];then
     echo "${inner_host}  ${in_url} Already exist! "
  else
    #替换
	  sed -i "s/${inner_host}/${in_ip}/g" /etc/hosts
     if [ $? -eq 0 ];then
       echo "change ${inner_host} to ${in_ip} is ok !"
       else 
         inner_ip_map="${in_ip} ${in_url}"
         echo ${inner_ip_map} >> /etc/hosts
         if [ $? -eq 0 ]; then
           echo "${inner_ip_map} to hosts success host is `cat /etc/hosts`"
         fi
     fi
  fi
}
 
main()
{
   updateHost
}
main
 