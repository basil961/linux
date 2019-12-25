# Отчет по лабораторной работе 3

## Посмотрим какие дисковые устройства и партиции есть в системе

### lsblk

```bash
sda      8:0    0  40G  0 disk
└─sda1   8:1    0  40G  0 part /

```

### blkid

```bash
/dev/sda1: UUID="8ac075e3-1124-4bb6-bef7-a6811bf8b870" TYPE="xfs"
```

### fdisk -l

```bash
Disk /dev/sda: 42.9 GB, 42949672960 bytes, 83886080 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0009ef88

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048    83886079    41942016   83  Linux
```

### parted -l

```bash
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sda: 42.9GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  42.9GB  42.9GB  primary  xfs          boot

```

* Какой размер дисков?
  * 40 GB (41921540 bytes)
* Есть ли неразмеченное место на дисках?
  * Нет
* Какой размер партиций?

```bash
/dev/sda1   *        2048    83886079    41942016   83  Linux
```

* Какая таблица партционирования используется?
  * msdos
* Какой диск, партция или лвм том смонтированы в /
    *sda1

## Создадим сжатую файловую систему для чтения squashfs

### mksquash mai/* mai.sqsh

```bash
Parallel mksquashfs: Using 1 processor
Creating 4.0 filesystem on mai.sqsh, block size 131072.
[===============================================================================================================================================|] 27/27 100%

Exportable Squashfs 4.0 filesystem, gzip compressed, data block size 131072
        compressed data, compressed metadata, compressed fragments, compressed xattrs
        duplicates are removed
Filesystem size 50.94 Kbytes (0.05 Mbytes)
        64.88% of uncompressed filesystem size (78.51 Kbytes)
Inode table size 385 bytes (0.38 Kbytes)
        22.36% of uncompressed inode table size (1722 bytes)
Directory table size 379 bytes (0.37 Kbytes)
        65.12% of uncompressed directory table size (582 bytes)
Xattr table size 54 bytes (0.05 Kbytes)
        100.00% of uncompressed xattr table size (54 bytes)
Number of duplicate files found 1
Number of inodes 32
Number of files 28
Number of fragments 1
Number of symbolic links  0
Number of device nodes 0
Number of fifo nodes 0
Number of socket nodes 0
Number of directories 4
Number of ids (unique uids + gids) 1
Number of uids 1
        root (0)
Number of gids 1
        root (0)
```

### После монтирования сжатой файловой системы mai.squash в директорию /mnt/mai

#### df -h

```bash
/dev/sda1        40G  3.3G   37G   9% /
devtmpfs        488M     0  488M   0% /dev
tmpfs           496M     0  496M   0% /dev/shm
tmpfs           496M  6.7M  489M   2% /run
tmpfs           496M     0  496M   0% /sys/fs/cgroup
tmpfs           100M     0  100M   0% /run/user/1000
/dev/loop0      128K  128K     0 100% /mnt/mai
```

#### df -i

```bash
/dev/sda1      20971008 36760 20934248    1% /
devtmpfs         124867   309   124558    1% /dev
tmpfs            126871     1   126870    1% /dev/shm
tmpfs            126871   381   126490    1% /run
tmpfs            126871    16   126855    1% /sys/fs/cgroup
tmpfs            126871     1   126870    1% /run/user/1000
/dev/loop0           32    32        0  100% /mnt/mai
```

#### mount

```bash
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
devtmpfs on /dev type devtmpfs (rw,nosuid,seclabel,size=499468k,nr_inodes=124867,mode=755)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,seclabel)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,seclabel,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,seclabel,mode=755)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,seclabel,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,cpuacct,cpu)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,freezer)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,devices)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,net_prio,net_cls)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,hugetlb)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,pids)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,perf_event)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,blkio)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,cpuset)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,memory)
configfs on /sys/kernel/config type configfs (rw,relatime)
/dev/sda1 on / type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
selinuxfs on /sys/fs/selinux type selinuxfs (rw,relatime)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=24,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=13390)
mqueue on /dev/mqueue type mqueue (rw,relatime,seclabel)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime,seclabel)
debugfs on /sys/kernel/debug type debugfs (rw,relatime)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
tmpfs on /run/user/1000 type tmpfs (rw,nosuid,nodev,relatime,seclabel,size=101500k,mode=700,uid=1000,gid=1000)
/home/vagrant/mai.sqsh on /mnt/mai type squashfs (ro,relatime,seclabel)
```

