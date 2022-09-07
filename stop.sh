#!/usr/bin/expect
set timeout 20
set ip 127.0.0.1
set port 12112


spawn telnet $ip $port
expect "'^]'."
sleep .1

#game全部
send "stop.stop\n"
expect "ok"
exit



