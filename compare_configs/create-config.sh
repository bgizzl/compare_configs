#!bin/sh

HOST=`hostname | cut -d "." -f1`

{
echo "START"
echo ""

echo "### OS $HOST ###"
ls -l /etc/redhat-release
cat /etc/redhat-release
echo ""

echo "### Kernel $HOST ###"
uname -a
echo ""

echo "### File System (df -h / fstab) $HOST ###"
df -h
ls -l /etc/fstab
cat /etc/fstab
echo ""

echo "### Disk $HOST ###"
echo ""
echo "--- fdisk /dev/sda -l ---"
fdisk /dev/sda -l
echo ""
echo "--- fdisk /dev/vda -l ---"
fdisk /dev/vda -l
echo ""

echo "### Memory $HOST ###"
echo ""
echo "--- Memory Size (Total) ---"
ls -l /proc/meminfo
cat /proc/meminfo | head -1
echo ""
echo "--- All Memory INFO ---"
cat /proc/meminfo
echo ""

echo "### CPU $HOST ###"
echo ""
echo "--- CPU Model ---"
ls -l /proc/cpuinfo
cat /proc/cpuinfo | grep "model name" | head -1
echo ""
echo "--- CPU Physical Count ---"
grep "physical id" /proc/cpuinfo | sort | uniq | wc -l
echo ""
echo "--- CPU Processor Count ---"
grep "processor" /proc/cpuinfo | wc -l
echo ""
echo "--- CPU Core Count ---"
grep "cpu cores" /proc/cpuinfo | head -1 | awk '{print $4}'
echo ""
echo "--- All CPU INFO ---"
cat /proc/cpuinfo
echo ""

echo "### HostName $HOST ###"
echo ""
echo "--- hostname (uname / /etc/hostname) ---"
ls -l /etc/hostname
uname
cat /etc/hostname
echo ""
echo "--- hostname -i ---"
hostname -i
echo ""
echo "--- hostnamectl ---"
hostnamectl
echo ""

echo "### Account $HOST ###"
echo ""
echo "--- passwd ---"
ls -l /etc/passwd
cat /etc/passwd | grep -v '^+'
echo ""
echo "--- group ---"
ls -l /etc/group
cat /etc/group | grep -v '^+'
echo ""

echo "### Network (ip address / ip route) $HOST ###"
ip a
echo ""
ip r
echo ""

echo "### Interface $HOST ###"
echo ""
echo "--- Device SUMMARY (nmcli d s /nmcli device show) ---"
nmcli d s
echo ""
nmcli device show
echo ""
echo "--- Connection SUMMARY ---"
nmcli c s
echo ""
echo "--- Connection INFO eth0 ---"
nmcli c s eth0
echo ""
echo "--- Connection INFO eth1 ---"
nmcli c s eth1
echo ""
echo "--- Connection INFO eth2 ---"
nmcli c s eth2
echo ""
echo "--- Connection INFO eth3 ---"
nmcli c s eth3
echo ""

echo "### Timedate $HOST ###"
timedatectl
echo ""

echo "### Locale $HOST ###"
localectl status
echo ""

echo "### Sudoers $HOST ###"
echo ""
echo "--- Sudoers SUMMARY INFO ---"
ls -l /etc/sudoers
cat /etc/sudoers | grep ^[^#]
echo ""
echo "--- Sudoers ALL INFO ---"
cat /etc/sudoers
echo ""

echo "### sshd $HOST ###"
echo ""
echo "--- sshd SUMMARY INFO ---"
ls -l /etc/ssh/sshd_config
cat /etc/ssh/sshd_config | grep ^[^#]
echo ""
echo "--- sshd ALL INFO ---"
cat /etc/ssh/sshd_config
echo ""

echo "### NTP - ntpq $HOST ###"
ntpq -p
echo ""

echo "### NTP - ntpd $HOST ###"
systemctl is-enabled ntpd
systemctl status -l ntpd
echo ""

echo "### NTP - ntp.conf $HOST ###"
echo ""
echo "--- ntp.conf SUMMARY INFO ---"
ls -l /etc/ntp.conf
cat /etc/ntp.conf | grep ^[^#]
echo ""
echo "--- ntp.conf ALL INFO ---"
cat /etc/ntp.conf
echo ""

echo "### HOSTS /etc/hosts $HOST ###"
ls -l /etc/hosts
cat /etc/hosts
echo ""

echo "### DNS - resolv.conf $HOST ###"
ls -l /etc/resolv.conf
cat /etc/resolv.conf
echo ""

echo "### SELINUX $HOST ###"
getenforce
echo ""

echo "### Services - network.service $HOST ###"
systemctl is-enabled network.service
systemctl status -l network.service
echo ""

echo "### Services - firewalld $HOST ###"
systemctl is-enabled firewalld
systemctl status -l firewalld
echo ""

echo "### Services - enabled $HOST ###"
systemctl list-unit-files --type=service | grep enabled
echo ""

echo "### Services - disabled $HOST ###"
systemctl list-unit-files --type=service | grep disabled
echo ""

echo "### Services - ALL $HOST ###"
systemctl list-unit-files --type=service
echo ""

echo "### chkconfig $HOST ###"
chkconfig --list
echo ""

echo "### firewall $HOST ###"
echo ""
echo "--- firewall(active-zones) ---"
firewall-cmd --get-active-zones
echo ""
echo "--- firewall(zone=ALL) ---"
firewall-cmd --list-all-zone
echo ""

echo "### yum $HOST ###"
echo ""
echo "--- yum repolist enabled ---"
yum repolist enabled
echo ""
echo "--- yum repolist disabled ---"
yum repolist disabled
echo ""
echo "--- yum repolist installed ---"
yum repolist installed
echo ""
echo "--- yum list installed ---"
yum list installed
echo ""

echo "### rpm -qa $HOST ###"
rpm -qa
echo ""

echo "### cron $HOST ###"
ls -l /var/spool/cron/
cat /var/spool/cron/*
echo ""

echo "### /etc/logrotate.d $HOST ###"
ls -l /etc/logrotate.d/
cat /etc/logrotate.d/*
echo ""

echo "END"

} >> /tmp/$HOST-config.txt 2>&1

exit
