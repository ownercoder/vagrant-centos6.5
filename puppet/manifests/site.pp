# -*- mode: ruby -*-
# vi: set ft=ruby :

#Group creation
group { 'cloud': ensure => present }
group { 'users': ensure => present }

#User creation
user { 'cloud':
	groups => [ 'cloud', 'users' ],
	ensure => 'present',
	home => '/home/cloud',
	shell => '/bin/bash',
	managehome => true,
	require => [ Group['cloud'], Group['users'] ],
}

#Folder creation
file { '/home/cloud/public_html': 
	ensure => directory,
	owner => 'cloud',
	group => 'cloud',
	mode => 755,
	require => User['cloud']
}

#Packages install
$packages = [ 'php', 'httpd', 'php-cli' ]
$php_modules = [ 'php-gd', 'php-pdo', 'php-mysql', 'php-xml', 'php-mbstring' ]

package { $packages: ensure => 'installed' }
package { $php_modules: ensure => 'installed' }
Package { ensure => 'installed' }

include nginx
nginx::file { 'cloud.lh.conf':
	source => 'puppet:///modules/nginx/cloud.lh.conf.inc',
}
