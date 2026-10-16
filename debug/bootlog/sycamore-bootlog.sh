#!/vendor/bin/sh
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Boot debug logger (SYCAMORE_BOOT_DEBUG builds only). Every 3 s for 10 min,
# snapshot the boot state to /metadata/bootlog, keeping only the latest set
# (cur/) and the one before it (prev/), so it can be read from recovery.

PATH=/vendor/bin:/system/bin
D=/metadata/bootlog

mkdir -p $D
rm -rf $D/cur $D/prev $D/new

i=0
while [ $i -lt 200 ]; do
    rm -rf $D/new
    mkdir $D/new

    {
        echo "round $i uptime $(cat /proc/uptime)"
        cat /proc/bootprof
    } > $D/new/bootprof.txt 2>&1
    getprop | grep -E 'init.svc|ready|modules' > $D/new/getprop-svc.txt 2>&1
    getprop > $D/new/getprop.txt 2>&1
    ps -A -o pid,stat,wchan,name > $D/new/ps.txt 2>&1
    dmesg 2>&1 | tail -c 1048576 > $D/new/dmesg.txt
    /system/bin/logcat -b all -d 2>&1 | tail -c 4194304 > $D/new/logcat.txt

    rm -rf $D/prev
    [ -d $D/cur ] && mv $D/cur $D/prev
    mv $D/new $D/cur
    sync

    i=$((i + 1))
    sleep 3
done