* Какая файловая система примонтирована в /
  * sda1
* С какими опциями примонтирована файловая система в /
  * type - xfs, rw,relatime,seclabel,attr2,inode64,noquota
* Какой размер файловой системы приментированной в /mnt/mai
  * 128K

## Попробуем создать файлик в каталоге /dev/shm

### dd if=/dev/zero of=/dev/shm/mai bs=1M count=100

```bash
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 0.0303084 s, 3.5 GB/s
```

### free -h

```bash
             total        used        free      shared  buff/cache   available
Mem:           991M         83M        125M        106M        782M        602M
Swap:          2.0G          0B        2.0G
```

### free -h после rm -f /dev/shm/mai

```bash
              total        used        free      shared  buff/cache   available
Mem:           991M         83M        225M        6.7M        682M        703M
Swap:          2.0G          0B        2.0G
```

* Что такое tmpfs
  * Временное файловое хранилище для монтирования файловых систем, размещаемых в ОЗУ
* Какая часть памяти изменялась?
  * Свободная

## Изучим процессы запущенные в системе

### ps -eF

```bash
UID        PID  PPID  C    SZ   RSS PSR STIME TTY          TIME CMD
root         1     0  0 32025  6672   0 08:15 ?        00:00:01 /usr/lib/systemd/systemd --switched-root --system --deserialize 21
root         2     0  0     0     0   0 08:15 ?        00:00:00 [kthreadd]
root         3     2  0     0     0   0 08:15 ?        00:00:00 [ksoftirqd/0]
root         5     2  0     0     0   0 08:15 ?        00:00:00 [kworker/0:0H]
root         6     2  0     0     0   0 08:15 ?        00:00:00 [kworker/u2:0]
root         7     2  0     0     0   0 08:15 ?        00:00:00 [migration/0]
...
postfix  28046  2545  0 22440  4044   0 09:55 ?        00:00:00 pickup -l -t unix -u
root     28050  4750  0 25711  5500   0 09:59 ?        00:00:00 /sbin/dhclient -d -q -sf /usr/libexec/nm-dhcp-helper -pf /var/run/dhclient-eth0.pid -lf /var/l
root     28174  2397  0 38665  5556   0 10:00 ?        00:00:00 sshd: vagrant [priv]
vagrant  28177 28174  0 38665  2424   0 10:00 ?        00:00:00 sshd: vagrant@pts/0
vagrant  28178 28177  0 29092  3032   0 10:00 pts/0    00:00:00 -bash
root     28238 28178  0 47976  2392   0 10:02 pts/0    00:00:00 su
root     28242 28238  0 29098  3052   0 10:02 pts/0    00:00:00 bash
root     28295     2  0     0     0   0 10:27 ?        00:00:00 [kworker/0:2]
root     28317     2  0     0     0   0 10:30 ?        00:00:00 [loop0]
root     28349     2  0     0     0   0 10:53 ?        00:00:00 [kworker/0:1]
root     28366     2  0     0     0   0 11:01 ?        00:00:00 [kworker/0:0]
root     28367 28242  0 38841  1856   0 11:01 pts/0    00:00:00 ps -eF
```

### ps rx

```bash
  PID TTY      STAT   TIME COMMAND
    9 ?        R      0:00 [rcu_sched]
28366 ?        R      0:00 [kworker/0:0]
28368 pts/0    R+     0:00 ps rx
```

### ps -e --forest

```bash
...
 2393 ?        00:00:01 tuned
 2395 ?        00:00:00 rsyslogd
 2397 ?        00:00:00 sshd
28174 ?        00:00:00  \_ sshd
28177 ?        00:00:00      \_ sshd
28178 pts/0    00:00:00          \_ bash
28238 pts/0    00:00:00              \_ su
28242 pts/0    00:00:00                  \_ bash
28369 pts/0    00:00:00                      \_ ps
 2545 ?        00:00:00 master
 2554 ?        00:00:00  \_ qmgr
28046 ?        00:00:00  \_ pickup
 4750 ?        00:00:00 NetworkManager
28050 ?        00:00:00  \_ dhclient
 5607 ?        00:00:00 crond
 5715 ?        00:00:00 lvmetad
 5870 ?        00:00:00 auditd
```

