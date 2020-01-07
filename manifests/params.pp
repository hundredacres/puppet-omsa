# Class: omsa::params
# ===========================
#
# Internal class to manage params defaults
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
class omsa::params {

  $apt_key = {
    id     => '42550ABD1E80D7C1BC0BAD851285491434D8786F',
    server => 'hkp://ha.pool.sks-keyservers.net:80',
  }

  $service_name      = 'dataeng'
  $service_enable    = true
  $service_ensure    = 'running'
  $install_storage   = true
  $install_webserver = false
  $install_rac4      = false
  $enable_snmp       = false
  $force_install     = false
  # aka idrac6
  $install_idrac     = false
  $install_idrac7    = false
  $install_idrac8    = false
  $install_all       = false

  case $::osfamily {
    'Debian': {
      $service_hasstatus  = true
      $service_hasrestart = true
      $install_rac5       = false
      $idrac6_package     = undef
      $idrac7_package     = 'srvadmin-idracadm7'
      $idrac8_package     = 'srvadmin-idracadm8'

      $omsa_version = $facts['osreleasemaj'] ? {
        '18' => '930',
        '16' => '910',
      }
    }
    'RedHat': {
      if versioncmp($::operatingsystemmajrelease, '7') >= 0 {
        # systemd
        $service_hasstatus  = true
        $service_hasrestart = true
      }
      $install_rac5   = true
      $idrac6_package = 'srvadmin-idrac'
      $idrac7_package = 'srvadmin-idrac7'
      $idrac8_package = undef
    }
    default: {
      $service_hasstatus  = true
      $service_hasrestart = true
      $install_rac5       = true
    }
  }
}
