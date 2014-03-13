#!/bin/bash
#
# Authors: Roberto C. Morano <rcmorano<at>emergya.com>
#
# Copyright 2013, Junta de Andalucia
# http://www.juntadeandalucia.es/
#
# All rights reserved - EUPL License V 1.1
# http://www.osor.eu/eupl

export RUBY_VER=2.1.1
export CHEF_SERVER_VER=11.0.11
export GEM_DEPENDS="bundler"
export CHEF_REPO_NAME='gecoscc-chef-server-repo'
export CHEF_REPO_URL="https://github.com/gecos-team/${CHEF_REPO_NAME}.git"
grep -q "$HOSTNAME" /etc/hosts || sed -i "s|\(127.0.0.1.*\)|\1 $HOSTNAME|g" /etc/hosts

# install rvm and ruby

curl -L https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh 
rvm install ruby-$RUBY_VER
rvm use --default ruby-$RUBY_VER
gem install $GEM_DEPENDS --no-ri --no-rdoc

# install git
PLATFORM=$(ohai |grep platform_family|awk -F: '{print $2}'|sed 's|[", ]||g')

case $PLATFORM in
  "rhel")
    yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    yum install -y git
    ;;
  "debian")
    apt-get install -y git
    ;;
  *)
    echo "Platform not supported! Only 'rhel' and 'debian' are."
    echo "yes" | rvm implode
    exit 0
    ;;
esac


# create chef-solo config
cat > /tmp/solo.rb << EOF
root = File.absolute_path(File.dirname(__FILE__))

file_cache_path root
cookbook_path root + '/${CHEF_REPO_NAME}/cookbooks'
EOF

# create node's json
cat > /tmp/solo.json << EOF
{
    "run_list": [ "recipe[gecoscc-chef-server]" ],
    "gecoscc-chef-server": {
        "chef-server-version": '$CHEF_SERVER_VER'
    }
}
EOF

# cleanup tmp dirs just in case there were any from older intallation tries
LOCAL_CHEF_REPO="/tmp/${CHEF_REPO_NAME}"
test -d $LOCAL_CHEF_REPO && rm -rf $LOCAL_CHEF_REPO

# download chef-repo
git clone $CHEF_REPO_URL $LOCAL_CHEF_REPO
cd $LOCAL_CHEF_REPO
bundle install
git submodule init
git submodule update
for cookbook in cookbooks/*
do
  cd $cookbook
  test -f Berksfile && berks install
  cd -
done
cd

# link berks installed cookbooks to cookbook path removing version
for cookbook in /root/.berkshelf/cookbooks/*
do
  ln -s $cookbook $LOCAL_CHEF_REPO/cookbooks/$(echo $cookbook | sed 's|\(.*\)\(-.*\)|\1|g'|xargs basename)
done

# install software via cookbooks
chef-solo -c /tmp/solo.rb -j /tmp/solo.json 

# remove temporal rvm installation
echo "yes" | rvm implode

# finish chef-server installation
chef-server-ctl reconfigure
chef-server-ctl test
