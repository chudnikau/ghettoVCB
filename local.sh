#!/bin/sh ++group=host/vim/vmvisor/boot

# local configuration options

# Note: modify at your own risk!  If you do/use anything in this
# script that is not part of a stable API (relying on files to be in
# specific places, specific tools, specific output, etc) there is a
# possibility you will end up with a broken system after patching or
# upgrading.  Changes are not supported unless under direction of
# VMware support.

# Note: This script will not be run when UEFI secure boot is enabled.

# Дать системе полностью загрузиться
sleep 5

LOG="/tmp/ghetto-init.log"

# Создать каталог
mkdir -p /ghettoVCB
cp /vmfs/volumes/dev_storage/ghettoVCB/* /ghettoVCB

echo "[OK] Files copied" >> "$LOG"

# Права на запуск
chmod +x /ghettoVCB/ghettoVCB.sh
chmod +x /ghettoVCB/ghettoVCB-restore.sh

# Cron-файл
CRON="/var/spool/cron/crontabs/root"

# Разрешить запись
chmod u+w "$CRON"

echo "*/2 * * * * echo \"Start ghettoVCB cron \$(date)\" >> /tmp/ghetto.log" >> "$CRON"
echo "0 3 * * * /ghettoVCB/ghettoVCB.sh -f /ghettoVCB/vms_list.conf -g /ghettoVCB/ghettoVCB.conf -l /vmfs/volumes/raid_a/ghettoVCB.log" >> "$CRON"

# Запретить запись
chmod 444 "$CRON"

echo "[OK] Cron is installed" >> "$LOG"

exit 0
