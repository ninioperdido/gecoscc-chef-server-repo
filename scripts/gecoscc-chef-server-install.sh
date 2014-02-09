#!/bin/bash
#
# Authors: Roberto C. Morano <rcmorano<at>emergya.com>
#
# Copyright 2013, Junta de Andalucia
# http://www.juntadeandalucia.es/
#
# All rights reserved - EUPL License V 1.1
# http://www.osor.eu/eupl

export COOKBOOK_NAME='gecoscc-chef-server-cookbook'
grep "$HOSTNAME" /etc/hosts || sed -i "s|\(127.0.0.1.*\)|\1 $HOSTNAME|g" /etc/hosts

curl -L https://get.rvm.io | bash -s stable --ruby
. /etc/profile.d/rvm.sh 
rvm use --default $(rvm current)
gem install chef --no-ri --no-rdoc

cat > /tmp/solo.rb << EOF
root = File.absolute_path(File.dirname(__FILE__))

file_cache_path root
cookbook_path root + '/cookbooks'
EOF

cat > /tmp/solo.json << EOF
{
    "run_list": [ "recipe[${COOKBOOK_NAME}::default]" ]
}
EOF

test -d /tmp/cookbooks && rm -rf /tmp/cookbooks
mkdir /tmp/cookbooks
curl -o /tmp/${COOKBOOK_NAME}.tar.gz https://api.github.com/repos/gecos-team/${COOKBOOK_NAME}/tarball 
tar -C /tmp/cookbooks -zxf /tmp/${COOKBOOK_NAME}.tar.gz
mv /tmp/cookbooks/*${COOKBOOK_NAME}* /tmp/cookbooks/${COOKBOOK_NAME}

chef-solo -c /tmp/solo.rb -j /tmp/solo.json 
echo "yes" | rvm implode

chef-server-ctl reconfigure
chef-server-ctl test
