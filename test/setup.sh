#!/bin/sh

# WordPress test setup script for Travis CI
#
# Author: Benjamin J. Balter ( ben@balter.com | ben.balter.com )
# License: GPL3

export WP_CORE_DIR=/tmp/wordpress
export WP_TESTS_DIR=/tmp/wordpress-tests

# Init database
mysql -e 'CREATE DATABASE wordpress_test;' -uroot

# Grab specified version of WordPress from github
wget -nv -O /tmp/wordpress.tar.gz https://github.com/WordPress/WordPress/tarball/$WP_VERSION
mkdir -p $WP_CORE_DIR
tar --strip-components=1 -zxmf /tmp/wordpress.tar.gz -C $WP_CORE_DIR

# Grab testing framework
svn co --quiet --ignore-externals http://unit-tests.svn.wordpress.org/trunk/ $WP_TESTS_DIR

# Put various components in proper folders
plugin_slug=$(basename $(pwd))
plugin_dir=$WP_CORE_DIR/wp-content/plugins/$plugin_slug

#move plugin itself into place
cd ..
mv $plugin_slug $plugin_dir

#put shell in plugin folder
cd $plugin_dir

# Install config for travis
cp test/unittests-config.php.travis test/unittests-config.php