### ps -efL

```bash
UID        PID  PPID   LWP  C NLWP STIME TTY          TIME CMD
root         1     0     1  0    1 08:15 ?        00:00:01 /usr/lib/systemd/systemd --switched-root --system --deserialize 21
root         2     0     2  0    1 08:15 ?        00:00:00 [kthreadd]
root         3     2     3  0    1 08:15 ?        00:00:00 [ksoftirqd/0]
root         5     2     5  0    1 08:15 ?        00:00:00 [kworker/0:0H]
root         6     2     6  0    1 08:15 ?        00:00:00 [kworker/u2:0]
root         7     2     7  0    1 08:15 ?        00:00:00 [migration/0]
root         8     2     8  0    1 08:15 ?        00:00:00 [rcu_bh]
root         9     2     9  0    1 08:15 ?        00:00:00 [rcu_sched]
root        10     2    10  0    1 08:15 ?        00:00:00 [lru-add-drain]
...
```

* Какие процессы в системе порождают дочерние процессы через fork
  * Обычные процессы
* Какие процессы в системе являются мультитредовыми
  * Несколько одинаковых процессов с одним pid но с разными lwp, имеют общую память и процессорное время, в отличие от форкнутых

### ps axo rss | tail -n +2 | paste -sd+ | bc

* Что подсчитывается этой командой
  * ps axo rss показывает сколько памяти в КБ "ест" процесс. tail -n +2 показывает первые 2 строки. paste -sd+ мерджит два файла с разделителями TAB. bc - утилита-калькулятор. В итоге команда дает число 113820

* Почему цифра такая странная
  * Сумма всех кбайт, потребляемых процессами

## Уставновим утилиту smem и проанализируем параметр PSS в ней

### smem

```bash
 PID User     Command                         Swap      USS      PSS      RSS
 1546 root     /sbin/agetty --noclear tty1        0      176      233      868
 5870 root     /sbin/auditd                       0      540      602     1088
 1282 rpc      /sbin/rpcbind -w                   0      588      632     1268
 1317 root     /usr/sbin/gssproxy -D              0      732      788     1420
 5607 root     /usr/sbin/crond -n                 0      688      805     1680
 1331 chrony   /usr/sbin/chronyd                  0      764      864     1816
 1407 root     /usr/lib/systemd/systemd-lo        0      792      864     1732
28625 root     su                                 0      636     1007     2400
28594 vagrant  sshd: vagrant@pts/0                0      320     1103     2428
 2545 root     /usr/libexec/postfix/master        0     1144     1236     2152
 1261 dbus     /usr/bin/dbus-daemon --syst        0     1000     1287     2728
 1051 root     /usr/lib/systemd/systemd-jo        0      828     1449     2896
 2397 root     /usr/sbin/sshd -D -u0              0     1028     1604     4336
 2554 postfix  qmgr -l -t unix -u                 0     1228     1744     4124
28651 postfix  pickup -l -t unix -u               0     1208     1768     4068
28595 vagrant  -bash                              0     1348     1859     3024
28629 root     bash                               0     1372     1881     3040
28591 root     sshd: vagrant [priv]               0      532     1959     5552
 2395 root     /usr/sbin/rsyslogd -n              0     1580     2225     3852
 5715 root     /usr/sbin/lvmetad -f               0     1672     2276     4152
 1092 root     /usr/lib/systemd/systemd-ud        0     2376     2972     4928
28506 root     /sbin/dhclient -d -q -sf /u        0     2972     3338     5504
    1 root     /usr/lib/systemd/systemd --        0     3936     4591     6672
 4750 root     /usr/sbin/NetworkManager --        0     4692     5805     9200
29000 root     python /usr/bin/smem               0     5672     6430     7872
 1241 polkitd  /usr/lib/polkit-1/polkitd -        0     9652    10697    13312
 2393 root     /usr/bin/python2 -Es /usr/s        0    12524    13924    17416
```

