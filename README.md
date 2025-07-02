# Setting up

1. sudo groupadd -g 10001 radicale
2. sudo useradd -u 10001 -g radicale -M -s /usr/sbin/nologin radicale
3. mkdir -p data/collections
4. chown -R radicale:radicale data
