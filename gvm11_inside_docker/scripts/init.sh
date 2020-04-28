#!/bin/bash
/usr/bin/redis-server /etc/redis/redis.conf &
echo "Testing redis status..."
redissrv="$(redis-cli -s /tmp/redis.sock ping)"
while  [ "${redissrv}" != "PONG" ]; do
  echo "Redis not started..."
  sleep 5
  redissrv="$(redis-cli -s /tmp/redis.sock ping)"
done
su - gvmd -c '/usr/local/sbin/gvmd --database=gvmd --port2=1234 --listen2=127.0.0.1' &
sleep 3
if [ ! -d /usr/local/var/lib/gvm/CA ]; then
  gvm-manage-certs -a
fi
redis-cli -s /tmp/redis.sock shutdown
sleep 3
kill $(pidof redis-server)
echo "init gvmd done" > /init_gvmd_done