### Запускаем скрипт

```python
import os, time
import sys

print('Hello! I am an example')
pid = os.fork()
print('pid of my child is %s' % pid)
if pid == 0:
    print('I am a child. Im going to sleep')
    for i in range(1,40):
      print('mrrrrr')
      a = 2**i
      print(a)
      pid = os.fork()
      if pid == 0:
            print('my name is %s' % a)
            sys.exit(0)
      else:
            print("my child pid is %s" % pid)
      time.sleep(1)
    print('Bye')
    sys.exit(0)

else:
    for i in range(1, 200):
      print('HHHrrrrr')

      time.sleep(1)
      print(3**i)
      #pid, status = os.waitpid(pid, 0)
      #print("wait returned, pid = %d, status = %d" % (pid, status))

    print('I am the parent')

```

### Снова smem

```bash
 PID User     Command                         Swap      USS      PSS      RSS
 1546 root     /sbin/agetty --noclear tty1        0      176      233      868
 5870 root     /sbin/auditd                       0      540      584     1088
 1282 rpc      /sbin/rpcbind -w                   0      588      630     1268
 5607 root     /usr/sbin/crond -n                 0      688      778     1680
 1317 root     /usr/sbin/gssproxy -D              0      732      788     1420
 1407 root     /usr/lib/systemd/systemd-lo        0      792      863     1732
 1331 chrony   /usr/sbin/chronyd                  0      764      864     1816
28625 root     su                                 0      636      888     2400
29004 vagrant  sshd: vagrant@pts/1                0      220      949     2400
28594 vagrant  sshd: vagrant@pts/0                0      244      974     2428
 2545 root     /usr/libexec/postfix/master        0     1144     1234     2152
 1261 dbus     /usr/bin/dbus-daemon --syst        0     1000     1284     2728
 1051 root     /usr/lib/systemd/systemd-jo        0      828     1450     2900
 2397 root     /usr/sbin/sshd -D -u0              0     1028     1480     4336
28591 root     sshd: vagrant [priv]               0      212     1533     5552
29001 root     sshd: vagrant [priv]               0      212     1533     5552
28595 vagrant  -bash                              0     1344     1693     3024
28651 postfix  pickup -l -t unix -u               0     1208     1709     4068
28629 root     bash                               0     1368     1716     3040
 2554 postfix  qmgr -l -t unix -u                 0     1228     1722     4124
29005 vagrant  -bash                              0     1548     1902     3248
 2395 root     /usr/sbin/rsyslogd -n              0     1580     2226     3856
 5715 root     /usr/sbin/lvmetad -f               0     1672     2251     4152
 1092 root     /usr/lib/systemd/systemd-ud        0     2376     2971     4928
29040 vagrant  python myfork.py                   0     2608     3071     4660
28506 root     /sbin/dhclient -d -q -sf /u        0     2972     3272     5504
    1 root     /usr/lib/systemd/systemd --        0     3936     4589     6672
 4750 root     /usr/sbin/NetworkManager --        0     4692     5780     9200
29083 root     python /usr/bin/smem               0     5668     6207     7876
 1241 polkitd  /usr/lib/polkit-1/polkitd -        0     9652    10694    13312
 2393 root     /usr/bin/python2 -Es /usr/s        0    12520    13702    17416
```

#### Порождение процессов

