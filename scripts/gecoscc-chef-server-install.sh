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

curl -L https://get.rvm.io | bash -s stable --ruby
. /etc/profile.d/rvm.sh 
rvm use ruby-2.1.0
gem install chef --no-ri --no-rdoc

cat > /tmp/solo.rb << EOF
root = File.absolute_path(File.dirname(__FILE__))

file_cache_path root
cookbook_path root + '/cookbooks'
EOF

cat > /tmp/solo.json << EOF
{
    "run_list": [ "recipe[gecoscc-chef-server-cookbook::default]" ]
}
EOF

mkdir /tmp/cookbooks
wget -O /tmp/${COOKBOOK_NAME}.tar.gz https://api.github.com/repos/gecos-team/${COOKBOOK_NAME}/tarball 
tar -C /tmp/cookbooks -zxf /tmp/${COOKBOOK_NAME}.tar.gz
mv /tmp/cookbooks/*${COOKBOOK_NAME}* /tmp/cookbooks/${COOKBOOK_NAME}

chef-solo -c /tmp/solo.rb -j /tmp/solo.json 
echo "yes" | rvm implode

chef-server-ctl reconfigure
chef-server-ctl test
