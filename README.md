# bash_syslog_logger

### Options

the syslog_logger function takes the following arguments; facility, severity, message, variable number of either file descriptors or filenames used to write messages.

These variables can be used to control how the logger outputs messages

~~~
STDOUT_LOG_LEVEL=${SYSLOG_SEVERITY_ERROR}   # Only log messages with a severity of error or greater to stdout/stderr
FILE_LOG_LEVEL=${SYSLOG_SEVERITY_DEBUG}     # Only log messages with a severity of debug or greater to file
SYSLOG_APP_NAME="my_app"                    # Sets the app name supplied to syslog
SYSLOG_SEVERITY_MSG_HEADER="###"            # Overrides severity header
~~~

This is the list of possible facility and severity values, these constants are predefined in the syslog.sh file

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
~~~

### Examples
~~~

# The following uses the user facility to log errors to the STDERR file descriptor
log_error() {
    unset SYSLOG_SEVERITY_MSG_HEADER
    syslog_logger ${SYSLOG_FACILITY_USER} ${SYSLOG_SEVERITY_ERROR} ${SYSLOG_APP_NAME} ${NILVALUE} ${NILVALUE} ${NILVALUE} "${1}" ${FD_STDERR}
}

# The following uses the user facility to log informational messages to the STDOUT file descriptor
log_info() {
    SYSLOG_SEVERITY_MSG_HEADER="###"
    syslog_logger ${SYSLOG_FACILITY_USER} ${SYSLOG_SEVERITY_INFORMATIONAL} ${SYSLOG_APP_NAME} ${NILVALUE} ${NILVALUE} ${NILVALUE} "${1}" ${FD_STDOUT}
}

# The following uses the user facility to log debug messages to the STDOUT file descriptor and to the logger.txt file
log_debug() {
    LOGGER_FILE="logger.txt"
    syslog_logger ${SYSLOG_FACILITY_USER} ${SYSLOG_SEVERITY_DEBUG} ${SYSLOG_APP_NAME} ${NILVALUE} ${NILVALUE} ${NILVALUE} "${1}" ${FD_STDOUT} ${LOGGER_FILE}
}

log_error "This better work, nope error!"
log_info  "Here is my info msg"
log_debug "I have some debugging to do"
~~~
