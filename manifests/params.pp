# == Class: smartd::params
#
# This class should be considered private.
#
# === Authors
#
# Sam McLeod
# https://github.com/sammcj/puppet-smartd
#
# Adapted from Joshua Hoblitt <jhoblitt@cpan.org>'s module
#

class smartd::params {
  $package_name       = 'smartmontools'
  $service_ensure     = 'running'
  $manage_service     = true
  $devicescan         = true
  $devicescan_options = undef
  $devices            = []
  $mail_to            = 'root'
  $warning_schedule   = 'daily' # other choices: once, diminishing, exec
  $exec_script        = false
  $default_options    = undef
  $enable_default      = true  # smartd.conf < 5.43 does not support the 'DEFAULT' directive

  case $::osfamily {
    'FreeBSD': {
      $config_file = '/usr/local/etc/smartd.conf'
      $service_name = 'smartd'
    }
    'RedHat': {
      $config_file = $::operatingsystem ? {
        # lint:ignore:80chars
        'Fedora'                                       => $::operatingsystemrelease ? {
          /16|17|18/ => '/etc/smartd.conf',
          default                      => '/etc/smartmontools/smartd.conf',
        },
        /RedHat|CentOS|Scientific|SLC|OracleLinux|OEL/ => $::operatingsystemmajrelease ? {
          /5|6/ => '/etc/smartd.conf',
          default => '/etc/smartmontools/smartd.conf',
        },
        default                                        => '/etc/smartd.conf',
        # lint:endignore
      }
      $service_name = 'smartd'
    }
    'SuSE': {
      $config_file = '/etc/smartd.conf'
      $service_name = 'smartd'
    }
    'Debian': {
      $config_file = '/etc/smartd.conf'
      $service_name = 'smartmontools'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
