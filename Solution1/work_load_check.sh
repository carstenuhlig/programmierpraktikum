#:/bin/bash
ssh $1 "cat /proc/loadavg | cut -d ' ' -f1"
