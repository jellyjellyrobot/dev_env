#!/usr/bin/env python

import os
import sys

from time import sleep

default_int = os.popen("netstat -rn | awk '{print $1 \" \" $NF}' | grep 'default\|0.0.0.0' | head -n 1 | awk '{print $2}'").read().split('\n')[0]

sw = sys.argv[1].lower()

if "ip" in sw:
  default_int_ip = os.popen("ifconfig " + default_int + " | grep 'inet ' | awk '{print \"" + default_int + ": \" $2}'").read().split('\n')[0]
  print default_int_ip
elif "speed" in sw:
  speeds = os.popen("ifstat -i " + default_int + " 1 1 2> /dev/null | tail -n 1 | awk '{print $1 \" \" $2}'").read()
  if len(speeds) != 0:
    speeds_KBps = map(float, speeds.split())
  else:
    rxb_0 = int(os.popen("cat /sys/class/net/" + default_int + "/statistics/rx_bytes").read())
    txb_0 = int(os.popen("cat /sys/class/net/" + default_int + "/statistics/tx_bytes").read())
    sleep(0.2)
    rxb_1 = int(os.popen("cat /sys/class/net/" + default_int + "/statistics/rx_bytes").read())
    txb_1 = int(os.popen("cat /sys/class/net/" + default_int + "/statistics/tx_bytes").read())
    speeds_KBps = [ 
      float(rxb_1 - rxb_0)*5/1024,
      float(txb_1 - txb_0)*5/1024
    ]
  print "D: " + "{0:.1f}".format(speeds_KBps[0]) + "K U: " + "{0:.1f}".format(speeds_KBps[1])+"K"
