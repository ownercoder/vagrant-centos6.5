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

user { 'nginx':
	groups => [ 'cloud' ],
	ensure => 'present',
	require => [ Group['cloud'] ],
}

file { '/home/cloud': 
	ensure => directory,
	owner => 'cloud',
	group => 'cloud',
	mode => 770,
	require => User['cloud']
}

#public_html files
file { '/home/cloud/public_html/index.php':
	mode => "0664",
	owner => 'cloud',
	group => 'cloud',
	source => 'puppet:///modules/public_html/index.php.inc',
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
$packages = [ 'php', 'php-cli' ]
$php_modules = [ 'php-gd', 'php-pdo', 'php-mysql', 'php-xml', 'php-mbstring' ]

package { $packages: ensure => 'installed' }
package { $php_modules: ensure => 'installed' }
Package { ensure => 'installed' }

#Nginx config
class { 'nginx':
	upstream => { 'apache' => [ 'server 127.0.0.1:8080' ] },
	index => 'index.php',
	user => 'nginx cloud',
}

nginx::file { 'cloud.lh.conf':
	source => 'puppet:///modules/nginx/cloud.lh.conf.inc',
}

#Apache config
apache_httpd { 'prefork':
	modules 	=> [ 
		'mime', 
		'setenvif', 
		'alias', 
		'proxy', 
		'cgi', 
		'rewrite', 
		'dir', 
		'auth_basic', 
		'authn_alias', 
		'autoindex', 
		'include',
		'mime_magic',
		'status',
		'vhost_alias',
		'version',
		'authz_host'
		],
	keepalive 	=> 'On',
	user 		=> 'apache',
	group 		=> 'cloud',
	welcome 	=> false,
	listen 		=> [ '127.0.0.1:8080' ],
}

apache_httpd::file { 'cloud.lh.conf':
	source => 'puppet:///modules/apache_httpd/cloud.lh.conf.inc',
}

apache_httpd::file { 'php.conf':
	source => 'puppet:///modules/apache_httpd/php.conf.inc',
}

#Firewall config
class { 'myfirewall':
}