```bash
vagrant  29004 29001 29004  0    1 13:37 ?        00:00:00 sshd: vagrant@pts/1
vagrant  29005 29004 29005  0    1 13:37 pts/1    00:00:00 -bash
vagrant  29085 29005 29085  0    1 13:41 pts/1    00:00:00 python myfork.py
vagrant  29086 29085 29086  0    1 13:41 pts/1    00:00:00 python myfork.py
vagrant  29087 29086 29087  0    1 13:41 pts/1    00:00:00 [python] <defunct>
vagrant  29088 29086 29088  0    1 13:41 pts/1    00:00:00 [python] <defunct>
vagrant  29089 29086 29089  0    1 13:41 pts/1    00:00:00 [python] <defunct>
vagrant  29090 29086 29090  0    1 13:41 pts/1    00:00:00 [python] <defunct>
vagrant  29091 29086 29091  0    1 13:41 pts/1    00:00:00 [python] <defunct>
vagrant  29093 29086 29093  0    1 13:41 pts/1    00:00:00 [python] <defunct>
vagrant  29094 29086 29094  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29095 29086 29095  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29097 29086 29097  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29098 29086 29098  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29099 29086 29099  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29101 29086 29101  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29102 29086 29102  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29103 29086 29103  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29104 29086 29104  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29105 29086 29105  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29106 29086 29106  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29107 29086 29107  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29108 29086 29108  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29109 29086 29109  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29111 29086 29111  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29112 29086 29112  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29113 29086 29113  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29114 29086 29114  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29115 29086 29115  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29116 29086 29116  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29117 29086 29117  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29119 29086 29119  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29120 29086 29120  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29121 29086 29121  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29122 29086 29122  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29124 29086 29124  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29125 29086 29125  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29126 29086 29126  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29128 29086 29128  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29129 29086 29129  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29130 29086 29130  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29131 29086 29131  0    1 13:42 pts/1    00:00:00 [python] <defunct>
vagrant  29132 29086 29132  1    1 13:42 pts/1    00:00:00 [python] <defunct>
```

#### Состояния процессов

```bash
29135 pts/1    S+     0:00 python myfork.py
29136 pts/1    S+     0:00 python myfork.py
29137 pts/1    Z+     0:00 [python] <defunct>
29138 pts/1    Z+     0:00 [python] <defunct>
29139 pts/1    Z+     0:00 [python] <defunct>
29140 pts/1    Z+     0:00 [python] <defunct>
29141 pts/1    Z+     0:00 [python] <defunct>
29142 pts/1    Z+     0:00 [python] <defunct>
29143 pts/1    Z+     0:00 [python] <defunct>
29144 pts/1    Z+     0:00 [python] <defunct>
29145 pts/1    Z+     0:00 [python] <defunct>
```

* В другом терминале  отследите порождение процессов
  * Выше список
* Отследите какие состояния вы видите у процессов
  * Выше список
* Почему появляются процессы со статусам Z
  * Это процесс-зомби, у которого нет родителя
* Какой PID у основного процесса
  * 29180
* Убейте основной процесс ```bash kill -9 <pid>```
  * Killed в окне с запущенным процессом.
* Какой PPID стал у первого чайлда
  * 29181
* насколько вы разобрались в скрипте и втом что он делает?
  * Запускает основной процесс, потом запускает дочерний процесс. Если его PID - 0, то это дочерний процесс. Иначе же - это сам процесс.

## Научимся корректно завершать зомби процессы

```bash
vagrant  29446 29445 29446  0    1 16:22 pts/1    00:00:00 [python] <defunct>
```

После раскомментирования строк:

```bash
my child pid is 29548
my name is 549755813888
Bye

[vagrant@centos7-vm lab-processes]$
```

## Научимся убивать зомби процессы

```gdb
(gdb) attach 29777
Attaching to process 29777
Reading symbols from /usr/bin/python2.7...Reading symbols from /usr/bin/python2.7...(no debugging symbols found)...done.
(no debugging symbols found)...done.
...

(gdb) call waitpid(29808, 0, 0)
$1 = 29808

(gdb) call waitpid(29808, 0, 0)
$2 = -1

(gdb) detach
Detaching from program: /usr/bin/python2.7, process 29777

(gdb) quit
[[basil@basil@centos7-vm ] vagrant]#
```

## Проблемы при отмонтировании директории

```bash
[vagrant@centos7-vm lab-processes]$ umount /mnt/mai
umount: /mnt/mai: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))

[[basil@basil@centos7-vm ] mai]\# fuser -v /mnt/mai
                     USER        PID ACCESS COMMAND
/mnt/mai:            root     kernel mount /mnt/mai
                     vagrant   29372 ..c.. bash
```

* Какие процессы мешают размонтировать директорию
  * root      29372 ..c.. bash
  * root     kernel mount /mnt/mai
