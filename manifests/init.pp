# == Class: afs
#
# Full description of class afs here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'afs':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <ivano.talamo@roma1.infn.it>
#
# === Copyright
#
# Copyright 2015 Ivano Talamo, unless otherwise noted.
#
class afs (
  $cell,
  $krb5_file = undef
  )
  inherits afs::params {

  package{$afs_client_packages:
    ensure => installed,
  }

  file {$cell_file:
    ensure  => present,
    content => "${cell}
",
    require => Package[$afs_client_packages]
  }

  file {$init_script:
    ensure  => present,
    source  => "puppet:///modules/afs/afs.sl${lsbmajdistrelease}",
    require => Package[$afs_client_packages]
  }

  if ($krb5_file) {
    file{'/etc/krb5.conf':
      ensure => present,
      source => $krb5_file,
      notify => Service['afs']
    }
  }
  
  service {'afs':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require => File[$init_script]
  }
  
}
