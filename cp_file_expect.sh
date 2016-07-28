#!/usr/bin/expect
########################


set fileName [ lindex $argv 0 ] 
# will transport filename
set ip [ lindex $argv 1 ]
set user root
set password xiaomi9ijn0okm
set coverFile [ lindex $argv 2 ]
set backUpcoverFile [ lindex $argv 3 ]


set remote_host_dir /home/work/env-oc/hosts_bak
#set src_host_dir /home/jenkins/.jenkins/workspace

set src_host_dir /home/jenkins/env-wms/cover_file


spawn scp $src_host_dir/$fileName $user@$ip:$remote_host_dir/$fileName
expect {
        "(yes/no)?" {
                send "yes\r"
                expect "password:"
                send "$password\r"
                send "exit\r"
        }
        "password:" {
                send "$password\r"
                send "exit\r"
        }
}
expect eof

spawn ssh $user@$ip
expect {
        "(yes/no)?" {
                send "yes\r"
                expect "password:"
                send "$password\r"
                expect "\#*"
                send "bash /home/work/env-oc/cp_file.sh $remote_host_dir/$fileName $coverFile $backUpcoverFile/$fileName\r"
                send "exit\r"
        }
        "password:" {
                send "$password\r"
                expect "\#*"
                send "bash /home/work/env-oc/cp_file.sh $remote_host_dir/$fileName $coverFile $backUpcoverFile/$fileName\r"
                send "exit\r"
        }
}
expect eof