* Посмотреть ```lsof -p <PID>```

```bash
[[basil@basil@centos7-vm ] mai]\# lsof -p 28629
COMMAND   PID    USER   FD   TYPE DEVICE  SIZE/OFF      NODE NAME
bash    29372 vagrant  cwd    DIR    7,0       155        32 /mnt/mai
bash    29372 vagrant  rtd    DIR    8,1       255        64 /
bash    29372 vagrant  txt    REG    8,1    964608 100737157 /usr/bin/bash
bash    29372 vagrant  mem    REG    8,1 106075056  67395449 /usr/lib/locale/locale-archive
bash    29372 vagrant  mem    REG    8,1     61624    556830 /usr/lib64/libnss_files-2.17.so
bash    29372 vagrant  mem    REG    8,1   2156160     11299 /usr/lib64/libc-2.17.so
bash    29372 vagrant  mem    REG    8,1     19288    141652 /usr/lib64/libdl-2.17.so
bash    29372 vagrant  mem    REG    8,1    174576     11704 /usr/lib64/libtinfo.so.5.9
bash    29372 vagrant  mem    REG    8,1    163400   4823742 /usr/lib64/ld-2.17.so
bash    29372 vagrant  mem    REG    8,1     26254     11619 /usr/lib64/gconv/gconv-modules.cache
bash    29372 vagrant    0u   CHR  136,1       0t0         4 /dev/pts/1
bash    29372 vagrant    1u   CHR  136,1       0t0         4 /dev/pts/1
bash    29372 vagrant    2u   CHR  136,1       0t0         4 /dev/pts/1
bash    29372 vagrant  255u   CHR  136,1       0t0         4 /dev/pts/1
```

* Убить мешающий процесс и размонтировать директорию

```bash
[[basil@basil@centos7-vm ] ~]\# kill -9 29372
[[basil@basil@centos7-vm ] ~]\# umount /mnt/mai
```

## Решаем загадку исчезновения места на диске

```bash
[[basil@basil@centos7-vm ] myfiles]\# mkdir myfiles
[[basil@basil@centos7-vm ] myfiles]\# ls -l
total 1048516
-rw-r--r--. 1 root root 789991424 Nov 14 17:12 myfile
-rw-r--r--. 1 root root        84 Nov 14 17:04 test_write.py
[[basil@basil@centos7-vm ] myfiles]\# ls -l
total 1048516
-rw-r--r--. 1 root root 919154688 Nov 14 17:12 myfile
-rw-r--r--. 1 root root        84 Nov 14 17:04 test_write.py
[[basil@basil@centos7-vm ] myfiles]\# ls -l
total 1048516
-rw-r--r--. 1 root root 1026228224 Nov 14 17:12 myfile
-rw-r--r--. 1 root root         84 Nov 14 17:04 test_write.py
^Z
[3]+  Stopped                 python test_write.py
[[basil@basil@centos7-vm ] myfiles]\# ls -l
total 1048516
-rw-r--r--. 1 root root 854614016 Nov 14 17:07 myfile
[[basil@basil@centos7-vm ] myfiles]\# test myfile
[[basil@basil@centos7-vm ] myfiles]\# jobs -l
[[basil@basil@centos7-vm ] myfiles]\# fg
bash: fg: current: no such job
^Z
[4]+  Stopped                 python test_write.py
[[basil@basil@centos7-vm ] myfiles]\# bg
bash: bg: current: no such job
[[basil@basil@centos7-vm ] myfiles]\# df
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/sda1       41921540 7760892  34160648  19% /
devtmpfs          499468       0    499468   0% /dev
tmpfs             507484       0    507484   0% /dev/shm
tmpfs             507484    6848    500636   2% /run
tmpfs             507484       0    507484   0% /sys/fs/cgroup
tmpfs             101500       0    101500   0% /run/user/1000
[[basil@basil@centos7-vm ] myfiles]\# du ~/myfiles
524228  /root/myfiles
[[basil@basil@centos7-vm ] myfiles]\# rm myfile
[[basil@basil@centos7-vm ] myfiles]\# df
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/sda1       41921540 6190644  35730896  15% /
devtmpfs          499468       0    499468   0% /dev
tmpfs             507484       0    507484   0% /dev/shm
tmpfs             507484    6848    500636   2% /run
tmpfs             507484       0    507484   0% /sys/fs/cgroup
tmpfs             101500       0    101500   0% /run/user/1000
[[basil@basil@centos7-vm ] myfiles]\# du sh ~/myfiles
du: cannot access ‘sh’: No such file or directory
524228  /root/myfiles
[[basil@basil@centos7-vm ] myfiles]\#
```

