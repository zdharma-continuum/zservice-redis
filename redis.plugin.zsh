#
# A z-service file that runs redis database server.
#
# Use with plugin manager that supports single plugin load per all active Zsh
# sessions.
#
# You should copy `redis.conf.default' to `redis.conf' and adapt it to your
# needs. The service will use the `*.default' file if there is no `*.conf'
# file.

0="${${(M)0##/*}:-${(%):-%N}}"  # filter absolute path, fallback to %N

typeset -g ZSRV_REDIS_DIR="${0:h}"
typeset -g ZSRV_REDIS_PID

if [[ -f "${ZSRV_REDIS_DIR}/redis.conf" ]]; then
    trap 'kill -INT $ZSRV_REDIS_PID; exit 0' HUP
    redis-server "${ZSRV_REDIS_DIR}/redis.conf" &; ZSRV_REDIS_PID=$!
    wait "$ZSRV_REDIS_PID"
elif [[ -f "${ZSRV_REDIS_DIR}/redis.conf.default" ]]; then
    trap 'kill -INT $ZSRV_REDIS_PID; exit 0' HUP
    redis-server "${ZSRV_REDIS_DIR}/redis.conf.default" &; ZSRV_REDIS_PID=$!
    wait "$ZSRV_REDIS_PID"
else
    print "No redis.conf found, redis-server did not run"
fi
