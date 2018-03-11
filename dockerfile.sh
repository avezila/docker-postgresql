#!/bin/bash
set -e
set -v

APT_PREREMOVE=$(cat <<'EOF'
    wget
    net-tools
    ca-certificates
    unzip
    apt-transport-https
    software-properties-common
    apt-utils
EOF
)
APT_INSTALL=$(cat <<'EOF'
    postgrespro-std-10-client
    postgrespro-std-10-server
    sudo
    postgrespro-std-10-contrib
    postgrespro-std-10-libs
    postgrespro-std-10-pgprobackup
    postgrespro-std-10-dev
    python3.7
    python3-pip
    python3.7-dev
    python3-dev
    python-setuptools
    python3
    libpq-dev
EOF
)
APT_REMOVE=$(cat <<'EOF'
    acl
    libicu-dev
    git
    bison
    flex
    libyaml-cpp-dev
    gcc
EOF
)
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests $APT_PREINSTALL $APT_PREREMOVE
    

sh -c 'echo "deb http://repo.postgrespro.ru/pgpro-10/ubuntu artful main" > /etc/apt/sources.list.d/postgrespro.list'
wget --quiet -O - http://repo.postgrespro.ru/pgpro-10/keys/GPG-KEY-POSTGRESPRO | apt-key add -

DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:ubuntu-toolchain-r/test
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-suggests $APT_INSTALL $APT_REMOVE

pip3 install yandex-pgmigrate pgcli
pip3 install six
rm -rf .cache/pip

ln -sf ${PG_DATADIR}/postgresql.conf ${PG_BIN_ROOT}/share/postgresql.conf
ln -sf ${PG_DATADIR}/pg_hba.conf ${PG_BIN_ROOT}/share/pg_hba.conf
ln -sf ${PG_DATADIR}/pg_ident.conf ${PG_BIN_ROOT}/share/pg_ident.conf
rm -rf ${PG_HOME}

locale-gen en_US.utf8
locale-gen ru_RU.utf8
update-locale



cd ~
git clone https://github.com/postgrespro/rum
cd rum
make USE_PGXS=1
make USE_PGXS=1 install
cd ..
rm -rf ./rum

git clone https://github.com/postgrespro/jsquery.git
cd jsquery
make USE_PGXS=1
make USE_PGXS=1 install
cd ..
rm -rf jsquery

#DEBIAN_FRONTEND=noninteractive apt-get purge -y $APT_PREREMOVE $APT_REMOVE
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
DEBIAN_FRONTEND=noninteractive apt-get clean

rm -rf /root/.cache
rm -rf   /var/cache /var/lib/apt /var/lib/dpkg /usr/share/man /usr/lib/x86_64-linux-gnu/perl-base
rm -rf $(find / | grep __pycache__)