* Ситуация следующая - файл не удалился, потому что процесс был перемещен на задний фон и приостановлен, но не завершен. Файл находится все еще в используемом состоянии, процесс заснул.

```bash
[[basil@basil@centos7-vm ] myfiles]\# strace -p 30193
strace: Process 30193 attached
--- stopped by SIGTSTP ---
[[basil@basil@centos7-vm ] myfiles]\# lsof -p 30193
COMMAND   PID USER   FD   TYPE DEVICE   SIZE/OFF      NODE NAME
python  30193 root  cwd    DIR    8,1         41  67456820 /root/myfiles
python  30193 root  rtd    DIR    8,1        255        64 /
python  30193 root  txt    REG    8,1       7216 100738379 /usr/bin/python2.7
python  30193 root  mem    REG    8,1  106075056  67395449 /usr/lib/locale/locale-archive
python  30193 root  mem    REG    8,1    2156160     11299 /usr/lib64/libc-2.17.so
python  30193 root  mem    REG    8,1    1137024    141655 /usr/lib64/libm-2.17.so
python  30193 root  mem    REG    8,1      14496     11332 /usr/lib64/libutil-2.17.so
python  30193 root  mem    REG    8,1      19288    141652 /usr/lib64/libdl-2.17.so
python  30193 root  mem    REG    8,1     142232     11321 /usr/lib64/libpthread-2.17.so
python  30193 root  mem    REG    8,1    1847496     21194 /usr/lib64/libpython2.7.so.1.0
python  30193 root  mem    REG    8,1     163400   4823742 /usr/lib64/ld-2.17.so
python  30193 root    0u   CHR  136,0        0t0         3 /dev/pts/0
python  30193 root    1u   CHR  136,0        0t0         3 /dev/pts/0
python  30193 root    2u   CHR  136,0        0t0         3 /dev/pts/0
python  30193 root    3w   REG    8,1 2150162432  67456823 /root/myfiles/myfile (deleted)
python  30193 root    4r   CHR    1,9        0t0      5339 /dev/urandom
[[basil@basil@centos7-vm ] myfiles]\# kill -9 30193
[[basil@basil@centos7-vm ] myfiles]\# df
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/sda1       41921540 3568636  38352904   9% /
devtmpfs          499468       0    499468   0% /dev
tmpfs             507484       0    507484   0% /dev/shm
tmpfs             507484    6816    500668   2% /run
tmpfs             507484       0    507484   0% /sys/fs/cgroup
tmpfs             101500       0    101500   0% /run/user/1000
[[basil@basil@centos7-vm ] myfiles]\# du sh ~/myfiles
du: cannot access ‘sh’: No such file or directory
4       /root/myfiles
```

* Объяснение происходящего
  * Завершися процесс, который писал в файл и был поставлен на паузу. Закрылся файловый дескриптор и теперь файл спокойно удалился.

## Утилиты наблюдения

```bash
 Load average: 0.00 0.04 0.12
```

### Топ 3 загрузки CPU

```bash
30421 root       20   0  119M  2504  1512 R  0.0  0.2  0:00.18 htop                                                                            2626 root       20   0  462M 15760  4508 S  0.0  1.6  0:04.48 /usr/bin/python2 -Es /usr/sbin/tuned -l -P                                       1 root       20   0  125M  4720  2180 S  0.0  0.5  0:01.61 /usr/lib/systemd/systemd --switched-root --system --deserialize 21
```

### Топ 3 загрузки памяти

