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

  if ( !( $::architecture =~ /^(amd|x86_)64$/ ) and !$::omsa::force_install ) {
    fail("Sorry, architecture ${::architecture} is not supported. Only x86_64|amd64")
  }

  case $::osfamily {
    'Debian': {

      require ::apt

			$repo_url = $facts['os']['osreleasemaj'] ? {
        '18'    => "http://linux.dell.com/repo/community/openmanage/${::omsa_version}/${::lsbdistcodename}",
				default => 'http://linux.dell.com/repo/community/ubuntu',
			}

			$repos = $facts['os']['osreleasemaj'] ? {
        '18'    => 'main',
				default => 'openmanage',
			}

      apt::source { 'dell-system-update':
        location       => $repo_url,
        release        => $::lsbdistcodename,
        repos          => $repos,
        key            => $::omsa::apt_key,
        include        => {
          src => false,
        },
        allow_unsigned => true,
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
