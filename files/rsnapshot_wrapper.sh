#!/bin/bash

# This script is wrapper for rsnapshot. It logs the reports under
# common path of Apache webserver so you can check the logs there

# notes: rsync has to run with the parameter '--stats'
#        verbose level has to be at least 4

BACKUP_LEVEL=$1
WWWROOT=$2

if [[ "$#" -ne 2 ]]; then
  echo "Illegal number of parameters"
  exit 1
fi

PATH=/bin:/sbin/:/usr/bin:/usr/sbin
RSNAPSHOT_BIN=$(which rsnapshot)
PERL_BIN=$(which perl)

DATE=$(date +"%y-%m-%d_%H:%M:%S")
REPORT_FILE="${WWWROOT}/rsnapshot-report-${BACKUP_LEVEL}-${DATE}.txt"

# create the report directory
if [[ ! -d "${WWWROOT}" ]] ; then
  mkdir -p "${WWWROOT}"
fi

$RSNAPSHOT_BIN $BACKUP_LEVEL 2>&1 |
  $PERL_BIN "/usr/local/bin/rsnapreport.pl" > "${REPORT_FILE}"

# remove empty reports (i.e. generated by weekly backups)
[[ ! -s "${REPORT_FILE}" ]] && rm -f "${REPORT_FILE}"

# remove reports older than 1 year
find ${WWWROOT} -name rsnapshot-report-* -ctime +356 -exec rm {} \;