```bash
2393 root       20   0  462M 15760  4508 S  0.0  1.6  0:04.93 /usr/bin/python2 -Es /usr/sbin/tuned -l -P                                       2626 root       20   0  462M 15760  4508 S  0.0  1.6  0:04.48 /usr/bin/python2 -Es /usr/sbin/tuned -l -P                                       2641 root       20   0  462M 15760  4508 S  0.0  1.6  0:00.00 /usr/bin/python2 -Es /usr/sbin/tuned -l -P
```

### atop через systemd

#### Описание сервиса

```bash
[Unit] Description=AtopService

[Service]
Type=simple
User=root
WorkingDirectory=/bin
ExecStart=/bin/atop
```

#### Запуск сервиса

```bash
[[basil@basil@centos7-vm ] system]# systemctl load atops.service
Unknown operation 'load'.
[[basil@basil@centos7-vm ] system]# systemctl enable atops.service
Failed to execute operation: Bad message
[[basil@basil@centos7-vm ] system]# vim atops.service
[[basil@basil@centos7-vm ] system]# systemctl status atops.service
● atops.service - AtopService
   Loaded: loaded (/etc/systemd/system/atops.service; static; vendor preset: disabled)
   Active: inactive (dead)

Nov 14 18:02:21 centos7-vm systemd[1]: [/etc/systemd/system/atops.service:1] Invalid section header '[Unit] Description=AtopService'
Nov 14 18:05:33 centos7-vm systemd[1]: [/usr/lib/systemd/system/atops.service:1] Invalid section header '[Unit] Description=AtopService'
Nov 14 18:06:32 centos7-vm systemd[1]: [/etc/systemd/system/atops.service:1] Invalid section header '[Unit] Description=AtopService'
Nov 14 18:06:51 centos7-vm systemd[1]: [/etc/systemd/system/atops.service:1] Invalid section header '[Unit] Description=AtopService'
[[basil@basil@centos7-vm ] system]# systemctl enable atops.service
[[basil@basil@centos7-vm ] system]# systemctl start atops.service
[[basil@basil@centos7-vm ] system]# systemctl status atops.service
● atops.service - AtopService
   Loaded: loaded (/etc/systemd/system/atops.service; static; vendor preset: disabled)
   Active: active (running) since Thu 2019-11-14 18:07:26 UTC; 6s ago
 Main PID: 30821 (atop)
   CGroup: /system.slice/atops.service
           └─30821 /bin/atop

Nov 14 18:07:26 centos7-vm atop[30821]: 985  0.00s  0.00s     0K     0K     0K     0K    1 S     0   0% xfs_mru_cache
Nov 14 18:07:26 centos7-vm atop[30821]: 990  0.00s  0.00s     0K     0K     0K     0K    1 S     0   0% xfs-buf/sda1
Nov 14 18:07:26 centos7-vm atop[30821]: 991  0.00s  0.00s     0K     0K     0K     0K    1 S     0   0% xfs-data/sda1
Nov 14 18:07:26 centos7-vm atop[30821]: 994  0.00s  0.00s     0K     0K     0K     0K    1 S     0   0% xfs-conv/sda1
Nov 14 18:07:26 centos7-vm atop[30821]: 995  0.00s  0.00s     0K     0K     0K     0K    1 S     0   0% xfs-cil/sda1
Nov 14 18:07:26 centos7-vm atop[30821]: 996  0.00s  0.00s     0K     0K     0K     0K    1 S     0   0% xfs-reclaim/sd
Nov 14 18:07:26 centos7-vm atop[30821]: 997  0.00s  0.00s     0K     0K     0K     0K    1 S     0   0% xfs-log/sda1
Nov 14 18:07:26 centos7-vm atop[30821]: 998  0.00s  0.00s     0K     0K     0K     0K    1 S     0   0% xfs-eofblocks/
Nov 14 18:07:26 centos7-vm atop[30821]: 1109  0.00s  0.00s     0K     0K     0K     0K    1 S     0   0% rpciod
Nov 14 18:07:26 centos7-vm atop[30821]: 1111  0.00s  0.00s     0K     0K     0K     0K    1 S     0   0% xprtiod
```

### Запустить dd на генерацию файла на 3 GB

```bash
dd of=file bs=1 count=0 seek=3G
```

### удалите сгенеренный файл

```bash
2395

```
