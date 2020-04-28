#!/bin/bash
if [ -f /run/ospd.pid ]; then
  echo "removing old ospd.pid"
  rm -f /run/ospd.pid
fi
psql_start_cmd="/usr/lib/postgresql/12/bin/postgres -D /var/lib/postgresql/12/main -c config_file=/etc/postgresql/12/main/postgresql.conf"
if ! ($(pidof postgres > /dev/null)); then
  su - postgres -c "${psql_start_cmd}" &
fi
sleep 3
if [ ! -f /init_gvmd_done ]; then
  /bin/bash /scripts/init.sh
fi
if ! ($(oidof redis-server > /dev/null)); then
  /usr/bin/redis-server /etc/redis/redis.conf &
fi
echo "Testing redis status..."
redissrv="$(redis-cli -s /tmp/redis.sock ping)"
while  [ "${redissrv}" != "PONG" ]; do
  echo "Redis not started..."
  sleep 5
  redissrv="$(redis-cli -s /tmp/redis.sock ping)"
done
sleep 3
echo "starting ospd scanner daemon"
if ! ($(pidof ospd-openvas > /dev/null)); then
  /usr/local/bin/ospd-openvas --config /root/.config/ospd.conf
fi
while [ ! -S /tmp/ospd.sock ]; do
  sleep 3
done
chown root:gvmd /tmp/ospd.sock
chmod g+w /tmp/ospd.sock
sleep 3
echo "starting Greenbone Vulnerability Manager"
if ! ($(pidof gvmd > /dev/null)); then
  su - gvmd -c "/usr/local/sbin/gvmd --database=gvmd --port2=1234 --listen2=127.0.0.1" &
fi
while [ ! -f /usr/local/var/lib/openvas/plugins/plugin_feed_info.inc ]; do
  su - gvmd -c "/bin/bash /scripts/sync_job.sh"
  sleep 5
done
echo "starting greenbone frontend"
/usr/local/sbin/gsad --foreground --mlisten=127.0.0.1 --mport=1234
