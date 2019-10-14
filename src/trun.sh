#!/bin/sh

trap exit SIGTERM

# TODO This is a bit hardcodeded... What it do.
until $(wget http://localhost/api/v1/ping -O /dev/null); do
    printf '.'
    sleep 5
done

cp /proc/*/root/app/testcarfiles/* tcfiles/ || echo "Could not find /app/testcarfiles in any proc filespace"
for f in tcfiles/*.yml tcfiles/*.yaml
do
    echo "Running artillery for $f"
    artillery run $f
done
rm tcfiles/*
sleep 30