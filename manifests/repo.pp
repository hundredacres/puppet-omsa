# Class: omsa::repositories
# ===========================
#
# This class activate the needed Dell repositories to install OMSA
#
# Authors
# -------
#
# Davide Ferrari <vide80@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2016 Davide Ferrari, unless otherwise noted.
#
class omsa::repo() inherits omsa::params {

  Exec {
    path => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd  => '/',
  }

  if !( $::architecture =~ /^(amd|x86_)64$/ ) {
    fail("Sorry, architecture ${::architecture} is not supported. Only x86_64|amd64")
  }

  case $::osfamily {
    'Debian': {

      require ::apt

      apt::source { 'dell-system-update':
        location => 'http://linux.dell.com/repo/community/ubuntu',
        release  => $::lsbdistcodename,
        repos    => 'openmanage',
        key      => $::omsa::apt_key,
        include  => {
          src => false,
        },
      }
    }
    'RedHat': {

      yumrepo { 'dsu-system-independent':
        descr    => 'dell-system-update_independent',
        baseurl  => 'http://linux.dell.com/repo/hardware/dsu/os_independent/',
        gpgcheck => 1,
        gpgkey   => 'http://linux.dell.com/repo/hardware/dsu/public.key',
        enabled  => 1,
        exclude  => 'dell-system-update*.i386',
      }

      yumrepo { 'dsu-system-dependent':
        descr    => 'dell-system-update_dependent',
        baseurl  => "http://linux.dell.com/repo/hardware/dsu/os_dependent/RHEL${::operatingsystemmajrelease}_64",
        gpgcheck => 1,
        gpgkey   => 'http://linux.dell.com/repo/hardware/dsu/public.key',
        enabled  => 1,
      }
    }
    default: {
      fail("${::osfamily}: Operating system not (yet) supported by this OMSA module")
    }
  }
}
