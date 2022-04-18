!/usr/bin/env bash

# Parse RFC 5424 messages using \<(?P<PRI>\d+)\>(?P<VERSION>\d+)?\s(?P<YEAR>\d+)-(?P<MONTH>\d+)-(?P<DAY>\d+)T(?P<HOUR>\d+):(?P<MINUTE>\d+):(?P<SECOND>\d+)(?:\.(?P<MILLISECONDS>\d+))?(?P<OFFSET>(?:[\+-]\d+:\d+)|(?:Z))\s(?P<HOSTNAME>(?:-)|(?:[a-zA-Z0-9\-\.]+))\s(?P<APPNAME>(?:-)|\b\w+\b)\s(?P<PROCID>(?:-)|\b\w+\b)\s(?P<MSGID>(?:-)|\b\w+\b)\s(?P<STRUCDATA>(?:-)|\[.*?\])\s(?P<MSG>(?:-)|\b.*)$

# Parse RFC 3164 messages using \<(?P<PRI>\d+)\>(?P<MONTH>[a-zA-Z]{3})\s(?P<DAY>\d+)\s(?P<HOUR>\d+):(?P<MINUTE>\d+):(?P<SECOND>\d+)\s(?P<HOSTNAME>(?:-)|(?:[a-zA-Z0-9\-\.]+))\s(?P<APPNAME>(?:-)|([\S]+))\s(?P<MSG>(?:-)|.*)

# SYSLOG Mode
declare -i SYSLOG_MODE_RFC_5424=1
declare -i SYSLOG_MODE_RFC_3164=2
declare -i SYSLOG_MODE=${SYSLOG_MODE_RFC_5424}

# Default file descriptors
declare -i FD_STDOUT=1
declare -i FD_STDERR=2

# Facility
declare -i SYSLOG_FACILITY_KERN=0
declare -i SYSLOG_FACILITY_USER=1
declare -i SYSLOG_FACILITY_MAIL=2
declare -i SYSLOG_FACILITY_DAEMON=3
declare -i SYSLOG_FACILITY_AUTH=4
declare -i SYSLOG_FACILITY_SYSLOG=5
declare -i SYSLOG_FACILITY_LPR=6
declare -i SYSLOG_FACILITY_NEWS=7
declare -i SYSLOG_FACILITY_UUCP=8
declare -i SYSLOG_FACILITY_CRON=9
declare -i SYSLOG_FACILITY_AUTHPRIV=10
declare -i SYSLOG_FACILITY_FTP=11
declare -i SYSLOG_FACILITY_NTP=12
declare -i SYSLOG_FACILITY_SECURITY=13
declare -i SYSLOG_FACILITY_CONSOLE=14
declare -i SYSLOG_FACILITY_SOLARIS_CRON=15
declare -i SYSLOG_FACILITY_LOCAL0=16
declare -i SYSLOG_FACILITY_LOCAL1=17
declare -i SYSLOG_FACILITY_LOCAL2=18
declare -i SYSLOG_FACILITY_LOCAL3=19
declare -i SYSLOG_FACILITY_LOCAL4=20
declare -i SYSLOG_FACILITY_LOCAL5=21
declare -i SYSLOG_FACILITY_LOCAL6=22
declare -i SYSLOG_FACILITY_LOCAL7=23

# Severity levels
declare -i SYSLOG_SEVERITY_EMGERENCY=0
declare -i SYSLOG_SEVERITY_ALERT=1
declare -i SYSLOG_SEVERITY_CRITICAL=2
declare -i SYSLOG_SEVERITY_ERROR=3
declare -i SYSLOG_SEVERITY_WARNING=4
declare -i SYSLOG_SEVERITY_NOTICE=5
declare -i SYSLOG_SEVERITY_INFORMATIONAL=6
declare -i SYSLOG_SEVERITY_DEBUG=7

# Misc
if [ -z "${STDOUT_LOG_LEVEL}" ]; then
    STDOUT_LOG_LEVEL=${SYSLOG_SEVERITY_ERROR}
fi

if [ -z "${FILE_LOG_LEVEL}" ]; then
    FILE_LOG_LEVEL=${SYSLOG_SEVERITY_DEBUG}
fi

if [ -z "${SYSLOG_APP_NAME}" ]; then
    SYSLOG_APP_NAME="my_app"
fi

NILVALUE="-"
declare -i RFC_5424_VERSION=1

function syslog_logger() {
    declare -i FACILITY=${1}
    shift

    declare -i SEVERITY=${1}
    shift

    TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%S.%6NZ')

    if [ "${SYSLOG_MODE}" -ne "${SYSLOG_MODE_RFC_5424}" ]; then
        TIMESTAMP=$(date '+%b %d %H:%M:%S')
    fi

    HOSTNAME=$(hostname)

    APP_NAME=${1}
    shift

    PROC_ID=${1}
    shift

    MSG_ID=${1}
    shift

    STRUCTURED_DATA=${1}
    shift

    MSG=${1}
    shift

    case ${SEVERITY} in
        ${SEVERITY_EMERGENCY})
            SEVERITY_MSG="Emergency";;
        ${SEVERITY_ALERT})
            SEVERITY_MSG="Alert";;
        ${SEVERITY_CRITICAL})
            SEVERITY_MSG="Critical";;
        ${SEVERITY_ERROR})
            SEVERITY_MSG="Error";;
        ${SEVERITY_WARNING})
            SEVERITY_MSG="Warning";;
        ${SEVERITY_NOTICE})
            SEVERITY_MSG="Notice";;
        ${SEVERITY_INFORMATIONAL})
            SEVERITY_MSG="Info";;
        ${SEVERITY_DEBUG})
            SEVERITY_MSG="Debug";;
        *)
            SEVERITY_MSG="Info";;
    esac

    for i in "${@}"; do
        re='^[0-9]+$'

        if [ "${SYSLOG_MODE}" -eq "${SYSLOG_MODE_RFC_5424}" ]; then
            SYSLOG_MESSAGE="<$((${FACILITY} * 8 + ${SEVERITY}))>${RFC_5424_VERSION} ${TIMESTAMP} ${HOSTNAME} ${APP_NAME} ${PROC_ID} ${MSG_ID} ${STRUCTURED_DATA} ${MSG}"
        else
            SYSLOG_MESSAGE="<$((${FACILITY} * 8 + ${SEVERITY}))>${TIMESTAMP} ${HOSTNAME} ${APP_NAME}: ${MSG}"
        fi
            

        if [[ ${i} =~ ${re} ]]; then
            if [ "${SEVERITY}" -le "${STDOUT_LOG_LEVEL}" ]; then
                echo "${SEVERITY_MSG}: ${MSG}" >&${i}
            fi
        else
            if [ "${SEVERITY}" -le "${FILE_LOG_LEVEL}" ]; then
                echo "${SYSLOG_MESSAGE}" >> ${i}
            fi
        fi
    done
}
