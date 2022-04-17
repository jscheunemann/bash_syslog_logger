# bash_syslog_logger

### Options

the syslog_logger function takes the following arguments; facility, severity, message, variable number of either file descriptors or filenames used to write messages

This is the list of possible facility and severity values

~~~
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


STDOUT_LOG_LEVEL=${SYSLOG_SEVERITY_ERROR}
FILE_LOG_LEVEL=${SYSLOG_SEVERITY_DEBUG}
APP_NAME="my_app"
~~~

### Examples
~~~
log_error() {
    syslog_logger ${SYSLOG_FACILITY_USER} ${SYSLOG_SEVERITY_ERROR} "${1}" ${FD_STDERR}
}

log_info() {
    syslog_logger ${SYSLOG_FACILITY_USER} ${SYSLOG_SEVERITY_INFORMATIONAL} "${1}" ${FD_STDOUT}
}

log_debug() {
    syslog_logger ${SYSLOG_FACILITY_USER} ${SYSLOG_SEVERITY_DEBUG} "${1}" ${FD_STDOUT}
}

log_error "This better work, nope error!"
log_info "Here is my info msg"
log_debug "I have some debugging to do"
~~~
