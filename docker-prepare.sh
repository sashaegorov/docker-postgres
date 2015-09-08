#!/bin/bash
set -e
set -x

# Checking variables
echo "Checking environment..."
echo "Lang: ${LANG}"
echo "Current directory: `pwd`"
echo "Current user: `whoami`"
echo "PostgreSQL version: ${PG_MAJOR}"
echo "PostgreSQL minor version: ${PG_VERSION}"
echo "PostgreSQL data directory: ${PGDATA}"
echo "PATH: ${PATH}"

# Add our user and group first to make sure their IDs get assigned
# consistently, regardless of whatever dependencies get added
echo 'Adding PostgreSQL user...'
groupadd -r postgres && useradd -r -g postgres postgres

echo 'Installing prerequisites...'
apt-get update
apt-get install -y --no-install-recommends ca-certificates
apt-get install -y --no-install-recommends wget

rm -rf /var/lib/apt/lists/*

echo 'Installing `gosu` utility...'
# grab gosu for easy step-down from root
# TODO: Don't know how to fix that right now
# gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)"

# wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" && \
# gpg --verify /usr/local/bin/gosu.asc && \
# rm /usr/local/bin/gosu.asc

chmod +x /usr/local/bin/gosu
apt-get purge -y --auto-remove ca-certificates wget

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
apt-get update
apt-get install -y locales
rm -rf /var/lib/apt/lists/*
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

mkdir /docker-entrypoint-initdb.d

# TODO: Don't know how to fix that right now
# apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

apt-get update
apt-get install -y --force-yes postgresql-common
sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf
apt-get install -y --force-yes postgresql-$PG_MAJOR=$PG_VERSION \
  postgresql-contrib-$PG_MAJOR=$PG_VERSION
rm -rf /var/lib/apt/lists/*

echo "Cleaning..."
apt-get clean

mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql
